using SDL;

// This example is identical to the GLib callback version The only difference
// is that it uses the standard void** as app_state that comes with SDL. Its up to you to
// decide what to do with this value, not needed at all if you don't want to

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;
string string_to_print = null;

// This struct will be used to carry data along the different callbacks
struct AppContext {
    public string? message;
    public int counter;
} // AppContext

public static int main (string[] args) {
    message ("This is running in the Vala main entry point!");
    message ("We will run the main function app soon, after inventing new args to inject.");

    string[] custom_args = { "This string comes as a custom argument from the Vala main function" };
    SDL.Main.enter_app_main_callbacks (custom_args,
                                       init_function,
                                       iterate_function,
                                       event_function,
                                       quit_function);
    SDL.Main.set_main_ready ();
    return 0;
}

// All callback will contain calls to a void **. in POSIX MODE
// This is not needed to be used at all actual, you can leave it null or do nothing wiht it
// If yu work with it you'll need to know your pointer and such to keep data there
// There are better places in vala to hod stuff IMHO. However, this exists!

static SDL.Init.AppResult init_function (out void* app_state, string[] args) {
    // You can leave this app_state null f you want
    // For this example, let's store some values via a context struct
    AppContext* context = (AppContext*) SDL.StdInc.calloc (1, sizeof (AppContext));
    context->counter = 456;
    context->message = "app_state carries this string and a counter. Counter value %d.".printf (context->counter);
    app_state = (void*) context;

    SDL.Hints.set_hint (SDL.Hints.QUIT_ON_LAST_WINDOW_CLOSE, "1");
    SDL.Init.set_app_metadata ("SDL3 Vala Main 03 - Main Handled Callbacks POSIX", "1.0",
                               "dev.vala.example.main-03-main-handled-callbacks");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return SDL.Init.AppResult.FAILURE;
    }

    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Main 03 - Main Handled Callbacks POSIX",
                                                     640, 480, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return SDL.Init.AppResult.FAILURE;
    }

    string_to_print = args[0];
    return SDL.Init.AppResult.CONTINUE;
}

static SDL.Init.AppResult iterate_function (void* app_state) {
    // Grab the current context
    AppContext* context = (AppContext*) app_state;

    SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
    SDL.Render.render_clear (renderer);
    {
        SDL.Render.set_render_draw_color (renderer, 255, 255, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_debug_text (renderer, 25, 130, "Main callback in POSIX mode (void**)");
        SDL.Render.render_debug_text (renderer, 25, 150, context->message);

        SDL.Render.set_render_draw_color (renderer, 255, 255, 255, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_debug_text (renderer, 25, 240, "This uses the SDL_MAIN_HANDLED define in meson,");
        SDL.Render.render_debug_text (renderer, 25, 255, "enter_app_main_callbacks and set_main_ready");
    }
    SDL.Render.render_present (renderer);

    // Update the counter and the message
    context->counter++;
    context->message = "app_state carries this string and a counter. Counter value %d.".printf (context->counter);
    app_state = (void*) context;

    return SDL.Init.AppResult.CONTINUE;
}

static SDL.Init.AppResult event_function (void* app_state, SDL.Events.Event event) {
    if (event.type == SDL.Events.EventType.WINDOW_CLOSE_REQUESTED ||
        event.type == SDL.Events.EventType.QUIT) {
        return SDL.Init.AppResult.SUCCESS;
    }

    return SDL.Init.AppResult.CONTINUE;
}

static void quit_function (void* app_state, SDL.Init.AppResult result) {
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();
}