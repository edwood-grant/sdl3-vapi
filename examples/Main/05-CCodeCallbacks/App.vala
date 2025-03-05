using SDL;

// This example does two things:
// 1. Sets the SDL_MAIN_USE_CALLBACKS C define (set in Meson)
// 2. Uses the CCode vala attribute for each function to match the unimplemented main functions
// located in SDL_main.h
//

// So in essence, its recreating the functions designed for the unimplemented callbacks via CCode.
// This might be the onyl way to properly make it work if Vala ever gets ported to WASM (there have
// been succesful attempts, but nothing official) It's probably best ot use the
// 03-MainHandledCallbacks example, that uses a handled custom main and sets manually the functions,
// it's less complex and prettier. Nevertheles this exists for demonstration purposes

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;

// This struct will be used to carry data along the different callbacks
struct AppContext {
    public string? message;
    public int counter;
} // AppContext

// Note that you need to exactly recreate the calls, including the weird void* sutff, you also need
// to manually arrange the array length ot make the arguments order work properly
[CCode (cname = "SDL_AppInit")]
public SDL.Init.AppResult app_init (out void* app_state, [CCode (array_length_pos = 1.0)] string[] argv) {
    // Tis si a hack. Its not neede but this puts SDL_main.h in the include
    // TODO: A better way to do this?
    SDL.Main.set_main_ready ();

    // You can leave this app_state null f you want
    // For this example, let's store some values via a context struct
    AppContext* context = (AppContext*) SDL.StdInc.calloc (1, sizeof (AppContext));
    context->counter = 456;
    context->message = "app_state carries this string and a counter. Counter value %d.".printf (context->counter);
    app_state = (void*) context;

    SDL.Init.set_app_metadata ("SDL3 Vala Main 05 - CCode Callbacks", "1.0",
                               "dev.vala.example.main-05-ccode-callbacks");
    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return SDL.Init.AppResult.FAILURE;
    }

    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Main 05 - CCode Callbacks",
                                                     640, 480, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return SDL.Init.AppResult.FAILURE;
    }
    return SDL.Init.AppResult.CONTINUE;
}

// Same as before oyu need to keep the void* appstate. You can do bascially anything you want with it
// In C its used as a way to keep context. In Vala, this is a bit moot, but you can still use it.
[CCode (cname = "SDL_AppIterate")]
public SDL.Init.AppResult iterate (void* app_state) {
    // Grab the current context
    AppContext* context = (AppContext*) app_state;

    SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
    SDL.Render.render_clear (renderer);
    {
        SDL.Render.set_render_draw_color (renderer, 255, 255, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_debug_text (renderer, 25, 130, "Main callback using CCodes");
        SDL.Render.render_debug_text (renderer, 25, 150, context->message);

        SDL.Render.set_render_draw_color (renderer, 255, 255, 255, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_debug_text (renderer, 25, 220, "This example use custom CCode function callbacks");
        SDL.Render.render_debug_text (renderer, 25, 240, "This uses the SDL_MAIN_USE_CALLBACKS define in meson");
    }
    SDL.Render.render_present (renderer);

    // Update the counter and the message
    context->counter++;
    context->message = "app_state carries this string and a counter. Counter value %d.".printf (context->counter);
    app_state = (void*) context;

    return SDL.Init.AppResult.CONTINUE;
}

// Note that you need to keep the pointer as in (SDL.Events.Event* event) in the event argument. If
// you don't, it will not compile and will complain that you are not mathing the unimplemented
// method exactly as its presentend in SDL_main.h
[CCode (cname = "SDL_AppEvent")]
public SDL.Init.AppResult event_function (void* app_state, SDL.Events.Event* event) {
    if (event.type == SDL.Events.EventType.QUIT) {
        return SDL.Init.AppResult.SUCCESS;
    }

    return SDL.Init.AppResult.CONTINUE;
}

// SDL will clean up the window/renderer and quit for us (but "only" the window and renderer).
// It is still safe (and god practice to manually destroy them and also quit, if you want to
[CCode (cname = "SDL_AppQuit")]
public void quit_function (void* app_state, SDL.Init.AppResult result) {
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();
}