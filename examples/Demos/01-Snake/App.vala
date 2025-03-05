using SDL;
using Snake.Data;

namespace Snake {
    public class App {
        private Video.Window? _window = null;
        private Render.Renderer? _renderer = null;
        private bool _is_running = true;

        private Snake.Context _context;
        private uint64 last_step;

        public static int main (string[] args) {
            new Snake.App (args);
            return 0;
        }

        public App (string[] args) {
            _context = new Snake.Context ();

            bool res = init ();
            if (!res) {
                return;
            }

            while (_is_running) {
                poll_events ();
                iterate ();
            }

            quit ();
        }

        private bool init () {
            bool success = Init.init (Init.InitFlags.VIDEO);
            if (!success) {
                message ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
                return false;
            }

            success = Render.create_window_and_renderer ("SDL3 Vala Demo 01 - Snake",
                                                         SDL_WINDOW_WIDTH,
                                                         SDL_WINDOW_HEIGHT,
                                                         0,
                                                         out _window,
                                                         out _renderer);
            if (!success) {
                message ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
                return false;
            }

            return true;
        }

        private void poll_events () {
            Events.Event event;
            while (Events.poll_event (out event)) {
                if (event.type == Events.EventType.QUIT) {
                    _is_running = false;
                }

                if (event.type == Events.EventType.KEY_DOWN) {
                    handle_key_event (event.key.scancode);
                }
            }
        }

        private void handle_key_event (Keyboard.Scancode key_code) {
            switch (key_code) {
            // Quit.
            case Keyboard.Scancode.ESCAPE :
            case Keyboard.Scancode.Q :
                _is_running = false;
                break;
            // Restart the game as if the program was launched.
            case Keyboard.Scancode.R:
                _context.intialize ();
                break;
            // Decide new direction of the snake.
            case Keyboard.Scancode.RIGHT:
                _context.redirect_snake (SnakeDirection.RIGHT);
                break;
            case Keyboard.Scancode.UP:
                _context.redirect_snake (SnakeDirection.UP);
                break;
            case Keyboard.Scancode.LEFT:
                _context.redirect_snake (SnakeDirection.LEFT);
                break;
            case Keyboard.Scancode.DOWN:
                _context.redirect_snake (SnakeDirection.DOWN);
                break;
            default:
                break;
            }
        }

        private void iterate () {
            var now = SDL.Timer.get_ticks ();

            // run game logic if we're at or past the time to run it.
            // if we're _really_ behind the time to run it, run it
            // several times.
            while ((now - last_step) >= STEP_RATE_IN_MILLISECONDS) {
                _context.step ();
                last_step += STEP_RATE_IN_MILLISECONDS;
            }

            var r = Rect.FRect ();
            r.w = r.h = SNAKE_BLOCK_SIZE_IN_PIXELS;

            SDL.Render.set_render_draw_color (_renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_clear (_renderer);
            {
                for (int x = 0; x < SNAKE_GAME_WIDTH; x++) {
                    for (int y = 0; y < SNAKE_GAME_HEIGHT; y++) {
                        var ct = _context.get_at (x, y);
                        if (ct == SnakeCell.NOTHING) {
                            continue;
                        }
                        set_rect_xy (ref r, x, y);

                        if (ct == SnakeCell.FOOD) {
                            SDL.Render.set_render_draw_color (_renderer, 80, 80, 255, SDL.Pixels.ALPHA_OPAQUE);
                        } else {
                            // Body
                            SDL.Render.set_render_draw_color (_renderer, 0, 128, 0, SDL.Pixels.ALPHA_OPAQUE);
                        }
                        SDL.Render.render_fill_rect (_renderer, r);
                    }
                }
            }
            SDL.Render.render_present (_renderer);
        }

        private void set_rect_xy (ref Rect.FRect r, int x, int y) {
            r.x = (float) (x * SNAKE_BLOCK_SIZE_IN_PIXELS);
            r.y = (float) (y * SNAKE_BLOCK_SIZE_IN_PIXELS);
        }

        private void quit () {
            Video.destroy_window (_window);
            Render.destroy_renderer (_renderer);
            Init.quit ();
        }
    }
}