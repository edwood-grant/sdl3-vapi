using SDL3;
using SDL3.Image;

// A test application to load animated images You can drag and drop images and
// it will show them in screen.
//
// Currently only WEBP and GIF animated images are supported. Normal images will
// load with just one frame in the Animation class

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;
const string APPLICATION_TITLE = "SDL3 Image Vala 02 - Load Animation";

SDL3.Video.Window? window = null;
SDL3.Render.Renderer ? renderer = null;

string? file_path = null;

SDL3.Image.Animation ? animation = null;
SDL3.Render.Texture[] ? textures = null;
SDL3.Rect.FRect dst_rect;

int current_animation_frame = 0;
uint64 current_animation_delay = 0;
uint64 previous_time = 0;

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
                                "dev.vala.example.sdl-image-02-load-animation");

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
                // Remove the file:// URI protocol and unescape the URI
                file_path = file_path.replace ("file://", "");
                file_path = GLib.Uri.unescape_string (file_path);

                SDL3.Image.free_animation (animation);
                foreach (unowned var tex in textures) {
                    SDL3.Render.destroy_texture (tex);
                }
                textures.resize (0);
                current_animation_frame = 0;
                current_animation_delay = 0;

                SDL3.Log.log ("Loading %s\n", file_path);
                animation = SDL3.Image.load_animation (file_path);
                if (animation == null) {
                    SDL3.Log.log ("Couldn't load animation %s: %s\n", file_path, SDL3.Error.get_error ());
                    break;
                }
                SDL3.Video.set_window_title (window, APPLICATION_TITLE + " " + file_path);

                textures.resize (animation.count);
                for (var i = 0; i < animation.count; i++) {
                    textures[i] = SDL3.Render.create_texture_from_surface (renderer, animation.frames[i]);
                }
                break;

                default :
                break;
            }
        }

        // Calculate delta/elapsed time
        var now = SDL3.Timer.get_ticks ();
        var elapsed = now - previous_time;
        previous_time = now;

        // We move the animation timer via a custom delay + SDL3.Timer.get_ticks ()
        // According to the delay value inside the animated image
        if (animation != null) {
            current_animation_delay += elapsed;
            if (current_animation_delay > animation.delays[current_animation_frame]) {
                current_animation_delay = 0;
                current_animation_frame++;
                current_animation_frame %= animation.count;
            }

            // Center the current texture according the the current frame
            dst_rect.w = textures[current_animation_frame].w;
            dst_rect.h = textures[current_animation_frame].h;
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
            if (animation != null) {
                SDL3.Render.render_texture (renderer, textures[current_animation_frame], null, dst_rect);
            }

            // Draw text instructions
            // Instructions box
            SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_fill_rect (renderer, { 0, 15, WINDOW_WIDTH, 50 });
            // Instructions text
            SDL3.Render.set_render_scale (renderer, 2.0f, 2.0f);
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 0, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_debug_text (renderer, 10, 10, "Drag and drop an animation to show it.");

            SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_debug_text (renderer, 10, 20, "Only GIF and WEBP animations are supported.");

            // Draw error if failed
            if (animation == null && file_path != null) {
                // Error box
                SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
                SDL3.Render.render_fill_rect (renderer, { 0, 37, WINDOW_WIDTH, 24 });
                // Error text
                SDL3.Render.set_render_scale (renderer, 1.25f, 1.25f);
                SDL3.Render.set_render_draw_color (renderer, 255, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
                SDL3.Render.render_debug_text_format (renderer, 10, 65,
                                                      "Couldn't load: ");
                SDL3.Render.render_debug_text_format (renderer, 10, 75, "%s", file_path);
                SDL3.Render.render_debug_text_format (renderer, 10, 85, "Check print log error details");
            }
        }
        SDL3.Render.render_present (renderer);
    }

    // The animation and textures should be freed when done with them
    SDL3.Image.free_animation (animation);
    foreach (unowned var tex in textures) {
        SDL3.Render.destroy_texture (tex);
    }
    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}