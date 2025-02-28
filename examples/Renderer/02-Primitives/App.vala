using SDL3;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;
SDL3.Rect.FPoint points[500];
SDL3.Rect.FRect rect;

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Renderer Example 02 - Primitives", "1.0",
                                "dev.vala.example.renderer-02-primitives");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 02 - Primitives",
                                                      640, 480, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    // Set up some random points
    for (int i = 0; i < points.length; i++) {
        points[i].x = (SDL3.StdInc.randf () * 440.0f) + 100.0f;
        points[i].y = (SDL3.StdInc.randf () * 280.0f) + 100.0f;
    }

    bool is_running = true;
    SDL3.Events.Event ev;
    while (is_running) {
        while (SDL3.Events.poll_event (out ev)) {
            if (ev.type == SDL3.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        SDL3.Render.set_render_draw_color (renderer, 33, 33, 33, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            // draw a filled rectangle in the middle of the canvas. (blue, full alpha)
            SDL3.Render.set_render_draw_color (renderer, 0, 0, 255, SDL3.Pixels.ALPHA_OPAQUE);
            rect.x = rect.y = 100;
            rect.w = 440;
            rect.h = 280;
            SDL3.Render.render_fill_rect (renderer, rect);

            // Draw some points across the canvas. (red, full alpha)
            SDL3.Render.set_render_draw_color (renderer, 255, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_points (renderer, points);

            // Draw a unfilled rectangle in-set a little bit. (green, full alpha)
            SDL3.Render.set_render_draw_color (renderer, 0, 255, 0, SDL3.Pixels.ALPHA_OPAQUE);
            rect.x += 30;
            rect.y += 30;
            rect.w -= 60;
            rect.h -= 60;
            SDL3.Render.render_rect (renderer, rect);

            // Draw two lines in an X across the whole canvas. (yellow, full alpha)
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 0, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_line (renderer, 0, 0, 640, 480);
            SDL3.Render.render_line (renderer, 0, 480, 640, 0);
        }
        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}