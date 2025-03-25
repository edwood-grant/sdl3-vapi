using SDL;
using Math3D;

// This sample uses a text engine to render text on the SDL GPU system

// The fonts are:
// "HomeVideo" by GGBotNrt
// https://ggbot.itch.io/home-video-font
// https://www.ggbot.net/
//
// OpenMoji font designed by OpenMoji – the open-source emoji and icon project.
// License: CC BY-SA 4.0
// https://openmoji.org/

float delta_time_f = 0;
uint64 delta_time = 0;
uint64 previous_time = 0;

float angle_y = 0;

StringBuilder? text_builder = null;
ContextGpu gpu_ctx;
ContextTtf ttf_ctx;
GeometryData geometry_data;

Matrix4x4 proj_view;

int main (string[] args) {
    proj_view = Matrix4x4.perspective (StdInc.PI_F / 3.0f, 800.0f / 600.0f, 0.1f, 200.0f);
    text_builder = new StringBuilder (DEFAULT_TEXT);

    // Start of program by initalizing all the contexts
    gpu_ctx = new ContextGpu ();
    ttf_ctx = new ContextTtf ();
    geometry_data = new GeometryData ();

    if (!gpu_ctx.init ()) {
        return -1;
    }

    if (!ttf_ctx.init (gpu_ctx.gpu_device)) {
        return -2;
    }

    // Check the method to understand what this does
    unowned Ttf.Text? ttf_text = ttf_ctx.create_gpu_text (FONT_NORMAL_NAME,
                                                          FONT_FALLBACK_NAME,
                                                          FONT_POINT_SIZE,
                                                          text_builder.str,
                                                          Ttf.HorizontalAlignment.CENTER);
    if (ttf_text == null) {
        return -3;
    }

    bool is_running = true;
    Events.Event ev;
    while (is_running) {
        while (Events.poll_event (out ev)) {
            if (ev.type == Events.EventType.QUIT) {
                is_running = false;
            }
        }

        // Update the text with random chars on top
        update_ttf_text (ttf_text);
        var altas_sequence = Ttf.get_gpu_text_draw_data (ttf_text);
        // Copy data from atlas and then map to a transfer buffer
        geometry_data.set_data_from_atlas (altas_sequence);
        geometry_data.transfer_data (gpu_ctx.gpu_device, gpu_ctx.transfer_buffer);
        // Create the command buffer
        gpu_ctx.cmd_buf = Gpu.acquire_gpu_command_buffer (gpu_ctx.gpu_device);
        // Upload the data to the GPU via a GPU copy pass
        geometry_data.upload_data (gpu_ctx.cmd_buf, gpu_ctx.transfer_buffer,
                                   gpu_ctx.vertex_buffer, gpu_ctx.index_buffer);

        // Delta time
        uint64 now = SDL.Timer.get_ticks ();
        delta_time = now - previous_time;
        delta_time_f = delta_time / 1000.0f;
        previous_time = now;

        // Calculate matrix text position and orientation (i.e. the model)
        // We leave the proj_view as it is
        angle_y += delta_time_f * 45;
        int tw, th = 0;
        Ttf.get_text_size (ttf_text, out tw, out th);

        var model = Math3D.Matrix4x4.identity ();
        model = Math3D.Matrix4x4.multiply (model, Math3D.Matrix4x4.translation (-tw / 2f, th / 2f, 0));
        model = Math3D.Matrix4x4.multiply (model, Math3D.Matrix4x4.scale (0.45f, 0.45f, 0.45f));
        model = Math3D.Matrix4x4.multiply (model, Math3D.Matrix4x4.rotationY (angle_y));
        model = Math3D.Matrix4x4.multiply (model, Math3D.Matrix4x4.translation (0, 0, -180f));

        Math3D.Matrix4x4[] matrices = {
            proj_view,
            model,
        };

        // Draw
        Gpu.GPUTexture? swapchain_texture;
        Gpu.wait_and_acquire_gpu_swapchain_texture (gpu_ctx.cmd_buf, gpu_ctx.window, out swapchain_texture, null, null);
        if (swapchain_texture != null) {
            var render_pass = Gpu.begin_gpu_render_pass (gpu_ctx.cmd_buf,
            {
                Gpu.GPUColorTargetInfo () {
                    texture = swapchain_texture,
                    clear_color = { 0.3f, 0.4f, 0.5f, 1.0f },
                    load_op = Gpu.GPULoadOp.CLEAR,
                    store_op = Gpu.GPUStoreOp.STORE,
                },
            }, null);

            // Bind the pipeline
            // Bind the matrices
            Gpu.bind_gpu_graphics_pipeline (render_pass, gpu_ctx.pipeline);
            Gpu.push_gpu_vertex_uniform_data (gpu_ctx.cmd_buf, 0, matrices, (uint32) sizeof (Math3D.Matrix4x4) * 2);

            // Then bind the buffers
            var buffer_binding = Gpu.GPUBufferBinding () {
                buffer = gpu_ctx.vertex_buffer,
                offset = 0
            };
            Gpu.bind_gpu_vertex_buffers (render_pass, 0, { buffer_binding });

            buffer_binding.buffer = gpu_ctx.index_buffer;
            Gpu.bind_gpu_index_buffer (render_pass, buffer_binding, Gpu.GPUIndexElementSize.SIZE_16BIT);

            // Iterate through the indices and , vertices and samplers (i.e. texture data)
            // And then draw their respective indices!
            int index_offset = 0;
            int vertex_offset = 0;
            for (unowned var seq = altas_sequence; seq != null; seq = seq.next) {
                var sampler_binding = Gpu.GPUTextureSamplerBinding () {
                    texture = seq.atlas_texture,
                    sampler = gpu_ctx.sampler,
                };

                Gpu.bind_gpu_fragment_samplers (render_pass, 0, { sampler_binding });
                Gpu.draw_gpu_indexed_primitives (render_pass, seq.indices.length,
                                                 1, index_offset, vertex_offset, 0);
                vertex_offset += seq.xy.length;
                index_offset += seq.indices.length;
            }
            Gpu.end_gpu_render_pass (render_pass);
        }

        Gpu.submit_gpu_command_buffer (gpu_ctx.cmd_buf);

        geometry_data.vertex_count = 0;
        geometry_data.index_count = 0;
    }

    ttf_ctx.free ();
    gpu_ctx.free ();
    return 0;
}

public static void update_ttf_text (Ttf.Text text) {
    // Make random characters
    text_builder.erase ();
    for (int i = 0; i < 5; i++) {
        text_builder.append_unichar ((unichar) (65 + StdInc.rand (26)));
    }
    text_builder.append (DEFAULT_TEXT);
    // Update the text via TTF normally
    Ttf.set_text_string (text, text_builder.str, 0);
}
