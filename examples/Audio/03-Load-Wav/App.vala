using SDL;

// This example code creates a simple audio stream for playing sound, and loads
// a .wav file that is pushed through the stream in a loop.
// The .wav file is a sample from Will Provost's song, The Living Proof, used
// with permission.
//
// The song is called "Play Now!" by Cleyton Kauffman
// https://opengameart.org/content/anime-esque-intro-outro-theme
// Music by Cleyton Kauffman - https://soundcloud.com/cleytonkauffman

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;

SDL.Audio.AudioStream? stream = null;
uint8[] ? wav_data = null;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Audio 03 - Load WAV", "1.0",
                               "dev.vala.example.audio-03-load-wav");

    bool success = Init.init (Init.InitFlags.VIDEO | Init.InitFlags.AUDIO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Audio 03 - Load WAV",
                                                     640, 480, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    // Basic audio spec. System will fill what it needs when loading the wav
    var wav_audio_spec = SDL.Audio.AudioSpec ();

    // Load the .wav file from wherever the app is being run from.
    var wav_path = SDL.FileSystem.get_base_path () + "play_now_intro.wav";
    success = SDL.Audio.load_wav (wav_path, out wav_audio_spec, out wav_data);
    if (!success) {
        SDL.Log.log ("Couldn't load .wav file: %s", SDL.Error.get_error ());
        return 2;
    }

    stream = SDL.Audio.open_audio_device_stream (SDL.Audio.AUDIO_DEVICE_DEFAULT_PLAYBACK,
                                                 wav_audio_spec,
                                                 null);
    if (stream == null) {
        SDL.Log.log ("Couldn't create audio stream: %s", SDL.Error.get_error ());
        return 2;
    }

    // SDL.Audio.open_audio_device_stream starts the device paused. You have to tell it to start!
    SDL.Audio.resume_audio_stream_device (stream);

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        // Cee if we need to feed the audio stream more data yet. We're being
        // lazy here, but if there's less than the entire wav file left to play,
        // just shove a whole copy of it into the queue, so we always have
        // *tons* of data queued for playback.
        if (SDL.Audio.get_audio_stream_available (stream) < wav_data.length) {
            SDL.Audio.put_audio_stream_data (stream, wav_data, wav_data.length);
        }


        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            SDL.Render.set_render_draw_color (renderer, 255, 255, 255, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_debug_text (renderer,
                                          60, 240,
                                          "A sample from 'Play Now!' by Cleyton Kauffman should be playing");
        }
        SDL.Render.render_present (renderer);
    }

    wav_data.resize (0); // Not needed since we are quitting but its good practice
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}