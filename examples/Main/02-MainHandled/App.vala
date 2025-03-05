using SDL3;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

public int main (string[] args) {
    message ("We will run the main function app soon, after injecting custom args.");

    string[] custom_args = { "This string comes as a custom argument from the Vala main function" };
    SDL3.Main.run_app (custom_args, main_func, null);

    return 0;
}

public int main_func (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Main 02 - Main Handled", "1.0",
                                "dev.vala.example.main-02-main-handled");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Main 02 - Main Handled",
                                                      640, 480, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
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

        SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_debug_text (renderer, 50, 240, args[0]);
            SDL3.Render.render_debug_text (renderer, 50, 250, "This uses the SDL_MAIN_HANDLED define"
                                           + " in meson and SDL3.Main.run_app");
        }
        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}