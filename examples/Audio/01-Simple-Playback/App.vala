using SDL3;

// This example code creates a simple audio stream for playing sound, and
// generates a sine wave sound effect for it to play as time goes on. This is
// the simplest way to get up and running with procedural sound.

SDL3.Video.Window? window = null;
SDL3.Render.Renderer? renderer = null;

SDL3.Audio.AudioStream? stream = null;
int current_sine_sample = 0;

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Audio 01 - Simple Playback", "1.0",
                                "dev.vala.example.audio-01-simple-playback");

    bool success = Init.init (Init.InitFlags.VIDEO | Init.InitFlags.AUDIO);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Audio 01 - Simple Playback",
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

        // See if we need to feed the audio stream more data yet. We're being
        // lazy here, but if there's less than half a second queued, generate
        // more. A sine wave is unchanging audio--easy to stream--but for video
        // games, you'll want to generate significantly _less_ audio ahead of
        // time!

        // 8000 float samples per second. Half of that.
        ulong minimum_audio = (8000 * sizeof (float)) / 2;

        if (SDL3.Audio.get_audio_stream_available (stream) < minimum_audio) {
            // This will feed 512 samples each frame until we get to our maximum.
            float samples[512];

            // generate a 440Hz pure tone
            for (int i = 0; i < samples.length; i++) {
                int freq = 440;
                float phase = current_sine_sample * freq / 8000.0f;
                samples[i] = SDL3.StdInc.sinf (phase * 2 * SDL3.StdInc.PI_F);
                current_sine_sample++;
            }

            // Wrapping around to avoid floating-point errors
            current_sine_sample %= 8000;

            // Feed the new data to the stream. It will queue at the end,
            // and trickle out as the hardware needs more data.
            SDL3.Audio.put_audio_stream_data (stream, samples, (int) (samples.length * sizeof (float)));
        }

        SDL3.Render.set_render_draw_color (renderer, 0, 0, 0, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        {
            SDL3.Render.set_render_draw_color (renderer, 255, 255, 255, SDL3.Pixels.ALPHA_OPAQUE);
            SDL3.Render.render_debug_text (renderer,
                                           110, 240,
                                           "A simple sine wave sound should be playing right now.");
        }
        SDL3.Render.render_present (renderer);
    }

    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}