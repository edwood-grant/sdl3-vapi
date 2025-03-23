using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

Video.Window? window = null;
Gpu.GPUDevice ? gpu_device = null;

Gpu.GPUGraphicsPipeline ? fill_pipeline = null;
Gpu.GPUGraphicsPipeline ? line_pipeline = null;

Gpu.GPUViewport full_viewport = { 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0.1f, 1.0f };
Gpu.GPUViewport small_viewport = { WINDOW_WIDTH / 4,
                                   WINDOW_HEIGHT / 4,
                                   WINDOW_WIDTH / 2,
                                   WINDOW_HEIGHT / 2,
                                   0.1f, 1.0f };
Rect.Rect scissor_rect = { 320, 240, 320, 240 };

bool use_wireframe_mode = false;
bool use_small_viewport = false;
bool use_scissor_rect = false;

public int main (string[] args) {
    Init.set_app_metadata ("SDL3 Vala GPU 01 - Basic Triangle", "1.0",
                           "dev.vala.example.gpu-01-basic-triangle");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }

    success = common_init ("SDL3 Vala GPU 01 - Basic Triangle",
                           WINDOW_WIDTH, WINDOW_HEIGHT,
                           out gpu_device, out window);
    if (!success) {
        return -1;
    }

    // Create the shaders
    Gpu.GPUShader ? vertex_shader = load_shader (gpu_device, "RawTriangle.vert", 0, 0, 0, 0);
    if (vertex_shader == null) {
        SDL.Log.log ("Failed to create vertex shader!");
        return -1;
    }

    Gpu.GPUShader ? fragment_shader = load_shader (gpu_device, "SolidColor.frag", 0, 0, 0, 0);
    if (fragment_shader == null) {
        SDL.Log.log ("Failed to create fragment shader!");
        return -1;
    }

    // Create the graphics pipelines one filled and one just wireframe
    fill_pipeline = create_graphics_pipeline (gpu_device, window, vertex_shader, fragment_shader);
    if (fill_pipeline == null) {
        SDL.Log.log ("Failed to create fill pipeline!");
        return -1;
    }

    line_pipeline = create_graphics_pipeline (gpu_device, window,
                                              vertex_shader, fragment_shader, Gpu.GPUFillMode.LINE);
    if (line_pipeline == null) {
        SDL.Log.log ("Failed to create fill pipeline!");
        return -1;
    }

    // Once shaders are used to create a pipeline, they can be released
    // You can also release them at the end in case you still need them
    Gpu.release_gpu_shader (gpu_device, vertex_shader);
    Gpu.release_gpu_shader (gpu_device, fragment_shader);

    bool is_running = true;
    Events.Event ev;
    while (is_running) {
        while (Events.poll_event (out ev)) {
            if (ev.type == Events.EventType.QUIT) {
                is_running = false;
            }

            switch (ev.type) {
            case Events.EventType.QUIT :
                is_running = false;
                break;
            case Events.EventType.KEY_DOWN :
                switch (ev.key.key) {
                case Keyboard.Keycode.LEFT :
                    use_wireframe_mode = !use_wireframe_mode;
                    break;
                case Keyboard.Keycode.RIGHT :
                    use_scissor_rect = !use_scissor_rect;
                    break;
                case Keyboard.Keycode.DOWN :
                    use_small_viewport = !use_small_viewport;
                    break;
                    default :
                    break;
                }
                break;
            default:
                break;
            }
        }

        // GPU rendering is a completely different beast from a standard renderer
        // A GPU rendering procesis composed of command buffer and passes
        //
        // A command buffer is a message relay between the program and the GPU
        // You ask for the command buffer and for the swapchian texture
        //
        // The swapchain texture is just teh render buffer we draw in,
        // similar to the rednerer in standard SDL
        //
        // You grab the buffer and execute passes, usually render passes (but there can be others)
        // These passes are then bound to a graphics pipeline i.e. a vertex and fragment shader
        //
        // You then draw primitives this way, the render pass will apply the shaders onto the
        // list of tiranglesand indices.
        //
        // You then end the passes and 'submit' the command buffer,
        // the GPU then execute all that on its own, and then repeat per loop.
        //
        // It's a lot to take int, but the basics are there.
        // The rest is being creative in the shader and what triangles you draw!
        Gpu.GPUCommandBuffer? cmd_buf = Gpu.acquire_gpu_command_buffer (gpu_device);
        if (cmd_buf == null) {
            SDL.Log.log ("AcquireGPUCommandBuffer failed: %s", SDL.Error.get_error ());
            return -1;
        }

        Gpu.GPUTexture? swapchain_texture;
        success = Gpu.wait_and_acquire_gpu_swapchain_texture (cmd_buf, window, out swapchain_texture, null, null);
        if (!success) {
            SDL.Log.log ("wait_and_acquire_gpu_swapchain_texture failed: %s", SDL.Error.get_error ());
            return -1;
        }

        if (swapchain_texture != null) {
            var color_target = Gpu.GPUColorTargetInfo () {
                texture = swapchain_texture,
                clear_color = {
                    0.1f, 0.1f, 0.1f, 1.0f
                },
                load_op = Gpu.GPULoadOp.CLEAR,
                store_op = Gpu.GPUStoreOp.STORE,
                mip_level = 0,
                cycle = true,
                layer_or_depth_plane = 0,
                cycle_resolve_texture = false,
            };

            // Don't forget to pass GPUColorTargetInfo ownership to the array here!
            var render_pass = Gpu.begin_gpu_render_pass (cmd_buf, { (owned) color_target }, null);
            Gpu.bind_gpu_graphics_pipeline (render_pass, use_wireframe_mode ? line_pipeline : fill_pipeline);

            if (use_small_viewport) {
                Gpu.set_gpu_viewport (render_pass, small_viewport);
            } else {
                Gpu.set_gpu_viewport (render_pass, full_viewport);
            }

            if (use_scissor_rect) {
                Gpu.set_gpu_scissor (render_pass, scissor_rect);
            }

            Gpu.draw_gpu_primitives (render_pass, 3, 1, 0, 0);
            Gpu.end_gpu_render_pass (render_pass);
        }

        if (!Gpu.submit_gpu_command_buffer (cmd_buf)) {
            SDL.Log.log ("Couldn't submit the comma buffer: %s", SDL.Error.get_error ());
        }
    }

    // CLEAN UP!
    // Release the pipelines
    Gpu.release_gpu_graphics_pipeline (gpu_device, fill_pipeline);
    Gpu.release_gpu_graphics_pipeline (gpu_device, line_pipeline);
    // Release window
    Gpu.release_window_from_gpu_device (gpu_device, window);
    // Destoy window, device and quit
    Video.destroy_window (window);
    Gpu.destroy_gpu_device (gpu_device);
    Init.quit ();
    return 0;
}

public static Gpu.GPUGraphicsPipeline create_graphics_pipeline (Gpu.GPUDevice device,
                                                                Video.Window window,
                                                                Gpu.GPUShader vertex_shader,
                                                                Gpu.GPUShader fragment_shader,
                                                                Gpu.GPUFillMode fill_mode =
                                                                Gpu.GPUFillMode.FILL) {
    var create_info = Gpu.GPUGraphicsPipelineCreateInfo () {
        vertex_shader = vertex_shader,
        fragment_shader = fragment_shader,
        primitive_type = Gpu.GPUPrimitiveType.TRIANGLELIST,
        rasterizer_state = Gpu.GPURasterizerState () {
            cull_mode = Gpu.GPUCullMode.NONE,
            fill_mode = fill_mode,
        },

        target_info = Gpu.GPUGraphicsPipelineTargetInfo () {
            color_target_descriptions = {
                Gpu.GPUColorTargetDescription () {
                    format = Gpu.get_gpu_swapchain_texture_format (device, window),
                }
            },
        },
    };

    return Gpu.create_gpu_graphics_pipeline (device, create_info);
}