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

    // Create VertexBuffer
    vertex_buffer =
        Gpu.create_gpu_buffer (
                               gpu_device,
                               Gpu.GPUBufferCreateInfo ()
    {
        usage = Gpu.GPUBufferUsageFlags.VERTEX,
        size = (uint32) sizeof (PositionColorVertex) * 3,
    });

    // To get data into the vertex buffer, we have to use a transfer buffer
    Gpu.GPUTransferBuffer? transfer_buffer =
        Gpu.create_gpu_transfer_buffer (
                                        gpu_device,
                                        Gpu.GPUTransferBufferCreateInfo ()
    {
        usage = Gpu.GPUTransferBufferUsage.UPLOAD,
        size = (uint32) sizeof (PositionColorVertex) * 3
    });

    PositionColorVertex* transfer_data =
        (PositionColorVertex*) Gpu.map_gpu_transfer_buffer (gpu_device,
                                                            transfer_buffer,
                                                            false);
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

    Gpu.upload_to_gpu_buffer (
                              copy_pass,
                              Gpu.GPUTransferBufferLocation ()
    {
        transfer_buffer = transfer_buffer,
        offset = 0,
    },
                              Gpu.GPUBufferRegion ()
    {
        buffer = vertex_buffer,
        offset = 0,
        size = (uint32) sizeof (PositionColorVertex) * 3,
    },
                              false);
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

            var render_pass = Gpu.begin_gpu_render_pass (cmd_buf, { (owned) color_target }, null);
            Gpu.bind_gpu_graphics_pipeline (render_pass, pipeline);
            Gpu.bind_gpu_vertex_buffers (render_pass, 0,
            {
                Gpu.GPUBufferBinding () {
                    buffer = vertex_buffer,
                    offset = 0,
                },
            });
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
    var create_info = Gpu.GPUGraphicsPipelineCreateInfo () {
        vertex_shader = vertex_shader,
        fragment_shader = fragment_shader,
        primitive_type = Gpu.GPUPrimitiveType.TRIANGLELIST,

        target_info = Gpu.GPUGraphicsPipelineTargetInfo () {
            color_target_descriptions = {
                Gpu.GPUColorTargetDescription () {
                    format = Gpu.get_gpu_swapchain_texture_format (device, window),
                }
            },
        },
        vertex_input_state = Gpu.GPUVertexInputState () {
            vertex_buffer_descriptions = {
                Gpu.GPUVertexBufferDescription () {
                    slot = 0,
                    input_rate = Gpu.GPUVertexInputRate.VERTEX,
                    instance_step_rate = 0,
                    pitch = (uint32) sizeof (PositionColorVertex),
                },
            },
            vertex_attributes = {
                Gpu.GPUVertexAttribute () {
                    buffer_slot = 0,
                    format = Gpu.GPUVertexElementFormat.FLOAT3,
                    location = 0,
                    offset = 0,
                },
                Gpu.GPUVertexAttribute () {
                    buffer_slot = 0,
                    format = Gpu.GPUVertexElementFormat.UBYTE4_NORM,
                    location = 1,
                    offset = (uint32) sizeof (float) * 3,
                },
            },
        },
    };

    return Gpu.create_gpu_graphics_pipeline (device, create_info);
}