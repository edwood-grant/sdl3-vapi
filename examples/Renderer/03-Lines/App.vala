using SDL;

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;

const SDL.Rect.FPoint LINE_POINTS[9] = {
    { 100, 354 }, { 220, 230 }, { 140, 230 }, { 320, 100 }, { 500, 230 },
    { 420, 230 }, { 540, 354 }, { 400, 354 }, { 100, 354 }
};

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer Example 03 - Lines", "1.0",
                               "dev.vala.example.renderer-03-lines");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 03 - Lines",
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

        SDL.Render.set_render_draw_color (renderer, 100, 100, 100, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            // You can draw lines, one at a time, like these brown ones...
            SDL.Render.set_render_draw_color (renderer, 127, 49, 32, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_line (renderer, 240, 450, 400, 450);
            SDL.Render.render_line (renderer, 240, 356, 400, 356);
            SDL.Render.render_line (renderer, 240, 356, 240, 450);
            SDL.Render.render_line (renderer, 400, 356, 400, 450);

            // You can also draw a series of connected lines in a single batch...
            SDL.Render.set_render_draw_color (renderer, 0, 255, 0, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_lines (renderer, LINE_POINTS);

            // Here's a bunch of lines drawn out from a center point in a circle.
            // we randomize the color of each line, so it functions as animation.
            for (int i = 0; i < 360; i++) {
                float size = 30.0f;
                float x = 320.0f;
                float y = 95.0f - (size / 2.0f);
                SDL.Render.set_render_draw_color (renderer,
                                                  (uint8) SDL.StdInc.rand (256),
                                                  (uint8) SDL.StdInc.rand (256),
                                                  (uint8) SDL.StdInc.rand (256),
                                                  SDL.Pixels.ALPHA_OPAQUE);

                SDL.Render.render_line (renderer,
                                        x, y,
                                        x + SDL.StdInc.sinf ((float) i) * size,
                                        y + SDL.StdInc.cosf ((float) i) * size);
            }
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}