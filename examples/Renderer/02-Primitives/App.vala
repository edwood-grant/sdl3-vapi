using SDL;

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;
SDL.Rect.FPoint points[500];
SDL.Rect.FRect rect;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer Example 02 - Primitives", "1.0",
                               "dev.vala.example.renderer-02-primitives");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 02 - Primitives",
                                                     640, 480, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    // Set up some random points
    for (int i = 0; i < points.length; i++) {
        points[i].x = (SDL.StdInc.randf () * 440.0f) + 100.0f;
        points[i].y = (SDL.StdInc.randf () * 280.0f) + 100.0f;
    }

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        SDL.Render.set_render_draw_color (renderer, 33, 33, 33, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            // draw a filled rectangle in the middle of the canvas. (blue, full alpha)
            SDL.Render.set_render_draw_color (renderer, 0, 0, 255, SDL.Pixels.ALPHA_OPAQUE);
            rect.x = rect.y = 100;
            rect.w = 440;
            rect.h = 280;
            SDL.Render.render_fill_rect (renderer, rect);

            // Draw some points across the canvas. (red, full alpha)
            SDL.Render.set_render_draw_color (renderer, 255, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_points (renderer, points);

            // Draw a unfilled rectangle in-set a little bit. (green, full alpha)
            SDL.Render.set_render_draw_color (renderer, 0, 255, 0, SDL.Pixels.ALPHA_OPAQUE);
            rect.x += 30;
            rect.y += 30;
            rect.w -= 60;
            rect.h -= 60;
            SDL.Render.render_rect (renderer, rect);

            // Draw two lines in an X across the whole canvas. (yellow, full alpha)
            SDL.Render.set_render_draw_color (renderer, 255, 255, 0, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_line (renderer, 0, 0, 640, 480);
            SDL.Render.render_line (renderer, 0, 480, 640, 0);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}