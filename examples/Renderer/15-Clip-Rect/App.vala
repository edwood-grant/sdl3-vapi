using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;
const int CLIPRECT_SIZE = 250;
const int CLIPRECT_SPEED = 200; // Pixels per second

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;
SDL.Render.Texture? texture = null;

SDL.Rect.FPoint cliprect_position = {};
SDL.Rect.FPoint cliprect_direction = {};
uint64 last_time = 0;

// A lot of this program is Renderer/02-Primitives, so we have a good visual
// that we can slide a clip rect around. The actual new magic in here is the
// SDL.Render.set_render_clip_rect () function.

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer Example 15 - Clip Rect", "1.0",
                               "dev.vala.example.renderer-15-clip-rect");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 15 - Clip Rect",
                                                     WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    cliprect_direction.x = cliprect_direction.y = 1.0f;
    last_time = SDL.Timer.get_ticks ();

    // Textures are pixel data that we upload to the video hardware for fast drawing. Lots of 2D
    // engines refer to these as "sprites." We'll do a static texture (upload once, draw many times)
    // with data from a bitmap file.

    // SDL_Surface is pixel data the CPU can access. SDL_Texture is pixel data the GPU can access.
    // Load a .bmp into a surface, move it to a texture from there.
    var bmp_path = SDL.FileSystem.get_base_path () + "sample.bmp";
    var surface = SDL.Surface.load_bmp (bmp_path);
    if (surface == null) {
        SDL.Log.log ("Couldn't load bitmap: %s", SDL.Error.get_error ());
        return 1;
    }

    texture = SDL.Render.create_texture_from_surface (renderer, surface);
    if (texture == null) {
        SDL.Log.log ("Couldn't create static texture: %s", SDL.Error.get_error ());
        return 1;
    }

    // Done with this, the texture has a copy of the pixels now.
    SDL.Surface.destroy_surface (surface);

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        SDL.Rect.Rect cliprect = {
            (int) SDL.StdInc.roundf (cliprect_position.x),
            (int) SDL.StdInc.roundf (cliprect_position.y),
            CLIPRECT_SIZE,
            CLIPRECT_SIZE
        };

        var now = SDL.Timer.get_ticks ();
        var elapsed = ((float) (now - last_time)) / 1000.0f; /* seconds since last iteration */
        var distance = elapsed * CLIPRECT_SPEED;

        /* Set a new clipping rectangle position */
        cliprect_position.x += distance * cliprect_direction.x;
        if (cliprect_position.x < 0.0f) {
            cliprect_position.x = 0.0f;
            cliprect_direction.x = 1.0f;
        } else if (cliprect_position.x >= (WINDOW_WIDTH - CLIPRECT_SIZE)) {
            cliprect_position.x = (WINDOW_WIDTH - CLIPRECT_SIZE) - 1;
            cliprect_direction.x = -1.0f;
        }

        cliprect_position.y += distance * cliprect_direction.y;
        if (cliprect_position.y < 0.0f) {
            cliprect_position.y = 0.0f;
            cliprect_direction.y = 1.0f;
        } else if (cliprect_position.y >= (WINDOW_HEIGHT - CLIPRECT_SIZE)) {
            cliprect_position.y = (WINDOW_HEIGHT - CLIPRECT_SIZE) - 1;
            cliprect_direction.y = -1.0f;
        }
        SDL.Render.set_render_clip_rect (renderer, cliprect);

        last_time = now;

        // Okay, now draw!

        // Note that SDL_RenderClear is _not_ affected by the clipping rectangle!
        // Grey, full alpha
        SDL.Render.set_render_draw_color (renderer, 33, 33, 33, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            SDL.Render.render_texture (renderer, texture, null, null);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_texture (texture);
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}