using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;

SDL.Render.Texture? texture = null;
int texture_width = 0;
int texture_height = 0;
SDL.Render.Texture? converted_texture = null;
int converted_texture_width = 0;
int converted_texture_height = 0;

SDL.Rect.FRect dst_rect;
SDL.Rect.FPoint center;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer Example 17 - Read Pixels", "1.0",
                               "dev.vala.example.renderer-17-read-pixels");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 17 - Read Pixels",
                                                     WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    // Textures are pixel data that we upload to the video hardware for fast drawing. Lots of 2D engines refer to these
    // as "sprites." We'll do a static texture (upload once, draw many times) with data from a bitmap file.

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

        uint64 now = SDL.Timer.get_ticks ();
        SDL.Surface.Surface? surface_read = null;
        SDL.Surface.Surface? converted_surface = null;

        // We'll have a texture rotate around over 2 seconds (2000 milliseconds). 360 degrees in a circle!
        float rotation = (((float) ((int) (now % 2000))) / 2000.0f) * 360.0f;

        // Black, full alpha
        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            // Center this one, and draw it with some rotation so it spins!
            dst_rect.x = ((float) (WINDOW_WIDTH - texture_width)) / 2.0f;
            dst_rect.y = ((float) (WINDOW_HEIGHT - texture_height)) / 2.0f;
            dst_rect.w = (float) texture_width;
            dst_rect.h = (float) texture_height;
            // Rotate it around the center of the texture; you can rotate it from a different point, too!
            center.x = texture_width / 2.0f;
            center.y = texture_height / 2.0f;
            SDL.Render.render_texture_rotated (renderer,
                                               texture,
                                               null,
                                               dst_rect,
                                               rotation,
                                               center,
                                               SDL.Surface.FlipMode.NONE);

            // This next whole thing is _super_ expensive. Seriously, don't do this in real life.

            // Download the pixels of what has just been rendered. This has to wait for the GPU to finish rendering it
            // and everything before it, and then make an expensive copy from the GPU to system RAM!
            surface_read = SDL.Render.render_read_pixels (renderer, null);
            // This is also expensive, but easier: convert the pixels to a format we want.
            if (surface_read != null && (surface_read.format != SDL.Pixels.PixelFormat.RGBA8888)
                && (surface_read.format != SDL.Pixels.PixelFormat.BGRA8888)) {
                converted_surface = SDL.Surface.convert_surface (surface_read, SDL.Pixels.PixelFormat.RGBA8888);
            } else {
                converted_surface = SDL.Surface.create_surface (texture_width, texture_height, SDL.Pixels.PixelFormat.RGBA8888);
                SDL.Surface.blit_surface (surface_read, null, converted_surface, null);
            }
            SDL.Surface.destroy_surface (surface_read);

            if (converted_surface != null) {
                // Rebuild converted_texture if the dimensions have changed (window resized, etc).
                if ((converted_surface.w != converted_texture_width) || (converted_surface.h != converted_texture_height)) {
                    SDL.Render.destroy_texture (converted_texture);
                    converted_texture = SDL.Render.create_texture (
                                                                   renderer,
                                                                   SDL.Pixels.PixelFormat.RGBA8888,
                                                                   SDL.Render.TextureAccess.STREAMING,
                                                                   converted_surface.w,
                                                                   converted_surface.h);
                    if (converted_texture == null) {
                        SDL.Log.log ("Couldn't (re)create conversion texture: %s", SDL.Error.get_error ());
                        return 1;
                    }

                    converted_texture_width = converted_surface.w;
                    converted_texture_height = converted_surface.h;
                }

                // Turn each pixel into either black or white. This is a lousy technique but it works here. In real life,
                // something like Floyd-Steinberg dithering might work better:
                // https://en.wikipedia.org/wiki/Floyd%E2%80%93Steinberg_dithering

                // Vala specific note: Pointer arithmetic is not something you want to do in Vala. But pixel
                // manipulation in SDL kinda requiers it. So we bacially doe the same thing got running based on the
                // original SDL3 sample
                for (int y = 0; y < converted_surface.h; y++) {
                    unowned uint32[] pixels = (uint32[]) (((uint8*) converted_surface.pixels)
                                                          + (y * converted_surface.pitch));
                    for (int x = 0; x < converted_surface.w; x++) {
                        unowned uint8[] p = (uint8[]) (&pixels[x]);
                        uint32 average = (((uint32) p[1]) + ((uint32) p[2]) + ((uint32) p[3])) / 3;
                        if (average == 0) {
                            // Make pure black pixels red.
                            p[0] = p[3] = 0xFF; p[1] = p[2] = 0;
                        } else {
                            // Make everything else either black or white.
                            p[1] = p[2] = p[3] = (average > 50) ? 0xFF : 0x00;
                        }
                    }
                }
            }

            // Upload the processed pixels back into a texture.
            SDL.Render.update_texture (converted_texture, null, converted_surface.pixels, converted_surface.pitch);
            SDL.Surface.destroy_surface (converted_surface);

            // Draw the texture to the top-left of the screen.
            dst_rect.x = dst_rect.y = 0.0f;
            dst_rect.w = ((float) WINDOW_WIDTH) / 4.0f;
            dst_rect.h = ((float) WINDOW_HEIGHT) / 4.0f;
            SDL.Render.render_texture (renderer, converted_texture, null, dst_rect);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_texture (texture);
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}