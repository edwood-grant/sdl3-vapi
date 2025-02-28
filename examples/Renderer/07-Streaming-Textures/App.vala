using SDL3;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;
const int TEXTURE_SIZE = 150;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

SDL3.Render.Texture? texture = null;
SDL3.Surface.Surface? surface = null;
SDL3.Rect.FRect dst_rect;

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Renderer Example 07 - Streaming Textures", "1.0",
                                "dev.vala.example.renderer-07-streaming-textures");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 07 - Streaming Textures",
                                                      WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    texture = SDL3.Render.create_texture (renderer,
                                          Pixels.PixelFormat.RGBA8888,
                                          SDL3.Render.TextureAccess.STREAMING,
                                          TEXTURE_SIZE, TEXTURE_SIZE);
    if (texture == null) {
        SDL3.Log.log ("Couldn't create streaming texture: %s", SDL3.Error.get_error ());
        return 1;
    }

    bool is_running = true;
    SDL3.Events.Event ev;
    while (is_running) {
        while (SDL3.Events.poll_event (out ev)) {
            if (ev.type == SDL3.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        uint64 now = SDL3.Timer.get_ticks ();
        // We'll have some textures move around over a few seconds.
        float direction = ((now % 2000) >= 1000) ? 1.0f : -1.0f;
        float scale = ((float) (((int) (now % 1000)) - 500) / 500.0f) * direction;

        /* To update a streaming texture, you need to lock it first. This gets you access to the pixels.
           Note that this is considered a _write-only_ operation: the buffer you get from locking
           might not acutally have the existing contents of the texture, and you have to write to every
           locked pixel! */

        /* You can use SDL_LockTexture() to get an array of raw pixels, but we're going to use
           SDL_LockTextureToSurface() here, because it wraps that array in a temporary SDL_Surface,
           letting us use the surface drawing functions instead of lighting up individual pixels. */
        var locked = SDL3.Render.lock_texture_to_surface (texture, null, out surface);
        if (locked) {
            SDL3.Rect.Rect r = SDL3.Rect.Rect ();
            SDL3.Surface.fill_surface_rect (surface,
                                            null,
                                            SDL3.Surface.map_surface_rgb (surface, 0, 0, 0));

            r.w = TEXTURE_SIZE;
            r.h = TEXTURE_SIZE / 10;
            r.x = 0;
            r.y = (int) (((float) (TEXTURE_SIZE - r.h)) * ((scale + 1.0f) / 2.0f));
            // make a strip of the surface green
            SDL3.Surface.fill_surface_rect (surface, r, SDL3.Surface.map_surface_rgb (surface, 0, 255, 0));
            // upload the changes (and frees the temporary surface)!
            SDL3.Render.unlock_texture (texture);
        }

        // Gray, full alpha
        SDL3.Render.set_render_draw_color (renderer, 66, 66, 66, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            /* Just draw the static texture a few times. You can think of it like a
               stamp, there isn't a limit to the number of times you can draw with it. */

            /* Center this one. It'll draw the latest version of the texture we drew while it was locked. */
            dst_rect.x = ((float) (WINDOW_WIDTH - TEXTURE_SIZE)) / 2.0f;
            dst_rect.y = ((float) (WINDOW_HEIGHT - TEXTURE_SIZE)) / 2.0f;
            dst_rect.w = dst_rect.h = (float) TEXTURE_SIZE;
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