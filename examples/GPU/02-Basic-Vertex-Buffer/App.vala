using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

Video.Window? window = null;
Gpu.GPUDevice? gpu_device = null;
Gpu.GPUGraphicsPipeline? pipeline = null;
Gpu.GPUBuffer? vertex_buffer = null;

public struct PositionColorVertex {
    // Position
    public float x;
    public float y;
    public float z;

    // Color
    public uint8 r;
    public uint8 g;
    public uint8 b;
    public uint8 a;
}

public int main (string[] args) {
    Init.set_app_metadata ("SDL3 Vala GPU 02 - Basic Vertex Buffer", "1.0",
                           "dev.vala.example.gpu-02-basic-vertex.buffer");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return -1;
    }

    success = common_init ("SDL3 Vala GPU 02 - Basic Vertex Buffer",
                           WINDOW_WIDTH, WINDOW_HEIGHT,
                           out gpu_device, out window);
    if (!success) {
        return -1;
    }

    // Create the shaders
    Gpu.GPUShader? vertex_shader = load_shader (gpu_device, "PositionColor.vert", 0, 0, 0, 0);
    if (vertex_shader == null) {
        SDL.Log.log ("Failed to create vertex shader!");
        return -1;
    }

    Gpu.GPUShader? fragment_shader = load_shader (gpu_device, "SolidColor.frag", 0, 0, 0, 0);
    if (fragment_shader == null) {
        SDL.Log.log ("Failed to create fragment shader!");
        return -1;
    }

    pipeline = create_graphics_pipeline (gpu_device, window, vertex_shader, fragment_shader);

    Gpu.release_gpu_shader (gpu_device, vertex_shader);
    Gpu.release_gpu_shader (gpu_device, fragment_shader);

    // Create the VertexBuffer
    var vertex_buffer_create_info = Gpu.GPUBufferCreateInfo () {
        usage = Gpu.GPUBufferUsageFlags.VERTEX,
        size = (uint32) sizeof (PositionColorVertex) * 3,
    };
    vertex_buffer = Gpu.create_gpu_buffer (gpu_device, vertex_buffer_create_info);

    // To get data into the vertex buffer, we have to use a transfer buffer
    var transfer_buffer_create_info = Gpu.GPUTransferBufferCreateInfo () {
        usage = Gpu.GPUTransferBufferUsage.UPLOAD,
        size = (uint32) sizeof (PositionColorVertex) * 3
    };
    Gpu.GPUTransferBuffer? transfer_buffer = Gpu.create_gpu_transfer_buffer (gpu_device, transfer_buffer_create_info);

    var transfer_data = (PositionColorVertex*) Gpu.map_gpu_transfer_buffer (gpu_device, transfer_buffer, false);
    transfer_data[0] = PositionColorVertex () {
        x = -1, y = -1, z = 0, r = 255, g = 0, b = 0, a = 255
    };
    transfer_data[1] = PositionColorVertex () {
        x = 1, y = -1, z = 0, r = 0, g = 255, b = 0, a = 255
    };
    transfer_data[2] = PositionColorVertex () {
        x = 0, y = 1, z = 0, r = 0, g = 0, b = 255, a = 255
    };
    Gpu.unmap_gpu_transfer_buffer (gpu_device, transfer_buffer);

    // Upload the transfer data to the vertex buffer
    Gpu.GPUCommandBuffer ? upload_cmd_buf = Gpu.acquire_gpu_command_buffer (gpu_device);
    Gpu.GPUCopyPass ? copy_pass = Gpu.begin_gpu_copy_pass (upload_cmd_buf);

    var buffer_location = Gpu.GPUTransferBufferLocation () {
        transfer_buffer = transfer_buffer,
        offset = 0,
    };
    var buffer_region = Gpu.GPUBufferRegion () {
        buffer = vertex_buffer,
        offset = 0,
        size = (uint32) sizeof (PositionColorVertex) * 3,
    };
    Gpu.upload_to_gpu_buffer (copy_pass, buffer_location, buffer_region, false);

    Gpu.end_gpu_copy_pass (copy_pass);
    Gpu.submit_gpu_command_buffer (upload_cmd_buf);
    Gpu.release_gpu_transfer_buffer (gpu_device, transfer_buffer);

    // LOOP
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
                default :
                break;
            }
        }

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
                    0.0f, 0.0f, 0.0f, 1.0f
                },
                load_op = Gpu.GPULoadOp.CLEAR,
                store_op = Gpu.GPUStoreOp.STORE,
            };

            var render_pass = Gpu.begin_gpu_render_pass (cmd_buf, { color_target }, null);
            Gpu.bind_gpu_graphics_pipeline (render_pass, pipeline);
            var vertex_buffer_binding = Gpu.GPUBufferBinding () {
                buffer = vertex_buffer,
                offset = 0,
            };
            Gpu.bind_gpu_vertex_buffers (render_pass, 0, { vertex_buffer_binding, });
            Gpu.draw_gpu_primitives (render_pass, 3, 1, 0, 0);
            Gpu.end_gpu_render_pass (render_pass);
        }

        if (!Gpu.submit_gpu_command_buffer (cmd_buf)) {
            SDL.Log.log ("Couldn't submit the comma buffer: %s", SDL.Error.get_error ());
        }
    }

    // CLEAN UP!

    // Release the pipeline
    Gpu.release_gpu_graphics_pipeline (gpu_device, pipeline);
    Gpu.release_gpu_buffer (gpu_device, vertex_buffer);
    // Release window
    Gpu.release_window_from_gpu_device (gpu_device, window);
    // Destoy window, device and quit
    Video.destroy_window (window);
    Gpu.destroy_gpu_device (gpu_device);
    Init.quit ();
    return 0;
}

public Gpu.GPUGraphicsPipeline create_graphics_pipeline (Gpu.GPUDevice device,
                                                         Video.Window window,
                                                         Gpu.GPUShader vertex_shader,
                                                         Gpu.GPUShader fragment_shader,
                                                         Gpu.GPUFillMode fill_mode =
                                                         Gpu.GPUFillMode.FILL) {
    var color_target_desc_0 = Gpu.GPUColorTargetDescription () {
        format = Gpu.get_gpu_swapchain_texture_format (device, window),
    };

    // The pipeline info usually contains data where to draw stuff
    // In this case, we are directly drawing onto the swapchian, i.e. the main render screen
    // So we only need one color target descriptor
    var pipeline_target_inf = Gpu.GPUGraphicsPipelineTargetInfo () {
        color_target_descriptions = { color_target_desc_0, },
    };

    var vertex_buffer_desc = Gpu.GPUVertexBufferDescription () {
        slot = 0,
        input_rate = Gpu.GPUVertexInputRate.VERTEX,
        instance_step_rate = 0,
        pitch = (uint32) sizeof (PositionColorVertex),
    };

    var vertex_attrib_0 = Gpu.GPUVertexAttribute () {
        buffer_slot = 0,
        format = Gpu.GPUVertexElementFormat.FLOAT3,
        location = 0,
        offset = 0,
    };

    var vertex_attrib_1 = Gpu.GPUVertexAttribute () {
        buffer_slot = 0,
        format = Gpu.GPUVertexElementFormat.UBYTE4_NORM,
        location = 1,
        offset = (uint32) sizeof (float) * 3,
    };

    // This must mimic the vertex shader input params and maps it to a struct, that is:
    // * A description of the input, that is a PositionColorVertex struct that will contain the data
    // * A series of attributes:
    // * First, position: (position, three floats)
    // * Second, color, four bytes)
    var vertex_input_st = Gpu.GPUVertexInputState () {
        vertex_buffer_descriptions = { vertex_buffer_desc, },
        vertex_attributes = { vertex_attrib_0, vertex_attrib_1 },
    };

    // The pipelin will receive
    // * The vertex and fragment shaders
    // * What kind of primite you are drawing
    // * The pipeline target information
    // * The vertex input state (i.e. how the vertex shader data is aligned)
    var create_info = Gpu.GPUGraphicsPipelineCreateInfo () {
        vertex_shader = vertex_shader,
        fragment_shader = fragment_shader,
        primitive_type = Gpu.GPUPrimitiveType.TRIANGLELIST,
        target_info = pipeline_target_inf,
        vertex_input_state = vertex_input_st,
    };

    // Finally with all the important info, create the pipeline
    return Gpu.create_gpu_graphics_pipeline (device, create_info);
}