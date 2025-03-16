using SDL;

// This sample uses a text engine to render text
// It can simplify the rendering process in general

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
SDL.Ttf.Font? font_normal = null;
SDL.Ttf.Font? font_fallback = null;

int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala TTF 02 - Text Engine", "1.0",
                               "dev.vala.example.ttf-02-text-engine");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala TTF 02 - Text Engine",
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

    // The first example renders a text directly to a surface. This can be a bit cumbersome.
    // A text engine from TTF will save you a lot of boilerplate and make things easier
    // There are engines for surfaces, for the SDL rednerer and for GPU
    //
    // Text engines have some sensible defaults, but you can change them with  SDL.Ttf.set_text_xyx
    // You can have multiple text engines for diferent properties, font and more
    //
    // You can also switch engines in real time if you need to change properties about a text
    var text_engine = SDL.Ttf.create_renderer_text_engine (renderer);
    if (text_engine == null) {
        SDL.Log.log ("Couldn't create a renderer text engine: %s\n", SDL.Error.get_error ());
        return 3;
    }
    var ttf_text_01 = SDL.Ttf.create_text (text_engine, font_normal, "Hello world! 💻\n\nThis text message comes "
                                           + "from SDL ⚙ and Vala ✌️\n\nWe are using a GPU TextEngine to render", 0);

    if (ttf_text_01 == null) {
        SDL.Log.log ("Couldn't create text from text engine: %s\n", SDL.Error.get_error ());
        return 3;
    }
    SDL.Ttf.set_text_wrap_width (ttf_text_01, MAX_TEXT_WRAP_WIDTH);

    var ttf_text_02 = SDL.Ttf.create_text (text_engine, font_normal,
                                           "Current Ticks: %s".printf (SDL.Timer.get_ticks ().to_string ()), 0);
    if (ttf_text_02 == null) {
        SDL.Log.log ("Couldn't create text from text engine: %s\n", SDL.Error.get_error ());
        return 3;
    }
    SDL.Ttf.set_text_color (ttf_text_02, 200, 0, 200, 255);

    int? w, h;
    SDL.Ttf.get_text_size (ttf_text_01, out w, out h);
    float x = (WINDOW_WIDTH - w) / 2.0f;
    float y = (WINDOW_HEIGHT - h) / 2.0f;

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        // Update text on ttf_text_02
        // On a simple texture we would have to "re_render", which takes CPU time
        // With this approach, changing text is faster and easier.
        //
        // There are also functions to insert, delete and append text.
        // This can be a very powerful tool to create things like texboxes.
        var str = "Current Ticks: %s".printf (SDL.Timer.get_ticks ().to_string ());
        SDL.Ttf.set_text_string (ttf_text_02, str, 0);

        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            SDL.Ttf.draw_renderer_text (ttf_text_01, x, y);
            SDL.Ttf.draw_renderer_text (ttf_text_02, x + 100, y + 350);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);

    SDL.Ttf.destroy_text (ttf_text_01);
    SDL.Ttf.destroy_text (ttf_text_02);
    SDL.Ttf.destroy_renderer_text_engine (text_engine);

    SDL.Ttf.close_font (font_normal);
    SDL.Ttf.close_font (font_fallback);

    SDL.Ttf.quit ();
    SDL.Init.quit ();
    return 0;
}