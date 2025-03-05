using Snake.Data;

namespace Snake {
    class Context {
        private SnakeCell[,] cells = new SnakeCell[SNAKE_GAME_WIDTH, SNAKE_GAME_HEIGHT];

        private int head_xpos;
        private int head_ypos;
        private int tail_xpos;
        private int tail_ypos;

        private SnakeDirection next_dir;

        private uint inhibit_tail_step;
        private uint occupied_cells;

        public Context () {
            intialize ();
        }

        public void intialize () {
            head_xpos = tail_xpos = SNAKE_GAME_WIDTH / 2;
            head_ypos = tail_ypos = SNAKE_GAME_HEIGHT / 2;
            next_dir = SnakeDirection.RIGHT;

            for (int x = 0; x < SNAKE_GAME_WIDTH; x++) {
                for (int y = 0; y < SNAKE_GAME_HEIGHT; y++) {
                    put_cell_at (x, y, SnakeCell.NOTHING);
                }
            }

            inhibit_tail_step = 4;
            occupied_cells = 3;
            put_cell_at (tail_xpos, tail_ypos, SnakeCell.SRIGHT);

            for (int i = 0; i < 4; i++) {
                new_food_pos ();
                occupied_cells++;
            }
        }

        public void redirect_snake (SnakeDirection dir) {
            SnakeCell ct = get_at (head_xpos, head_ypos);
            if ((dir == SnakeDirection.RIGHT && ct != SnakeCell.SLEFT) ||
                (dir == SnakeDirection.UP && ct != SnakeCell.SDOWN) ||
                (dir == SnakeDirection.LEFT && ct != SnakeCell.SRIGHT) ||
                (dir == SnakeDirection.DOWN && ct != SnakeCell.SUP)) {
                next_dir = dir;
            }
        }

        public void step () {
            SnakeCell dir_as_cell = (SnakeCell) (next_dir + 1);
            SnakeCell ct;
            int prev_xpos;
            int prev_ypos;

            // Move tail forward
            inhibit_tail_step--;
            if (inhibit_tail_step == 0) {
                inhibit_tail_step++;
                ct = get_at (tail_xpos, tail_ypos);
                put_cell_at (tail_xpos, tail_ypos, SnakeCell.NOTHING);

                switch (ct) {
                case SnakeCell.SRIGHT:
                    tail_xpos++;
                    break;
                case SnakeCell.SUP:
                    tail_ypos--;
                    break;
                case SnakeCell.SLEFT:
                    tail_xpos--;
                    break;
                case SnakeCell.SDOWN:
                    tail_ypos++;
                    break;
                default:
                    break;
                }

                wrap_around (ref tail_xpos, SNAKE_GAME_WIDTH);
                wrap_around (ref tail_ypos, SNAKE_GAME_HEIGHT);
            }

            // Move head forward
            prev_xpos = head_xpos;
            prev_ypos = head_ypos;
            switch (next_dir) {
            case SnakeDirection.RIGHT:
                head_xpos++;
                break;
            case SnakeDirection.UP:
                head_ypos--;
                break;
            case SnakeDirection.LEFT:
                head_xpos--;
                break;
            case SnakeDirection.DOWN:
                head_ypos++;
                break;
            }
            wrap_around (ref head_xpos, SNAKE_GAME_WIDTH);
            wrap_around (ref head_ypos, SNAKE_GAME_HEIGHT);

            // Collisions
            ct = get_at (head_xpos, head_ypos);
            if (ct != SnakeCell.NOTHING && ct != SnakeCell.FOOD) {
                intialize ();
                return;
            }

            put_cell_at (prev_xpos, prev_ypos, dir_as_cell);
            put_cell_at (head_xpos, head_ypos, dir_as_cell);

            if (ct == SnakeCell.FOOD) {
                if (are_cells_full ()) {
                    intialize ();
                    return;
                }
                new_food_pos ();
                inhibit_tail_step++;
                occupied_cells++;
            }
        }

        public SnakeCell get_at (uint x, uint y) {
            return cells[x, y];
        }

        void put_cell_at (uint x, uint y, SnakeCell cell) {
            cells[x, y] = cell;
        }

        void new_food_pos () {
            while (true) {
                uint x = SDL.StdInc.rand ((int) SNAKE_GAME_WIDTH);
                uint y = SDL.StdInc.rand ((int) SNAKE_GAME_HEIGHT);
                if (get_at (x, y) == SnakeCell.NOTHING) {
                    put_cell_at (x, y, SnakeCell.FOOD);
                    break;
                }
            }
        }

        private void wrap_around (ref int val, int max) {
            if (val < 0) {
                val = max - 1;
            } else if (val > max - 1) {
                val = 0;
            }
        }

        private bool are_cells_full () {
            return occupied_cells == SNAKE_GAME_WIDTH * SNAKE_GAME_HEIGHT;
        }
    }
}