using SDL3;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;
string string_to_print = null;

public int main (string[] args) {
    message ("This is running in the Vala main entry point!");
    message ("We will run the main function app soon, after inventing new args to inject.");

    string[] custom_args = { "This string comes as a custom argument from the Vala main function" };
    SDL3.Main.enter_app_main_callbacks (custom_args,
                                        init_function,
                                        iterate_function,
                                        event_function,
                                        quit_function);
    SDL3.Main.set_main_ready ();
    return 0;
}

public SDL3.Init.AppResult init_function (string[] args) {
    SDL3.Hints.set_hint (SDL3.Hints.QUIT_ON_LAST_WINDOW_CLOSE, "1");
    SDL3.Init.set_app_metadata ("SDL3 Vala Main 03 - Main Handled Callbacks", "1.0",
                                "dev.vala.example.main-03-main-handled-callbacks");
    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return SDL3.Init.AppResult.FAILURE;
    }

    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Main 03 - Main Handled Callbacks",
                                                      640, 480, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return SDL3.Init.AppResult.FAILURE;
    }

    string_to_print = args[0];
    return SDL3.Init.AppResult.CONTINUE;
}

public SDL3.Init.AppResult iterate_function () {
    SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
    SDL3.Render.render_clear (renderer);
    {
        SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_debug_text (renderer, 25, 275, string_to_print);
        SDL3.Render.render_debug_text (renderer, 25, 300, "This uses the SDL_MAIN_HANDLED define meson and"
                                       + ", enter_app_main_callbacks and set_main_ready");
    }
    SDL3.Render.render_present (renderer);

    return SDL3.Init.AppResult.CONTINUE;
}

public SDL3.Init.AppResult event_function (SDL3.Events.Event event) {
    if (event.type == SDL3.Events.EventType.WINDOW_CLOSE_REQUESTED ||
        event.type == SDL3.Events.EventType.QUIT) {
        return SDL3.Init.AppResult.SUCCESS;
    }

    return SDL3.Init.AppResult.CONTINUE;
}

public void quit_function (SDL3.Init.AppResult result) {
    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();
}