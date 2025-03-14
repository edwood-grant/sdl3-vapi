using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL.Video.Window? window = null;
SDL.Gpu.GPUDevice ? gpu_device = null;

SDL.Gpu.GPUGraphicsPipeline ? fill_pipeline = null;
SDL.Gpu.GPUGraphicsPipeline ? line_pipeline = null;

SDL.Gpu.GPUViewport full_viewport = { 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0.1f, 1.0f };
SDL.Gpu.GPUViewport small_viewport = { WINDOW_WIDTH / 4,
                                       WINDOW_HEIGHT / 4,
                                       WINDOW_WIDTH / 2,
                                       WINDOW_HEIGHT / 2,
                                       0.1f, 1.0f };
SDL.Rect.Rect scissor_rect = { 320, 240, 320, 240 };

bool use_wireframe_mode = false;
bool use_small_viewport = false;
bool use_scissor_rect = false;

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala GPU 01 - Basic Triangle", "1.0",
                               "dev.vala.example.gpu-01-basic.triangle");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }

    // Create the device, window, and bind them together
    var gpu_flags = SDL.Gpu.GPUShaderFormat.SPIRV | SDL.Gpu.GPUShaderFormat.DXIL | SDL.Gpu.GPUShaderFormat.MSL;
    gpu_device = SDL.Gpu.create_gpu_device (gpu_flags, true, null);
    if (gpu_device == null) {
        SDL.Log.log ("Couldn't crete GPU device: %s", SDL.Error.get_error ());
        return 2;
    }

    window = SDL.Video.create_window ("SDL3 Vala GPU 01 - Basic Triangle", WINDOW_WIDTH, WINDOW_HEIGHT, 0);
    if (window == null) {
        SDL.Log.log ("CreateWindow failed: %s", SDL.Error.get_error ());
        return -1;
    }

    success = SDL.Gpu.claim_window_for_gpu_device (gpu_device, window);
    if (!success) {
        SDL.Log.log ("Couldn't claim window for GPU: %s", SDL.Error.get_error ());
        return -1;
    }

    // Create the shaders
    SDL.Gpu.GPUShader ? vertex_shader = load_shader (gpu_device, "RawTriangle.vert", 0, 0, 0, 0);
    if (vertex_shader == null) {
        SDL.Log.log ("Failed to create vertex shader!");
        return -1;
    }

    SDL.Gpu.GPUShader ? fragment_shader = load_shader (gpu_device, "SolidColor.frag", 0, 0, 0, 0);
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
                                              vertex_shader, fragment_shader, SDL.Gpu.GPUFillMode.LINE);
    if (line_pipeline == null) {
        SDL.Log.log ("Failed to create fill pipeline!");
        return -1;
    }

    // Once shaders are used to create a pipeline, they can be released
    // You can also release them at the end in case you still need them
    SDL.Gpu.release_gpu_shader (gpu_device, vertex_shader);
    SDL.Gpu.release_gpu_shader (gpu_device, fragment_shader);

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }

            switch (ev.type) {
            case SDL.Events.EventType.QUIT :
                is_running = false;
                break;
            case SDL.Events.EventType.KEY_DOWN :
                switch (ev.key.key) {
                case SDL.Keyboard.Keycode.LEFT :
                    use_wireframe_mode = !use_wireframe_mode;
                    break;
                case SDL.Keyboard.Keycode.RIGHT :
                    use_scissor_rect = !use_scissor_rect;
                    break;
                case SDL.Keyboard.Keycode.DOWN :
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
        SDL.Gpu.GPUCommandBuffer? cmd_buf = SDL.Gpu.acquire_gpu_command_buffer (gpu_device);
        if (cmd_buf == null) {
            SDL.Log.log ("AcquireGPUCommandBuffer failed: %s", SDL.Error.get_error ());
            return -1;
        }

        SDL.Gpu.GPUTexture? swapchain_texture;
        success = SDL.Gpu.wait_and_acquire_gpu_swapchain_texture (cmd_buf, window, out swapchain_texture, null, null);
        if (!success) {
            SDL.Log.log ("wait_and_acquire_gpu_swapchain_texture failed: %s", SDL.Error.get_error ());
            return -1;
        }

        if (swapchain_texture != null) {
            var color_target = SDL.Gpu.GPUColorTargetInfo () {
                texture = swapchain_texture,
                clear_color = {
                    0.1f, 0.1f, 0.1f, 1.0f
                },
                load_op = SDL.Gpu.GPULoadOp.CLEAR,
                store_op = SDL.Gpu.GPUStoreOp.STORE,
                mip_level = 0,
                cycle = true,
                layer_or_depth_plane = 0,
                cycle_resolve_texture = false,
            };

            // Don't forget to pass GPUColorTargetInfo ownership to the array here!
            var render_pass = SDL.Gpu.begin_gpu_render_pass (cmd_buf, { (owned) color_target }, null);
            SDL.Gpu.bind_gpu_graphics_pipeline (render_pass, use_wireframe_mode ? line_pipeline : fill_pipeline);

            if (use_small_viewport) {
                SDL.Gpu.set_gpu_viewport (render_pass, small_viewport);
            } else {
                SDL.Gpu.set_gpu_viewport (render_pass, full_viewport);
            }

            if (use_scissor_rect) {
                SDL.Gpu.set_gpu_scissor (render_pass, scissor_rect);
            }

            SDL.Gpu.draw_gpu_primitives (render_pass, 3, 1, 0, 0);
            SDL.Gpu.end_gpu_render_pass (render_pass);
        }

        if (!SDL.Gpu.submit_gpu_command_buffer (cmd_buf)) {
            SDL.Log.log ("Couldn't submit the comma buffer: %s", SDL.Error.get_error ());
        }
    }

    // CLEAN UP!

    // Release the pipelines
    SDL.Gpu.release_gpu_graphics_pipeline (gpu_device, fill_pipeline);
    SDL.Gpu.release_gpu_graphics_pipeline (gpu_device, line_pipeline);
    // Release window
    SDL.Gpu.release_window_from_gpu_device (gpu_device, window);
    // Destoy window, device and quit
    SDL.Video.destroy_window (window);
    SDL.Gpu.destroy_gpu_device (gpu_device);
    SDL.Init.quit ();
    return 0;
}

public static SDL.Gpu.GPUGraphicsPipeline create_graphics_pipeline (SDL.Gpu.GPUDevice device,
                                                                    SDL.Video.Window window,
                                                                    SDL.Gpu.GPUShader vertex_shader,
                                                                    SDL.Gpu.GPUShader fragment_shader,
                                                                    SDL.Gpu.GPUFillMode fill_mode =
                                                                    SDL.Gpu.GPUFillMode.FILL) {
    var create_info = SDL.Gpu.GPUGraphicsPipelineCreateInfo ();
    create_info.vertex_shader = vertex_shader;
    create_info.fragment_shader = fragment_shader;
    create_info.primitive_type = SDL.Gpu.GPUPrimitiveType.TRIANGLELIST;
    create_info.vertex_input_state.num_vertex_attributes = 0;
    create_info.vertex_input_state.num_vertex_buffers = 0;
    create_info.rasterizer_state.cull_mode = SDL.Gpu.GPUCullMode.NONE;
    create_info.rasterizer_state.fill_mode = fill_mode;
    create_info.multisample_state.enable_mask = false;
    create_info.multisample_state.sample_count = SDL.Gpu.GPUSampleCount.ONE;
    create_info.target_info.has_depth_stencil_target = false;

    var desc = SDL.Gpu.GPUColorTargetDescription ();
    desc.blend_state.alpha_blend_op = SDL.Gpu.GPUBlendOp.ADD;
    desc.blend_state.color_blend_op = SDL.Gpu.GPUBlendOp.ADD;
    desc.blend_state.color_write_mask = SDL.Gpu.GPUColorComponentFlags.A | SDL.Gpu.GPUColorComponentFlags.R
        | SDL.Gpu.GPUColorComponentFlags.G | SDL.Gpu.GPUColorComponentFlags.B;
    desc.blend_state.src_alpha_blendfactor = SDL.Gpu.GPUBlendFactor.ONE;
    desc.blend_state.src_color_blendfactor = SDL.Gpu.GPUBlendFactor.ONE;
    desc.blend_state.dst_alpha_blendfactor = SDL.Gpu.GPUBlendFactor.ZERO;
    desc.blend_state.dst_color_blendfactor = SDL.Gpu.GPUBlendFactor.ZERO;
    desc.blend_state.enable_blend = true;
    desc.blend_state.enable_color_write_mask = false;
    desc.format = SDL.Gpu.get_gpu_swapchain_texture_format (device, window);

// Don't forget to pass ownership to the array here!
    create_info.target_info.color_target_descriptions = { (owned) desc };

    return SDL.Gpu.create_gpu_graphics_pipeline (device, create_info);
}