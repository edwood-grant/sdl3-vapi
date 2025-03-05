using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;
SDL.Render.Texture? texture = null;
int texture_width = 0;
int texture_height = 0;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer Example 14 - Viewport", "1.0",
                               "dev.vala.example.renderer-14-viewport");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 14 - Viewport",
                                                     WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

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

    texture_width = surface.w;
    texture_height = surface.h;

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

        SDL.Rect.FRect dst_rect = { 0, 0, (float) texture_width, (float) texture_height };
        SDL.Rect.Rect viewport = {};

        // Setting a viewport has the effect of limiting the area that rendering can happen, and
        // making coordinate (0, 0) live somewhere else in the window. It does _not_ scale rendering
        // to fit the viewport.

        // Black, full alpha
        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            // Draw once with the whole window as the viewport.
            viewport.x = 0;
            viewport.y = 0;
            viewport.w = WINDOW_WIDTH / 2;
            viewport.h = WINDOW_HEIGHT / 2;
            // Null means "use the whole window"
            SDL.Render.set_render_viewport (renderer, null);
            SDL.Render.render_texture (renderer, texture, null, dst_rect);

            // Top right quarter of the window.
            viewport.x = WINDOW_WIDTH / 2;
            viewport.y = WINDOW_HEIGHT / 2;
            viewport.w = WINDOW_WIDTH / 2;
            viewport.h = WINDOW_HEIGHT / 2;
            SDL.Render.set_render_viewport (renderer, viewport);
            SDL.Render.render_texture (renderer, texture, null, dst_rect);

            // Bottom 20% of the window. Note it clips the width! */
            viewport.x = 0;
            viewport.y = WINDOW_HEIGHT - (WINDOW_HEIGHT / 5);
            viewport.w = WINDOW_WIDTH / 5;
            viewport.h = WINDOW_HEIGHT / 5;
            SDL.Render.set_render_viewport (renderer, viewport);
            SDL.Render.render_texture (renderer, texture, null, dst_rect);

            // What happens if you try to draw above the viewport? It should clip!
            viewport.x = 100;
            viewport.y = 200;
            viewport.w = WINDOW_WIDTH;
            viewport.h = WINDOW_HEIGHT;
            SDL.Render.set_render_viewport (renderer, viewport);
            dst_rect.y = -50;
            SDL.Render.render_texture (renderer, texture, null, dst_rect);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_texture (texture);
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}