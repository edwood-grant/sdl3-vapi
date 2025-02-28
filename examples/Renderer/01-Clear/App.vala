using SDL3;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Renderer 01 - Clear", "1.0",
                                "dev.vala.example.renderer-01-clear");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Renderer 01 - Clear",
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

        double now = SDL3.Timer.get_ticks () / 1000.0;
        float red = (float) (0.5 + 0.5 * StdInc.sin (now));
        float green = (float) (0.5 + 0.5 * StdInc.sin (now + StdInc.PI_D * 2 / 3));
        float blue = (float) (0.5 + 0.5 * StdInc.sin (now + StdInc.PI_D * 4 / 3));

        SDL3.Render.set_render_draw_color_float (renderer, red, green, blue, SDL3.Pixels.ALPHA_OPAQUE_FLOAT);
        SDL3.Render.render_clear (renderer);

        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}