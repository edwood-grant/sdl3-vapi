using SDL3;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

SDL3.Render.Texture? texture = null;
SDL3.AsyncIO.AsyncIOQueue? queue = null;

const string BITMAPS[5] = {
    "sample.bmp", "gamepad_front.bmp",
    "speaker.bmp", "icon2x.bmp", "vala_logo.bmp"
};

const SDL3.Rect.FRect TEXTURE_RECTS[BITMAPS.length] = {
    { 116, 156, 408, 167 },
    { 20, 200, 96, 60 },
    { 525, 180, 96, 96 },
    { 288, 375, 64, 64 },
    { 256, 10, 128, 128 },
};
SDL3.Render.Texture textures[BITMAPS.length];

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala AsyncIO Example 01 - Load Bitmaps", "1.0",
                                "dev.vala.example.asyncio-01-load-bitmaps");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala AsyncIO Example 01 - Load Bitmaps",
                                                      WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    queue = SDL3.AsyncIO.create_async_io_queue ();
    if (queue == null) {
        SDL3.Log.log ("Couldn't create async i/o queue: %s", SDL3.Error.get_error ());
        return 2;
    }

    /* Load some .bmp files asynchronously from wherever the app is being run from, put them in the same queue. */
    for (int i = 0; i < BITMAPS.length; i++) {
        // Full File path
        string path = SDL3.FileSystem.get_base_path () + BITMAPS[i];
        // You *should* check for failure, but we'll just go on without files here.
        // Attach the filename as app-specific data, so we can see it later.
        SDL3.AsyncIO.load_file_async (path, queue, (void*) BITMAPS[i]);
        // SDL_LoadFileAsync (path, queue, (void*) bmps[i]);
    }

    bool is_running = true;
    SDL3.Events.Event ev;
    while (is_running) {
        while (SDL3.Events.poll_event (out ev)) {
            if (ev.type == SDL3.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        SDL3.AsyncIO.AsyncIOOutcome outcome;
        if (SDL3.AsyncIO.get_async_io_result (queue, out outcome)) {
            // a .bmp file load has finished?
            if (outcome.result == SDL3.AsyncIO.AsyncIOResult.COMPLETE) {
                // This might be _any_ of the bmps; they might finish loading in any order.
                for (int i = 0; i < BITMAPS.length; i++) {
                    // this doesn't need a strcmp because we gave the pointer
                    // from this array to SDL_LoadFileAsync
                    if (outcome.userdata == BITMAPS[i]) {
                        var io_stream = SDL3.IOStream.io_from_const_mem (outcome.buffer,
                                                                         (size_t) outcome.bytes_transferred);
                        var surface = SDL3.Surface.load_bmp_io (io_stream, true);
                        // The renderer is not multithreaded, so create the texture here once the data loads.
                        if (surface != null) {
                            textures[i] = SDL3.Render.create_texture_from_surface (renderer, surface);
                            if (textures[i] == null) {
                                SDL3.Log.log ("Couldn't create texture: %s", SDL3.Error.get_error ());
                                return 3;
                            }
                            SDL3.Surface.destroy_surface (surface);
                        }
                        break;
                    }
                }
            }
        }

        // Black, full alpha
        SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            for (int i = 0; i < textures.length; i++) {
                SDL3.Render.render_texture (renderer, textures[i], null, TEXTURE_RECTS[i]);
            }
        }
        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_texture (texture);
    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}