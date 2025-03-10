using SDL;

// This example code loads two .wav files, puts them an audio streams and binds
// them for playback, repeating both sounds on loop. This shows several streams
// mixing into a single playback device.
//
// The song sample is called "Play Now!" by Cleyton Kauffman
// https://opengameart.org/content/anime-esque-intro-outro-theme
// Music by Cleyton Kauffman - https://soundcloud.com/cleytonkauffman
//
// Sword WAV is sword04.wav by Erdie  -- License: Attribution 4.0
// https://freesound.org/s/27858/

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;
SDL.Audio.AudioDeviceID audio_device;

// Class to stroe things that are playing sound (the audiostream itself, plus
// the original data, so we can refill to loop.
class Sound {
    public uint8[] wav_data;
    public SDL.Audio.AudioStream? stream = null;
}

Sound sounds[2];

static bool init_sound (string file_name, out Sound sound) {
    sound = new Sound ();
    // Basic audio spec. System will fill what it needs when loading the wav
    var wav_audio_spec = SDL.Audio.AudioSpec ();

    // Load the .wav file from wherever the app is being run from.
    var wav_path = SDL.FileSystem.get_base_path () + file_name;
    var success = SDL.Audio.load_wav (wav_path, out wav_audio_spec, out sound.wav_data);
    if (!success) {
        SDL.Log.log ("Couldn't load .wav file: %s", SDL.Error.get_error ());
        return false;
    }

    // Create an audio stream. Set the source format to the wav's format (what
    // we'll input), leave the dest format null here (it'll change to what the
    // device wants once we bind it).
    sound.stream = SDL.Audio.create_audio_stream (wav_audio_spec, null);
    if (sound.stream == null) {
        SDL.Log.log ("Couldn't create audio stream: %s", SDL.Error.get_error ());
        return false;
    }

    // Once bound, it'll start playing when there is data available!
    success = SDL.Audio.bind_audio_stream (audio_device, sound.stream);
    if (!success) {
        SDL.Log.log ("Failed to bind '%s' stream to device: %s", file_name, SDL.Error.get_error ());
    }

    return true;
}

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Audio 04 - Mulitple Streams", "1.0",
                               "dev.vala.example.audio-04-mutiple-streams");

    bool success = Init.init (SDL.Init.InitFlags.VIDEO | SDL.Init.InitFlags.AUDIO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Audio 04 - Mulitple Streams",
                                                     640, 480, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    // Open the default audio device in whatever format it prefers; our audio
    // streams will adjust to it.
    audio_device = SDL.Audio.open_audio_device (SDL.Audio.AUDIO_DEVICE_DEFAULT_PLAYBACK, null);
    if (audio_device == 0) {
        SDL.Log.log ("Couldn't open audio device: %s", SDL.Error.get_error ());
        return 2;
    }

    if (!init_sound ("play_now_intro.wav", out sounds[0])) {
        SDL.Log.log ("Couldn't load: play_now_intro.wav");
        return 3;
    } else if (!init_sound ("sword04.wav", out sounds[1])) {
        SDL.Log.log ("Couldn't load: sword04.wav");
        return 3;
    }

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        foreach (var snd in sounds) {
            // If less than a full copy of the audio is queued for playback, put
            // another copy in there. This is overkill, but easy when lots of RAM is
            // cheap. One could be more careful and queue less at a time, as long as
            // the stream doesn't run dry.
            if (SDL.Audio.get_audio_stream_available (snd.stream) < snd.wav_data.length) {
                SDL.Audio.put_audio_stream_data (snd.stream, snd.wav_data, snd.wav_data.length);
            }
        }

        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            SDL.Render.set_render_draw_color (renderer, 255, 255, 255, SDL.Pixels.ALPHA_OPAQUE);
            SDL.Render.render_debug_text (renderer,
                                          60, 230,
                                          "A sample from 'Play Now!' by Cleyton Kauffman should be playing");
            SDL.Render.render_debug_text (renderer,
                                          60, 250,
                                          "A small sword clash WAV file should also be playing");
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Audio.close_audio_device (audio_device);
    foreach (var snd in sounds) {
        SDL.Audio.destroy_audio_stream (snd.stream);
        snd.wav_data.resize (0); // Not needed since we are quitting but its good practice
    }
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}