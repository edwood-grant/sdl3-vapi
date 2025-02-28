using SDL3;

// This example code creates a simple audio stream for playing sound, and loads
// a .wav file that is pushed through the stream in a loop.
// The .wav file is a sample from Will Provost's song, The Living Proof, used
// with permission.
//
// The song is called "Play Now!" by Cleyton Kauffman
// https://opengameart.org/content/anime-esque-intro-outro-theme
// Music by Cleyton Kauffman - https://soundcloud.com/cleytonkauffman

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

SDL3.Audio.AudioStream? stream = null;
uint8[] ? wav_data = null;

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Audio 03 - Load WAV", "1.0",
                                "dev.vala.example.audio-03-load-wav");

    bool success = Init.init (Init.InitFlags.VIDEO | Init.InitFlags.AUDIO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Audio 03 - Load WAV",
                                                      640, 480, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    // Basic audio spec. System will fill what it needs when loading the wav
    var wav_audio_spec = SDL3.Audio.AudioSpec ();

    // Load the .wav file from wherever the app is being run from.
    var wav_path = SDL3.FileSystem.get_base_path () + "play_now_intro.wav";
    success = SDL3.Audio.load_wav (wav_path, out wav_audio_spec, out wav_data);
    if (!success) {
        SDL3.Log.log ("Couldn't load .wav file: %s", SDL3.Error.get_error ());
        return 2;
    }

    stream = SDL3.Audio.open_audio_device_stream (SDL3.Audio.AUDIO_DEVICE_DEFAULT_PLAYBACK,
                                                  wav_audio_spec,
                                                  null);
    if (stream == null) {
        SDL3.Log.log ("Couldn't create audio stream: %s", SDL3.Error.get_error ());
        return 2;
    }

    // SDL3.Audio.open_audio_device_stream starts the device paused. You have to tell it to start!
    SDL3.Audio.resume_audio_stream_device (stream);

    bool is_running = true;
    SDL3.Events.Event ev;
    while (is_running) {
        while (SDL3.Events.poll_event (out ev)) {
            if (ev.type == SDL3.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        // Cee if we need to feed the audio stream more data yet. We're being
        // lazy here, but if there's less than the entire wav file left to play,
        // just shove a whole copy of it into the queue, so we always have
        // *tons* of data queued for playback.
        if (SDL3.Audio.get_audio_stream_available (stream) < wav_data.length) {
            SDL3.Audio.put_audio_stream_data (stream, wav_data, wav_data.length);
        }


        SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_debug_text (renderer,
                                           60, 240,
                                           "A sample from 'Play Now!' by Cleyton Kauffman should be playing");
        }
        SDL3.Render.render_present (renderer);
    }

    wav_data.resize (0); // Not needed since we are quitting but its good practice
    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}