using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL.Rect.FRect rects[16];
SDL.Rect.FRect center_rects[3];

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer Example 05 - Rectangles", "1.0",
                               "dev.vala.example.renderer-05-rectangles");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 05 - Rectangles",
                                                     WINDOW_WIDTH, WINDOW_HEIGHT, 0,
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

        var now = SDL.Timer.get_ticks ();

        // We'll have the rectangles grow and shrink over a few seconds.
        float direction = ((now % 2000) >= 1000) ? 1.0f : -1.0f;
        float scale = ((float) (((int) (now % 1000)) - 500) / 500.0f) * direction;

        // Black, full alpha
        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            // Let's draw a single rectangle (square, really).
            rects[0].x = rects[0].y = 100;
            rects[0].w = rects[0].h = 100 + (100 * scale);
            SDL.Render.set_render_draw_color (renderer, 255, 0, 0, SDL.Pixels.ALPHA_OPAQUE); /* red, full alpha */
            SDL.Render.render_rect (renderer, rects[0]);

            // Now let's draw several rectangles with one function call.
            for (int i = 0; i < center_rects.length; i++) {
                float size = (i + 1) * 50.0f;
                center_rects[i].w = center_rects[i].h = size + (size * scale);
                // Center it.
                center_rects[i].x = (WINDOW_WIDTH - center_rects[i].w) / 2;
                center_rects[i].y = (WINDOW_HEIGHT - center_rects[i].h) / 2;
            }

            // green, full alpha
            SDL.Render.set_render_draw_color (renderer, 0, 255, 0, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_rects (renderer, center_rects);

            // Those were rectangle _outlines_, really. You can also draw _filled_ rectangles!
            rects[0].x = 400;
            rects[0].y = 50;
            rects[0].w = 100 + (100 * scale);
            rects[0].h = 50 + (50 * scale);
            // blue, full alpha
            SDL.Render.set_render_draw_color (renderer, 0, 0, 255, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_fill_rect (renderer, rects[0]);

            // And also fill a bunch of rectangles at once...
            for (int i = 0; i < rects.length; i++) {
                float w = (float) (WINDOW_WIDTH / rects.length);
                float h = i * 8.0f;
                rects[i].x = i * w;
                rects[i].y = WINDOW_HEIGHT - h;
                rects[i].w = w;
                rects[i].h = h;
            }
            // White, full alpha
            SDL.Render.set_render_draw_color (renderer, 255, 255, 255, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_fill_rects (renderer, rects);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}