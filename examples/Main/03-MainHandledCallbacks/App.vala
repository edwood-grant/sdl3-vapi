using SDL3;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;
string string_to_print = null;

public static int main (string[] args) {
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

// All callback will contain calls to a PtrArray.
// This is not needed to be used at all actual, you can leave it null or do nothing wiht it
// If yu work with it you'll need to know your pointer and such to keep data there
// There are better places in vala to hod stuff IMHO. However, this exists!

static SDL3.Init.AppResult init_function (out GLib.PtrArray app_state, string[] args) {
    // Init the PtrArray even if you don't use it
    // If you don't you will get a bunhc of critical failures
    app_state = new GLib.PtrArray ();

    // For this example, let's store some values here
    var counter = 0;
    var message = "app_state carries this string and a counter. Counter value %d.".printf (counter);
    app_state.add ((owned) message);
    app_state.add (counter.to_pointer ());


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

static SDL3.Init.AppResult iterate_function (GLib.PtrArray app_state) {
    // Grab the current message
    var message = (string) app_state.get (0);

    SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
    SDL3.Render.render_clear (renderer);
    {
        SDL3.Render.set_render_draw_color (renderer, 255, 255, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_debug_text (renderer, 25, 150, message);

        SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_debug_text (renderer, 25, 240, "This uses the SDL_MAIN_HANDLED define in meson,");
        SDL3.Render.render_debug_text (renderer, 25, 255, "enter_app_main_callbacks and set_main_ready");
    }
    SDL3.Render.render_present (renderer);

    // Update the counter and the message
    var counter = int.from_pointer (app_state.get (1));
    counter++;
    message = "app_state carries this string and a counter. Counter value %d.".printf (counter);
    app_state.set (0, (owned) message);
    app_state.set (1, counter.to_pointer ());

    return SDL3.Init.AppResult.CONTINUE;
}

static SDL3.Init.AppResult event_function (GLib.PtrArray app_state, SDL3.Events.Event event) {
    if (event.type == SDL3.Events.EventType.WINDOW_CLOSE_REQUESTED ||
        event.type == SDL3.Events.EventType.QUIT) {
        return SDL3.Init.AppResult.SUCCESS;
    }

    return SDL3.Init.AppResult.CONTINUE;
}

static void quit_function (GLib.PtrArray app_state, SDL3.Init.AppResult result) {
    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();
}