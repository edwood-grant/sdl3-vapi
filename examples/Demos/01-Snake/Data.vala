namespace Snake.Data {
    const int SNAKE_GAME_WIDTH = 24;
    const int SNAKE_GAME_HEIGHT = 18;

    const int STEP_RATE_IN_MILLISECONDS = 125;
    const int SNAKE_BLOCK_SIZE_IN_PIXELS = 24;

    const int SDL_WINDOW_WIDTH = SNAKE_BLOCK_SIZE_IN_PIXELS * SNAKE_GAME_WIDTH;
    const int SDL_WINDOW_HEIGHT = SNAKE_BLOCK_SIZE_IN_PIXELS * SNAKE_GAME_HEIGHT;

    enum SnakeCell {
        NOTHING = 0,
        SRIGHT = 1,
        SUP = 2,
        SLEFT = 3,
        SDOWN = 4,
        FOOD = 5
    } // SnakeCell

    enum SnakeDirection {
        RIGHT,
        UP,
        LEFT,
        DOWN
    } // SnakeDirection
}