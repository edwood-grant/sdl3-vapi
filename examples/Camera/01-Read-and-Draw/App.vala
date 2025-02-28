using SDL3;

/*
 * This example code reads frames from a camera and draws it to the screen.
 *
 * This is a very simple approach that is often Good Enough. You can get
 * fancier with this: multiple cameras, front/back facing cameras on phones,
 * color spaces, choosing formats and framerates...this just requests
 * _anything_ and goes with what it is handed.
 *
 * This code is public domain. Feel free to use it for any purpose!
 */

SDL3.Video.Window? window = null;
SDL3.Render.Renderer ? renderer = null;

SDL3.Camera.Camera ? camera = null;
SDL3.Render.Texture ? texture = null;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

public int main (string[] args) {
    SDL3.Init.set_app_metadata ("SDL3 Vala Camera 01 - Read and Draw", "1.0",
                                "dev.vala.example.camera-01-read-and-draw");

    bool success = Init.init (Init.InitFlags.VIDEO | Init.InitFlags.CAMERA);
    if (!success) {
        SDL3.Log.log ("Couldn't initialize SDL: %s", SDL3.Error.get_error ());
        return 1;
    }
    success = SDL3.Render.create_window_and_renderer ("SDL3 Vala Camera 01 - Read and Draw",
                                                      WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                      out window, out renderer);
    if (!success) {
        SDL3.Log.log ("Couldn't create window/renderer: %s", SDL3.Error.get_error ());
        return 1;
    }

    var camera_devices = SDL3.Camera.get_cameras ();
    if (camera_devices == null) {
        SDL3.Log.log ("Couldn't enumerate camera devices: %s", SDL3.Error.get_error ());
        return 2;
    } else if (camera_devices.length == 0) {
        SDL3.Log.log ("Couldn't find any camera devices! Please connect a camera and try again.");
        return 2;
    }

    // Just take the first thing we see in any format it wants. (if you set CameraSpec to null)
    // Vala note: Err, cameras  might have a huge frame resolution and cna hurt our performance, so

    // Lets put is in a smaller format, so it works smoothly. We can create a CameraSpec for that!
    var camera_spec = SDL3.Camera.CameraSpec ();
    // We can search for supported formats and create a spec based on the simplest one
    var supported_formats = SDL3.Camera.get_camera_supported_formats (SDL3.Camera.get_camera_id (camera));
    if (supported_formats != null && supported_formats.length != 0) {
        foreach (var spec in supported_formats) {
            if (spec.width <= WINDOW_WIDTH) {
                camera_spec = spec;
            }
        }
    }

    // Make a general format up if nothing comes up (this can happen on many cameras and on web)
    // Most modern cameras souhld handle this basic format
    if (camera_spec.format == SDL3.Pixels.PixelFormat.UNKNOWN) {
        // Simple RGB24 format
        camera_spec.format = SDL3.Pixels.PixelFormat.RGB24;
        // Use the current window size
        camera_spec.width = WINDOW_WIDTH;
        camera_spec.height = WINDOW_HEIGHT;
        // 1/30 = 0.333 or 30 FPS
        camera_spec.framerate_numerator = 30;
        camera_spec.framerate_denominator = 1;
    }

    message ("Cameraspce format %s", camera_spec.format.to_string ());

    // Just take the first thing we see in any format it wants. (if you set CameraSpec to null)
    // Vala note: We changed this form camera_spec null to our specs that might be smoother
    camera = SDL3.Camera.open_camera (camera_devices[0], camera_spec);
    if (camera == null) {
        SDL3.Log.log ("Couldn't open camera: %s", SDL3.Error.get_error ());
        return 3;
    }

    bool is_running = true;
    SDL3.Events.Event ev;
    while (is_running) {
        while (SDL3.Events.poll_event (out ev)) {
            switch (ev.type) {
            case SDL3.Events.EventType.QUIT :
                is_running = false;
                break;
            case SDL3.Events.EventType.CAMERA_DEVICE_APPROVED :
                SDL3.Log.log ("Camera use approved by user!");
                break;
            case SDL3.Events.EventType.CAMERA_DEVICE_DENIED :
                SDL3.Log.log ("Camera use denied by user!");
                is_running = false;
                break;
                default :
                break;
            }
        }

        uint64 timestamp_ns = 0;
        SDL3.Surface.Surface? frame = SDL3.Camera.aquire_camera_frame (camera, out timestamp_ns);

        if (frame != null) {
            // Some platforms (like Emscripten) don't know _what_ the camera offers
            // until the user gives permission, so we build the texture and resize
            // the window when we get a first frame from the camera.
            if (texture == null) {
                // Resize the window to match
                SDL3.Video.set_window_size (window, frame.w, frame.h);
                texture = SDL3.Render.create_texture (renderer,
                                                      frame.format,
                                                      SDL3.Render.TextureAccess.STREAMING,
                                                      frame.w,
                                                      frame.h);
            }

            if (texture != null) {
                SDL3.Render.update_texture (texture, null, frame.pixels, frame.pitch);
            }

            SDL3.Camera.release_camera_frame (camera, frame);
        }

        SDL3.Render.set_render_draw_color (renderer, 153, 153, 153, SDL3.Pixels.ALPHA_OPAQUE);
        SDL3.Render.render_clear (renderer);
        // Draw the latest camera frame, if available.
        if (texture != null) {
            SDL3.Render.render_texture (renderer, texture, null, null);
        }


        SDL3.Render.render_present (renderer);
    }

    SDL3.Camera.close_camera (camera);
    SDL3.Render.destroy_texture (texture);
    SDL3.Render.destroy_renderer (renderer);
    SDL3.Video.destroy_window (window);
    SDL3.Init.quit ();

    return 0;
}