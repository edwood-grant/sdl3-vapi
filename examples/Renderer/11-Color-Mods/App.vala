using SDL3;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;
SDL3.Render.Texture? texture = null;
int texture_width = 0;
int texture_height = 0;

SDL3.Rect.FRect dst_rect;

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Renderer Example 11 - Color Mods", "1.0",
                                "dev.vala.example.renderer-11-color-mods");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 11 - Color Mods",
                                                      WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    /* Textures are pixel data that we upload to the video hardware for fast drawing. Lots of 2D
       engines refer to these as "sprites." We'll do a static texture (upload once, draw many
       times) with data from a bitmap file. */

    /* SDL_Surface is pixel data the CPU can access. SDL_Texture is pixel data the GPU can access.
       Load a .bmp into a surface, move it to a texture from there. */
    var bmp_path = SDL3.FileSystem.get_base_path () + "sample.bmp";
    var surface = SDL3.Surface.load_bmp (bmp_path);
    if (surface == null) {
        SDL3.Log.log ("Couldn't load bitmap: %s", SDL3.Error.get_error ());
        return 1;
    }

    texture_width = surface.w;
    texture_height = surface.h;

    texture = SDL3.Render.create_texture_from_surface (renderer, surface);
    if (texture == null) {
        SDL3.Log.log ("Couldn't create static texture: %s", SDL3.Error.get_error ());
        return 1;
    }

    // Done with this, the texture has a copy of the pixels now.
    SDL3.Surface.destroy_surface (surface);

    bool is_running = true;
    SDL3.Events.Event ev;
    while (is_running) {
        while (SDL3.Events.poll_event (out ev)) {
            if (ev.type == SDL3.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        // Convert from milliseconds to seconds.
        double now = ((double) SDL3.Timer.get_ticks ()) / 1000.0;

        // Choose the modulation values for the center texture. The sine wave trick makes it fade
        // between colors smoothly.
        float red = (float) (0.5 + 0.5 * SDL3.StdInc.sin (now));
        float green = (float) (0.5 + 0.5 * SDL3.StdInc.sin (now + SDL3.StdInc.PI_D * 2 / 3));
        float blue = (float) (0.5 + 0.5 * SDL3.StdInc.sin (now + SDL3.StdInc.PI_D * 4 / 3));

        // Black, full alpha
        SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            // Just draw the static texture a few times. You can think of it like a stamp, there
            // isn't a limit to the number of times you can draw with it.

            // Color modulation multiplies each pixel's red, green, and blue intensities by the mod
            // values, so multiplying by 1.0f will leave a color intensity alone, 0.0f will shut off
            // that color completely, etc.

            // Top left; let's make this one blue!
            dst_rect.x = 0.0f;
            dst_rect.y = 0.0f;
            dst_rect.w = (float) texture_width;
            dst_rect.h = (float) texture_height;
            // Kill all red and green.
            SDL3.Render.set_texture_color_mod_float (texture, 0.0f, 0.0f, 1.0f);
            SDL3.Render.render_texture (renderer, texture, null, dst_rect);

            // Center this one, and have it cycle through red/green/blue modulations.
            dst_rect.x = ((float) (WINDOW_WIDTH - texture_width)) / 2.0f;
            dst_rect.y = ((float) (WINDOW_HEIGHT - texture_height)) / 2.0f;
            dst_rect.w = (float) texture_width;
            dst_rect.h = (float) texture_height;
            SDL3.Render.set_texture_color_mod_float (texture, red, green, blue);
            SDL3.Render.render_texture (renderer, texture, null, dst_rect);

            // bottom right; let's make this one red!
            dst_rect.x = (float) (WINDOW_WIDTH - texture_width);
            dst_rect.y = (float) (WINDOW_HEIGHT - texture_height);
            dst_rect.w = (float) texture_width;
            dst_rect.h = (float) texture_height;
            // Fill all green and blue.
            SDL3.Render.set_texture_color_mod_float (texture, 1.0f, 0.0f, 0.0f);
            SDL3.Render.render_texture (renderer, texture, null, dst_rect);
        }
        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_texture (texture);
    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}