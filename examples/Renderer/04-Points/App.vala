using SDL3;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;
const int NUM_POINTS = 500;

const int MIN_PIXELS_PER_SECOND = 30; // Move at least this many pixels per second.
const int MAX_PIXELS_PER_SECOND = 60; // Move this many pixels per second at most.

SDL3.Rect.FPoint points[NUM_POINTS];
float point_speeds[NUM_POINTS];
uint64 last_time = 0;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Renderer Example 04 - Points", "1.0",
                                "dev.vala.example.renderer-04-points");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 04 - Points",
                                                      WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    // set up the data for a bunch of points.
    for (int i = 0; i < points.length; i++) {
        points[i].x = SDL3.StdInc.randf () * ((float) WINDOW_WIDTH);
        points[i].y = SDL3.StdInc.randf () * ((float) WINDOW_HEIGHT);
        point_speeds[i] = MIN_PIXELS_PER_SECOND
            + (SDL3.StdInc.randf () * (MAX_PIXELS_PER_SECOND - MIN_PIXELS_PER_SECOND));
    }
    // Last time set as current ticks
    last_time = SDL3.Timer.get_ticks ();

    bool is_running = true;
    SDL3.Events.Event ev;
    while (is_running) {
        while (SDL3.Events.poll_event (out ev)) {
            if (ev.type == SDL3.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        // Delta/elapsed time (seconds since last iteration)
        uint64 now = SDL3.Timer.get_ticks ();
        float elapsed = ((float) (now - last_time)) / 1000.0f;
        // Save last_time for next frame, we use elapsed for the rest of the loop
        last_time = now;

        // Let's move all our points a little for a new frame.
        for (int i = 0; i < points.length; i++) {
            float distance = elapsed * point_speeds[i];
            points[i].x += distance;
            points[i].y += distance;
            if ((points[i].x >= WINDOW_WIDTH) || (points[i].y >= WINDOW_HEIGHT)) {
                // Off the screen; restart it elsewhere!
                if (SDL3.StdInc.rand (2) > 0) {
                    points[i].x = SDL3.StdInc.randf () * ((float) WINDOW_WIDTH);
                    points[i].y = 0.0f;
                } else {
                    points[i].x = 0.0f;
                    points[i].y = SDL3.StdInc.randf () * ((float) WINDOW_HEIGHT);
                }
                point_speeds[i] = MIN_PIXELS_PER_SECOND
                    + (SDL3.StdInc.randf () * (MAX_PIXELS_PER_SECOND - MIN_PIXELS_PER_SECOND));
            }
        }

        // Black, full alpha
        SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            // White, full alpha
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_points (renderer, points);
        }
        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}