using GLib;
using SDL3;

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

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

// Note that you need to exactly recreate the calls, including the weird void* sutff, you also need
// to manually arrange the array length ot make the arguments order work properly
[CCode (cname = "SDL_AppInit")]
public SDL3.Init.AppResult app_init (void* * appstate, [CCode (array_length_pos = 1.0)] string[] argv) {
    SDL3.Main.set_main_ready ();

    SDL3.Init.set_app_metadata ("SDL3 Vala Main 05 - CCode Callbacks", "1.0",
                                "dev.vala.example.main-05-ccode-callbacks");
    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return SDL3.Init.AppResult.FAILURE;
    }

    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Main 05 - CCode Callbacks",
                                                      640, 480, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return SDL3.Init.AppResult.FAILURE;
    }
    return SDL3.Init.AppResult.CONTINUE;
}

// Same as beofre oyu need to keep the void* appstate. You can do bascially anything you want with it
// In C its used as a way to keep context. In Vala, this is a bit moot, but you can still use it.
[CCode (cname = "SDL_AppIterate")]
public SDL3.Init.AppResult iterate (void* appstate) {
    SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
    SDL3.Render.render_clear (renderer);
    {
        SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_debug_text (renderer, 125, 220, "This example use custom CCode function callbacks");
        SDL3.Render.render_debug_text (renderer, 125, 240, "This uses the SDL_MAIN_USE_CALLBACKS define in meson");
    }
    SDL3.Render.render_present (renderer);

    return SDL3.Init.AppResult.CONTINUE;
}

// Note that you need to keep the pointer as in (SDL3.Events.Event* event) in the event argument. If
// you don't, it will not compile and will complain that you are not mathing the unimplemented
// method exactly as its presentend in SDL_main.h
[CCode (cname = "SDL_AppEvent")]
public SDL3.Init.AppResult event_function (void* appstate, SDL3.Events.Event* event) {
    if (event.type == SDL3.Events.EventType.QUIT) {
        return SDL3.Init.AppResult.SUCCESS;
    }

    return SDL3.Init.AppResult.CONTINUE;
}

// SDL will clean up the window/renderer and quit for us (but "only" the window and renderer).
// It is still safe to manually destroy them and quit, if you want to
[CCode (cname = "SDL_AppQuit")]
public void quit_function (void* appstate, SDL3.Init.AppResult result) {
    // SDL3.Render.destroy_renderer (renderer);
    // SDL3.Video.destroy_window (window);
    // SDL3.Init.quit ();
}
