using SDL;

// A basic program for SDL_ttf.
// Loads a font and renders "hello world" on the screen

// The fonts are:
// "HomeVideo" by GGBotNrt
// https://ggbot.itch.io/home-video-font
// https://www.ggbot.net/
//
// OpenMoji font designed by OpenMoji – the open-source emoji and icon project.
// License: CC BY-SA 4.0
// https://openmoji.org/

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;
const int MAX_TEXT_WRAP_WIDTH = 575;

const SDL.Pixels.Color COLOR_WHITE = { 255, 255, 255, 255 };
const float FONT_POINT_SIZE = 36.0f;
const string FONT_NORMAL_NAME = "HomeVideo-Regular.ttf";
const string FONT_FALLBACK_NAME = "OpenMoji-black-glyf.ttf";

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;
SDL.Render.Texture? text_texture = null;
SDL.Ttf.Font? font_normal = null;
SDL.Ttf.Font? font_fallback = null;

int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala TTF 01 - Hello", "1.0",
                               "dev.vala.example.ttf-01-hello");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala TTF 01 - Hello",
                                                     WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    success = SDL.Ttf.init ();
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL TTF: %s", SDL.Error.get_error ());
        return 2;
    }

    // Open the font
    var font_normal_path = SDL.FileSystem.get_base_path () + FONT_NORMAL_NAME;
    var font_fallback_path = SDL.FileSystem.get_base_path () + FONT_FALLBACK_NAME;
    font_normal = SDL.Ttf.open_font (font_normal_path, FONT_POINT_SIZE);
    font_fallback = SDL.Ttf.open_font (font_fallback_path, FONT_POINT_SIZE);
    if (font_normal == null || font_fallback == null) {
        SDL.Log.log ("Couldn't open font: %s\n", SDL.Error.get_error ());
        return 2;
    }

    // You can play with styles, hints text direction and more with
    // SDL.Ttf.set_font_*** (look through the API for more)
    SDL.Ttf.set_font_line_skip (font_normal, (int) FONT_POINT_SIZE + 2); // Similar to line spacing
    SDL.Ttf.set_font_wrap_alignment (font_normal, SDL.Ttf.HorizontalAlignment.CENTER); // Center the text

    // Add fallback to normal font. The other font supports emojis
    var added_fallback = SDL.Ttf.add_fallback_font (font_normal, font_fallback);
    if (!added_fallback) {
        SDL.Log.log ("Couldn't add fallback font: %s\n", SDL.Error.get_error ());
    }

    // Create the text surface and convert it to a texture
    // The "_wrapped" version of these methods will take int account linebreaks and the width limit
    // If you don't want to wrap, use the normal functions like SDL.Ttf.render_text_blended ()
    var text_surface = SDL.Ttf.render_text_blended_wrapped (font_normal,
                                                            "Hello world! 💻\n\nThis text message comes "
                                                            + "from SDL ⚙ and Vala ✌️",
                                                            0,
                                                            COLOR_WHITE,
                                                            MAX_TEXT_WRAP_WIDTH);
    if (text_surface != null) {
        text_texture = SDL.Render.create_texture_from_surface (renderer, text_surface);
        SDL.Surface.destroy_surface (text_surface);
    } else {
        SDL.Log.log ("Couldn't create text: %s\n", SDL.Error.get_error ());
        return 3;
    }

    var dst_rect = SDL.Rect.FRect ();
    dst_rect.w = text_texture.w;
    dst_rect.h = text_texture.h;
    dst_rect.x = (WINDOW_WIDTH - dst_rect.w) / 2.0f;
    dst_rect.y = (WINDOW_HEIGHT - dst_rect.h) / 2.0f;

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            SDL.Render.render_texture (renderer, text_texture, null, dst_rect);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Ttf.close_font (font_normal);
    SDL.Ttf.close_font (font_fallback);
    SDL.Ttf.quit ();
    SDL.Init.quit ();

    return 0;
}