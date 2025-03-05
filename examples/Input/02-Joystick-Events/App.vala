using SDL;

// This example code looks for joystick input in the event handler, and
// reports any changes as a flood of info.
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
const int MOTION_EVENT_COOLDOWN = 40;
const float MSG_LIFETIME = 3500.0f;

SDL.Video.Window? window = null;
SDL.Render.Renderer ? renderer = null;

SDL.Pixels.Color colors[64];

// These events are spammy, only show every X milliseconds
uint64 axis_motion_cooldown_time = 0;
uint64 ball_motion_cooldown_time = 0;

// A simple container for use to store messages
class EventMessage {
    public string str;
    public SDL.Pixels.Color color;
    public uint64 start_ticks;
}

Array<EventMessage> event_messages;

static void add_message (SDL.Joystick.JoystickID joystick_id, string message_string) {
    var event_message = new EventMessage () {
        str = message_string,
        color = colors[((uint32) joystick_id) % colors.length],
        start_ticks = SDL.Timer.get_ticks (),
    };

    event_messages.append_val (event_message);
}

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Input 02 - Joystick Events", "1.0",
                               "dev.vala.example.input-02-joystick-events");

    bool success = Init.init (Init.InitFlags.VIDEO | Init.InitFlags.JOYSTICK);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Input 02 - Joystick Events",
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

    event_messages = new Array<EventMessage> ();

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            switch (ev.type) {
            case SDL.Events.EventType.QUIT :
                is_running = false;
                break;
            case SDL.Events.EventType.JOYSTICK_ADDED :
                var which = ev.jdevice.which;
                var joystick = SDL.Joystick.open_joystick (which);
                var msg = "";
                if (joystick != null) {
                    msg = "Joystick #%u add, but not opened: %s".printf (which, SDL.Error.get_error ());
                } else {
                    msg = "Joystick #%u ('%s') added".printf (which, SDL.Joystick.get_joystick_name (joystick));
                }
                add_message (which, msg);
                break;
            case SDL.Events.EventType.JOYSTICK_REMOVED:
                var which = ev.jdevice.which;
                var joystick = SDL.Joystick.open_joystick (which);
                if (joystick != null) {
                    var msg = "Joystick #%u ('%s') removed".printf (which, SDL.Joystick.get_joystick_name (joystick));
                    add_message (which, msg);
                    // The joystick was unplugged.
                    SDL.Joystick.close_joystick (joystick);
                }
                break;
            case SDL.Events.EventType.JOYSTICK_AXIS_MOTION:
                // These are spammy, only show every X milliseconds
                axis_motion_cooldown_time = 0;
                var now = SDL.Timer.get_ticks ();
                if (now >= axis_motion_cooldown_time) {
                    var which = ev.jaxis.which;
                    axis_motion_cooldown_time = now + MOTION_EVENT_COOLDOWN;
                    var msg = "Joystick #%u axis %d -> %d".printf (which, ev.jaxis.axis, ev.jaxis.value);
                    add_message (which, msg);
                }
                break;
            case SDL.Events.EventType.JOYSTICK_BALL_MOTION:
                // These are spammy, only show every X milliseconds
                ball_motion_cooldown_time = 0;
                var now = SDL.Timer.get_ticks ();
                if (now >= ball_motion_cooldown_time) {
                    var which = ev.jball.which;
                    ball_motion_cooldown_time = now + MOTION_EVENT_COOLDOWN;
                    var msg = "Joystick #%u ball %d -> %d, %d".printf (which,
                                                                       ev.jball.ball,
                                                                       ev.jball.xrel,
                                                                       ev.jball.yrel);
                    add_message (which, msg);
                }
                break;
            case SDL.Events.EventType.JOYSTICK_HAT_MOTION:
                var which = ev.jhat.which;
                var joystick = SDL.Joystick.get_joystick_from_id (which);
                var hat = SDL.Joystick.get_joystick_hat (joystick, ev.jhat.hat);

                var msg = "Joystick #%u hat %d -> %s".printf (which, ev.jhat.hat, hat.to_string ());
                add_message (which, msg);
                break;
            case SDL.Events.EventType.JOYSTICK_BUTTON_UP:
            case SDL.Events.EventType.JOYSTICK_BUTTON_DOWN:
                var which = ev.jbutton.which;
                var msg = "Joystick #%u button %d -> %s".printf (which, ev.jbutton.button,
                                                                 ev.jbutton.down ? "PRESSED" : "RELEASED");
                add_message (which, msg);
                break;
            case SDL.Events.EventType.JOYSTICK_BATTERY_UPDATED:
                var which = ev.jbattery.which;
                var msg = "Joystick #%u battery -> %s - %d%%".printf (which, ev.jbattery.state.to_string (),
                                                                      ev.jbattery.percent);
                add_message (which, msg);
                break;
            default:
                break;
            }
        }

        float x, y, prev_y = 0f;
        uint64 now = SDL.Timer.get_ticks ();
        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            for (int i = 0; i < event_messages.length; i++) {
                var msg = event_messages.index (i);
                float life_percent = ((float) (now - msg.start_ticks)) / MSG_LIFETIME;
                if (life_percent >= 1.0f) {
                    // msg is done.
                    event_messages.remove_index (i);
                }

                x = (((float) WINDOW_WIDTH) - msg.str.length * SDL.Render.DEBUG_TEXT_FONT_CHARACTER_SIZE) / 2.0f;
                y = ((float) WINDOW_HEIGHT) * life_percent;
                if ((prev_y != 0.0f) && ((prev_y - y) < ((float) SDL.Render.DEBUG_TEXT_FONT_CHARACTER_SIZE * 2))) {
                    msg.start_ticks = now;
                    break; // Wait for the previous message to tick up a little.
                }

                SDL.Render.set_render_draw_color (renderer,
                                                  msg.color.r,
                                                  msg.color.g,
                                                  msg.color.b,
                                                  (uint8) (((float) msg.color.a) * (1.0f - life_percent)));
                SDL.Render.render_debug_text (renderer, x, y, msg.str);
                prev_y = y;
            }
        }

        SDL.Render.render_present (renderer);
    }

    // This sample has a little oversight. Joysticks will leak when retrieving
    // them on the events system! We let them leak for the puproses if this
    // example since we are closing.
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}