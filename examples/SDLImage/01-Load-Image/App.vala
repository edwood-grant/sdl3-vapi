using SDL3;
using SDL3.Image;

// A test application for the SDL image loading library.
// You can drag and drop images and it will show them in screen

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;
const string APPLICATION_TITLE = "SDL3 Image Vala 01 - Load Image";

SDL3.Video.Window? window = null;
SDL3.Render.Renderer ? renderer = null;

SDL3.Render.Texture ? texture = null;
SDL3.Rect.FRect dst_rect;
string? file_path = null;

// Draw a Gimpish background pattern to show transparency in the image
void draw_background (SDL3.Render.Renderer enderer, int w, int h) {
    SDL3.Pixels.Color col[2] = {
        { 0x66, 0x66, 0x66, 0xff },
        { 0x99, 0x99, 0x99, 0xff },
    };

    var rect = SDL3.Rect.FRect ();
    const int DX = 8, DY = 8;
    rect.w = DX;
    rect.h = DY;

    for (int y = 0; y < h; y += DY) {
        for (int x = 0; x < w; x += DX) {
            /* use an 8x8 checkerboard pattern */
            int i = (((x ^ y) >> 3) & 1);
            SDL3.Render.set_render_draw_color (renderer, col[i].r, col[i].g, col[i].b, col[i].a);
            rect.x = (float) x;
            rect.y = (float) y;
            SDL3.Render.render_fill_rect (renderer, rect);
        }
    }
}

public int main (string[] args) {
    SDL3.Init.set_app_metadata (APPLICATION_TITLE, "1.0",
                                "dev.vala.example.sdl-image-01-load-image");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer (APPLICATION_TITLE,
                                                      WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    bool is_running = true;
    SDL3.Events.Event ev;
    while (is_running) {
        while (SDL3.Events.poll_event (out ev)) {
            switch (ev.type) {
            case SDL3.Events.EventType.QUIT :
                is_running = false;
                break;
            case SDL3.Events.EventType.DROP_TEXT :
                file_path = ev.drop.data;
                // Remove the file:// URI protocol and unescape
                file_path = file_path.replace ("file://", "");
                file_path = GLib.Uri.unescape_string (file_path);

                SDL3.Render.destroy_texture (texture);
                SDL3.Log.log ("Loading %s\n", file_path);

                texture = SDL3.Image.load_texture (renderer, file_path);
                if (texture == null) {
                    SDL3.Log.log ("Couldn't load %s: %s\n", file_path, SDL3.Error.get_error ());
                    break;
                }
                SDL3.Video.set_window_title (window, APPLICATION_TITLE + " " + file_path);
                break;
                default :
                break;
            }
        }

        // Center the loaded image
        if (texture != null) {
            dst_rect.w = texture.w;
            dst_rect.h = texture.h;
            dst_rect.x = (WINDOW_WIDTH - dst_rect.w) / 2.0f;
            dst_rect.y = (WINDOW_HEIGHT - dst_rect.h) / 2.0f;
        }

        SDL3.Render.set_render_scale (renderer, 1f, 1f);
        SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            // Draw a bagkround pattern
            draw_background (renderer, WINDOW_WIDTH, WINDOW_HEIGHT);

            // Draw the drag and dropped image
            if (texture != null) {
                SDL3.Render.render_texture (renderer, texture, null, dst_rect);
            }

            // Draw text instructions
            // Instructions box
            SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_fill_rect (renderer, { 0, 15, WINDOW_WIDTH, 60 });
            // Instructions text
            SDL3.Render.set_render_scale (renderer, 2.0f, 2.0f);
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 0, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_debug_text (renderer, 10, 10, "Drag and drop an image to show it.");

            SDL3.Render.set_render_scale (renderer, 1.25f, 1.25f);
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_debug_text (renderer, 15, 35, "Try AVIF, BMP, GIF, JPEG, JPEG-XL, LBM, PCX, PNG, ");
            SDL3.Render.render_debug_text (renderer, 15, 47, "PNM (PPM/PGM/PBM), QOI, SVG, TIFF, TGA, XCF, XPM, WebP");

            // Draw error if failed
            if (texture == null && file_path != null) {
                // Error box
                SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
                SDL3.Render.render_fill_rect (renderer, { 0, 70, WINDOW_WIDTH, 35 });
                // Error text
                SDL3.Render.set_render_scale (renderer, 1.25f, 1.25f);
                SDL3.Render.set_render_draw_color (renderer, 255, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
                SDL3.Render.render_debug_text_format (renderer, 10, 75,
                                                      "Couldn't load: ");
                SDL3.Render.render_debug_text_format (renderer, 10, 85, "%s", file_path);
                SDL3.Render.render_debug_text_format (renderer, 10, 95, "Check print log error details");
            }
        }
        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}