using SDL3;

// This example code creates a simple audio stream for playing sound, and
// generates a sine wave sound effect for it to play as time goes on.
//
// This example uses a callback to generate sound. This might be the path of
// least resistance if you're moving an SDL2 program's audio code to SDL3.

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

SDL3.Audio.AudioStream? stream = null;
int current_sine_sample = 0;


// This function will be called (usually in a background thread) when the audio
// stream is consuming data.
public void feed_the_audio_stream_more (SDL3.Audio.AudioStream stream,
                                        int additional_amount,
                                        int total_amount) {

    // total_amount is how much data the audio stream is eating right now,
    // additional_amount is how much more it needs than what it currently has
    // queued (which might be zero!). You can supply any amount of data here; it
    // will take what it needs and use the extra later. If you don't give it
    // enough, it will take everything and then feed silence to the hardware for
    // the rest. Ideally, though, we always give it what it needs and no extra,
    // so we aren't buffering more than necessary.

    additional_amount /= (int) sizeof (float); // convert from bytes to samples
    while (additional_amount > 0) {
        // This will feed 128 samples each frame until we get to our maximum.
        float samples[128];
        int total_samples = SDL3.StdInc.min<int> (additional_amount, samples.length);

        // generate a 440Hz pure tone
        for (int i = 0; i < total_samples; i++) {
            int freq = 440;
            float phase = current_sine_sample * freq / 8000.0f;
            samples[i] = SDL3.StdInc.sinf (phase * 2 * SDL3.StdInc.PI_F);
            current_sine_sample++;
        }

        // Wrapping around to avoid floating-point errors
        current_sine_sample %= 8000;

        // Feed the new data to the stream. It will queue at the end,
        // and trickle out as the hardware needs more data.
        SDL3.Audio.put_audio_stream_data (stream, samples, (int) (total_samples * sizeof (float)));
        additional_amount -= total_samples; // Subtract what we've just fed the stream.
    }
}

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Audio 02 - Simple Playback Callback", "1.0",
                                "dev.vala.example.audio-02-simple-playback-callback");

    bool success = Init.init (Init.InitFlags.VIDEO | Init.InitFlags.AUDIO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Audio 02 - Simple Playback Callback",
                                                      640, 480, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    // We're just playing a single thing here, so we'll use the simplified option.
    // We are always going to feed audio in as mono, float32 data at 8000Hz.
    // The stream will convert it to whatever the hardware wants on the other side.
    var audio_spec = SDL3.Audio.AudioSpec () {
        channels = 1,
        format = SDL3.Audio.AudioFormat.F32,
        freq = 8000,
    };

    stream = SDL3.Audio.open_audio_device_stream (SDL3.Audio.AUDIO_DEVICE_DEFAULT_PLAYBACK,
                                                  audio_spec,
                                                  feed_the_audio_stream_more);
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

        SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_debug_text (renderer,
                                           110, 230,
                                           "A simple sine wave sound should be playing right now.");
            SDL3.Render.render_debug_text (renderer,
                                           110, 250,
                                           "We are using the AudioStream Callback solution here.");
        }
        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}