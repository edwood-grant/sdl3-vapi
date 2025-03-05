using SDL;

// This example code reads pen/stylus input and draws lines. Darker lines
// for harder pressure.
//
// SDL can track multiple pens, but for simplicity here, this assumes any
// pen input we see was from one device.

SDL.Video.Window? window = null;
SDL.Render.Renderer ? renderer = null;

// We will use this renderer to draw into this window every frame.
SDL.Render.Texture ? render_target = null;
float pressure = 0.0f;
float previous_touch_x = -1.0f;
float previous_touch_y = -1.0f;
float tilt_x = 0.0f;
float tilt_y = 0.0f;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Pen 01 - Drawing Lines", "1.0",
                               "dev.vala.example.pen-01-drawing-lines");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Pen 01 - Drawing Lines",
                                                     640, 480, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    // We make a render target so we can draw lines to it and not have to record
    // and redraw every pen stroke each frame. Instead rendering a frame for us
    // is a single texture draw. */

    // make sure the render target matches output size (for hidpi displays, etc)
    // so drawing matches the pen's position on a tablet display.
    int w, h;
    SDL.Render.get_render_output_size (renderer, out w, out h);
    render_target = SDL.Render.create_texture (renderer,
                                               SDL.Pixels.PixelFormat.RGBA8888,
                                               SDL.Render.TextureAccess.TARGET,
                                               w, h);
    if (render_target == null) {
        SDL.Log.log ("Couldn't create render target: %s", SDL.Error.get_error ());
        return 2;
    }

    // just blank the render target to gray to start.
    SDL.Render.set_render_target (renderer, render_target);
    SDL.Render.set_render_draw_color (renderer, 100, 100, 100, SDL.Pixels.ALPHA_OPAQUE);
    SDL.Render.render_clear (renderer);

    SDL.Render.set_render_target (renderer, null);
    SDL.Render.set_render_draw_blend_mode (renderer, SDL.BlendModes.BlendMode.BLEND);

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            switch (ev.type) {
            case SDL.Events.EventType.QUIT :
                is_running = false;
                break;
            case SDL.Events.EventType.PEN_MOTION :
                // You can check for when the pen is touching, but if
                // pressure > 0.0f, it's definitely touching!
                if (pressure > 0.0f) {
                    // Only draw if we're moving while touching
                    if (previous_touch_x >= 0.0f) {
                        // Draw with the alpha set to the pressure, so you effectively
                        // get a fainter line for lighter presses.
                        SDL.Render.set_render_target (renderer, render_target);
                        SDL.Render.set_render_draw_color_float (renderer, 0, 0, 0, pressure);
                        SDL.Render.render_line (renderer,
                                                previous_touch_x, previous_touch_y,
                                                ev.pmotion.x, ev.pmotion.y);
                    }
                    previous_touch_x = ev.pmotion.x;
                    previous_touch_y = ev.pmotion.y;
                } else {
                    previous_touch_x = previous_touch_y = -1.0f;
                }
                break;
            case SDL.Events.EventType.PEN_AXIS :
                switch (ev.paxis.axis) {
                case SDL.Pen.PenAxis.PRESSURE:
                    // Remember new pressure for later draws.
                    pressure = ev.paxis.value;
                    break;
                case SDL.Pen.PenAxis.XTILT:
                    tilt_x = ev.paxis.value;
                    break;
                case SDL.Pen.PenAxis.YTILT:
                    tilt_y = ev.paxis.value;
                    break;
                default:
                    break;
                }
                break;
            default:
                break;
            }
        }

        var debug_text = "Tilt: %f %f".printf (tilt_x, tilt_y);
        // Make sure we're drawing to the window and not the render target
        SDL.Render.set_render_target (renderer, null);

        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            SDL.Render.render_texture (renderer, render_target, null, null);
            SDL.Render.render_debug_text (renderer, 0, 8, debug_text);
        }

        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_texture (render_target);
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}