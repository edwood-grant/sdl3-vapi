using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer Example 18 - Debug Text", "1.0",
                               "dev.vala.example.renderer-18-debug-text");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 18 - Debug Text",
                                                     WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        // Black, full alpha
        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            int charsize = SDL.Render.DEBUG_TEXT_FONT_CHARACTER_SIZE;

            // White, full alpha
            SDL.Render.set_render_draw_color (renderer, 255, 255, 255, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_debug_text (renderer, 272, 100, "Hello world!");
            SDL.Render.render_debug_text (renderer, 224, 150, "This is some debug text.");

            // Light blue, full alpha
            SDL.Render.set_render_draw_color (renderer, 51, 102, 255, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_debug_text (renderer, 184, 200, "You can do it in different colors.");
            // White, full alpha
            SDL.Render.set_render_draw_color (renderer, 255, 255, 255, SDL.Pixels.ALPHA_OPAQUE);

            SDL.Render.set_render_scale (renderer, 4.0f, 4.0f);
            SDL.Render.render_debug_text (renderer, 14, 65, "It can be scaled.");
            SDL.Render.set_render_scale (renderer, 1.0f, 1.0f);
            SDL.Render.render_debug_text (renderer, 64, 350,
                                          "This only does ASCII chars. So this laughing emoji won't draw: 🤣");

            SDL.Render.render_debug_text_format (renderer,
                                                 (float) ((WINDOW_WIDTH - (charsize * 46)) / 2),
                                                 400,
                                                 "(This program has been running for %" + SDL.StdInc.PRIu64
                                                 + " seconds.)",
                                                 SDL.Timer.get_ticks () / 1000);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}