using SDL;

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer 01 - Clear", "1.0",
                               "dev.vala.example.renderer-01-clear");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer 01 - Clear",
                                                     640, 480, 0,
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

        double now = SDL.Timer.get_ticks () / 1000.0;
        float red = (float) (0.5 + 0.5 * StdInc.sin (now));
        float green = (float) (0.5 + 0.5 * StdInc.sin (now + StdInc.PI_D * 2 / 3));
        float blue = (float) (0.5 + 0.5 * StdInc.sin (now + StdInc.PI_D * 4 / 3));

        SDL.Render.set_render_draw_color_float (renderer, red, green, blue, SDL.Pixels.ALPHA_OPAQUE_FLOAT);
        SDL.Render.render_clear (renderer);

        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}