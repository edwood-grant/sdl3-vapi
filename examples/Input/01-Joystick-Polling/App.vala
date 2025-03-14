using SDL;

// This example code looks for the current joystick state once per frame, and
// draws a visual representation of it.
//
// Joysticks are low-level interfaces: there's something with a bunch of
// buttons, axes and hats, in no understood order or position.
//
// This is a flexible interface, but you'll need to build some sort of
// configuration UI to let people tell you what button, etc, does what.
//
// On top of this interface, SDL offers the "gamepad" API, which works with lots
// of devices, and knows how to map arbitrary buttons and such to look like an
// Xbox/PlayStation/etc gamepad. This is easier, and better, for many games, but
// isn't necessarily a good fit for complex apps and hardware. A flight
// simulator, a realistic racing game, etc, might want this interface instead of
// gamepads.
//
// SDL can handle multiple joysticks, but for simplicity, this program only
// deals with the first stick it sees.

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL.Video.Window? window = null;
SDL.Render.Renderer ? renderer = null;

SDL.Joystick.Joystick ? joystick = null;
SDL.Pixels.Color colors[64];

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Input 01 - Joystick Polling", "1.0",
                               "dev.vala.example.input-01-joystick-polling");

    bool success = Init.init (Init.InitFlags.VIDEO | Init.InitFlags.JOYSTICK);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Input 01 - Joystick Polling",
                                                     WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    // Random Colors!
    for (int i = 0; i < colors.length; i++) {
        colors[i].r = (uint8) SDL.StdInc.rand (255);
        colors[i].g = (uint8) SDL.StdInc.rand (255);
        colors[i].b = (uint8) SDL.StdInc.rand (255);
        colors[i].a = 255;
    }

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            switch (ev.type) {
            case SDL.Events.EventType.QUIT :
                is_running = false;
                break;
            case SDL.Events.EventType.JOYSTICK_ADDED :
                if (joystick == null) {
                    joystick = SDL.Joystick.open_joystick (ev.jdevice.which);
                    if (joystick == null) {
                        SDL.Log.log ("Failed to open joystick ID %u: %s",
                                     ev.jdevice.which, SDL.Error.get_error ());
                    }
                }
                break;
            case SDL.Events.EventType.JOYSTICK_REMOVED :
                if (joystick != null && SDL.Joystick.get_joystick_id (joystick) == ev.jdevice.which) {
                    // Our joystick was unplugged.
                    SDL.Joystick.close_joystick (joystick);
                    joystick = null;
                }
                break;
            default:
                break;
            }
        }

        var text = "Plug in a joystick, please.";
        // we have a stick opened?
        if (joystick != null) {
            text = SDL.Joystick.get_joystick_name (joystick);
        }

        float x, y;

        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            if (joystick != null) {
                float size = 30.0f;
                // Draw axes as bars going across middle of screen. We don't know if
                // it's an X or Y or whatever axis, so we can't do more than this.
                int total = SDL.Joystick.get_num_joystick_axes (joystick);

                y = (WINDOW_HEIGHT - (total * size)) / 2;
                x = ((float) WINDOW_WIDTH) / 2.0f;

                for (int i = 0; i < total; i++) {
                    var color = colors[i % colors.length];
                    // Make it -1.0f to 1.0f
                    var val = (((float) SDL.Joystick.get_joystick_axis (joystick, i)) / int16.MAX);

                    float dx = x + (val * x);
                    SDL.Rect.FRect dst = { dx, y, x - SDL.StdInc.fabsf (dx), size };
                    SDL.Render.set_render_draw_color (renderer, color.r, color.g, color.b, color.a);
                    SDL.Render.render_fill_rect (renderer, dst);
                    y += size;
                }

                // Draw buttons as blocks across top of window. We only know the
                // button numbers, but not where they are on the device.
                total = SDL.Joystick.get_num_joystick_buttons (joystick);
                x = (WINDOW_WIDTH - (total * size)) / 2;
                for (int i = 0; i < total; i++) {
                    var color = colors[i % colors.length];
                    SDL.Rect.FRect dst = { x, 0.0f, size, size };
                    if (SDL.Joystick.get_joystick_button (joystick, i)) {
                        SDL.Render.set_render_draw_color (renderer, color.r, color.g, color.b, color.a);
                    } else {
                        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, 255);
                    }
                    SDL.Render.render_fill_rect (renderer, dst);
                    SDL.Render.set_render_draw_color (renderer, 255, 255, 255, color.a);

                    // Outline it
                    SDL.Render.render_rect (renderer, dst);
                    x += size;
                }

                // Draw hats across the bottom of the screen.
                total = SDL.Joystick.get_num_joystick_hats (joystick);
                x = ((WINDOW_WIDTH - (total * (size * 2.0f))) / 2.0f) + (size / 2.0f);
                y = ((float) WINDOW_HEIGHT) - size;
                for (int i = 0; i < total; i++) {
                    var color = colors[i % colors.length];

                    // Draw hat cross
                    float thirdsize = size / 3.0f;
                    SDL.Rect.FRect cross[] = {
                        { x, y + thirdsize, size, thirdsize },
                        { x + thirdsize, y, thirdsize, size }
                    };
                    uint8 hat = SDL.Joystick.get_joystick_hat (joystick, i);
                    SDL.Render.set_render_draw_color (renderer, 90, 90, 90, 255);
                    SDL.Render.render_fill_rects (renderer, cross);

                    // Draw hat positions if enabled. We are using bitwise
                    // operation the check for all hats.
                    //
                    // But you can also ask directly for the value e.g.:
                    // (hat == SDL.Joystick.JoystickHat.LEFT)
                    //
                    // Or you can also query the mixed enum values e.g.:
                    // (hat == SDL.Joystick.JoystickHat.LEFTDOWN)
                    SDL.Render.set_render_draw_color (renderer, color.r, color.g, color.b, color.a);
                    if ((hat & SDL.Joystick.JoystickHat.UP) != 0) {
                        SDL.Rect.FRect dst = { x + thirdsize, y, thirdsize, thirdsize };
                        SDL.Render.render_fill_rect (renderer, dst);
                    }

                    if ((hat & SDL.Joystick.JoystickHat.RIGHT) != 0) {
                        SDL.Rect.FRect dst = { x + (thirdsize * 2), y + thirdsize, thirdsize, thirdsize };
                        SDL.Render.render_fill_rect (renderer, dst);
                    }

                    if ((hat & SDL.Joystick.JoystickHat.DOWN) != 0) {
                        SDL.Rect.FRect dst = { x + thirdsize, y + (thirdsize * 2), thirdsize, thirdsize };
                        SDL.Render.render_fill_rect (renderer, dst);
                    }

                    if ((hat & SDL.Joystick.JoystickHat.LEFT) != 0) {
                        SDL.Rect.FRect dst = { x, y + thirdsize, thirdsize, thirdsize };
                        SDL.Render.render_fill_rect (renderer, dst);
                    }

                    x += size * 2;
                }
            }

            // Render the joysick name (or ask for a josytick if there is none)
            x = (((float) WINDOW_WIDTH) - (text).length * SDL.Render.DEBUG_TEXT_FONT_CHARACTER_SIZE) / 2.0f;
            y = (((float) WINDOW_HEIGHT) - SDL.Render.DEBUG_TEXT_FONT_CHARACTER_SIZE) / 2.0f;
            SDL.Render.set_render_draw_color (renderer, 255, 255, 255, 255);
            SDL.Render.render_debug_text (renderer, x, y, text);
        }
        SDL.Render.render_present (renderer);
    }

    if (joystick != null) {
        SDL.Joystick.close_joystick (joystick);
        joystick = null;
    }

    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}