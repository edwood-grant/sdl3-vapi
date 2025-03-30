using SDL;
using Math3D;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;
const float FOV_DEG = 60;
const float NEAR = 0.1f;
const float FAR = 200f;

const float CUBE_ROTATION_SPEED_DEG = 45f;
uint64 previous_time = 0;

Video.Window? window = null;
Gpu.GPUDevice? gpu_device = null;
Gpu.GPUGraphicsPipeline? pipeline = null;

// A default projection view matrix to support viweing objects in space
Matrix4x4 proj_view;

public int main (string[] args) {
    proj_view = Matrix4x4.perspective (FOV_DEG * StdInc.PI_F / 180.0f,
                                       (float) WINDOW_WIDTH / (float) WINDOW_HEIGHT,
                                       NEAR, FAR);

    Init.set_app_metadata ("SDL3 Vala GPU 04 - Rotating Cube", "1.0",
                           "dev.vala.example.gpu-04-rotating-cube");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return -1;
    }

    success = common_init ("SDL3 Vala GPU 04 - Rotating Cube", WINDOW_WIDTH, WINDOW_HEIGHT, out gpu_device, out window);
    if (!success) {
        return -1;
    }

    // Create the shaders
    Gpu.GPUShader ? vertex_shader = load_shader (gpu_device, "PositionColorModelView.vert", 0, 1, 0, 0);
    if (vertex_shader == null) {
        SDL.Log.log ("Failed to create vertex shader!");
        return -1;
    }
    Gpu.GPUShader ? fragment_shader = load_shader (gpu_device, "SolidColor.frag", 0, 0, 0, 0);
    if (fragment_shader == null) {
        SDL.Log.log ("Failed to create fragment shader!");
        return -1;
    }

    pipeline = create_graphics_pipeline (gpu_device, window, vertex_shader, fragment_shader);
    if (pipeline == null) {
        SDL.Log.log ("Failed to create pipeline!");
        return -1;
    }

    Gpu.release_gpu_shader (gpu_device, vertex_shader);
    Gpu.release_gpu_shader (gpu_device, fragment_shader);

    var sample_cube = new Cube (gpu_device);
    sample_cube.vertex_colors = {
        { 255, 0, 0, 255 },
        { 0, 255, 0, 255 },
        { 0, 0, 255, 255 },
        { 255, 255, 255, 255 },

        { 255, 255, 0, 255 },
        { 0, 255, 255, 255 },
        { 255, 0, 255, 255 },
        { 64, 64, 64, 255 },
    };
    sample_cube.position = { 0, -0.1f, -5f };
    sample_cube.rotation = {
        -180f + StdInc.randf () * 360f,
        -180f + StdInc.randf () * 360f,
        -180f + StdInc.randf () * 360f
    };

    sample_cube.transfer_and_upload ();

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

        // Calculate delta/elapsed time
        var now = SDL.Timer.get_ticks ();
        var elapsed = now - previous_time;
        previous_time = now;

        // Rotate cube
        sample_cube.rotation = {
            sample_cube.rotation.x += elapsed / 1000.0f * CUBE_ROTATION_SPEED_DEG,
            sample_cube.rotation.y += elapsed / 1000.0f * CUBE_ROTATION_SPEED_DEG,
            sample_cube.rotation.z += elapsed / 1000.0f * CUBE_ROTATION_SPEED_DEG,
        };

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
                clear_color = { 0.1f, 0.2f, 0.3f, 1.0f },
                load_op = Gpu.GPULoadOp.CLEAR,
                store_op = Gpu.GPUStoreOp.STORE,
            };

            var render_pass = Gpu.begin_gpu_render_pass (cmd_buf, { color_target }, null);
            Gpu.bind_gpu_graphics_pipeline (render_pass, pipeline);


            sample_cube.transfer_and_upload ();
            sample_cube.draw (cmd_buf, render_pass, proj_view);
            Gpu.end_gpu_render_pass (render_pass);
        }
        Gpu.submit_gpu_command_buffer (cmd_buf);
    }

    sample_cube.clean_up ();
    clean_up ();
    return 0;
}

public Gpu.GPUGraphicsPipeline ? create_graphics_pipeline (Gpu.GPUDevice device,
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

    // Describe the vertex buffer, hat must match the actual vertex shader you will use
    // That means one position float and one color float
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
    // * First, position: three floats
    // * Second, color: four bytes
    var vertex_input_st = Gpu.GPUVertexInputState () {
        vertex_buffer_descriptions = { vertex_buffer_desc, },
        vertex_attributes = { vertex_attrib_0, vertex_attrib_1 },
    };

    // The rasterize state will determine face culling and fill type
    var rasterizer_st = Gpu.GPURasterizerState () {
        cull_mode = Gpu.GPUCullMode.BACK, // We only care for back culling right now
    };

    // The pipeline will receive
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
        rasterizer_state = rasterizer_st,
    };

    // Finally with all the important info, create the pipeline
    return Gpu.create_gpu_graphics_pipeline (device, create_info);
}

public void clean_up () {
    // Release the pipeline
    Gpu.release_gpu_graphics_pipeline (gpu_device, pipeline);

    // Gpu.release_gpu_buffer (gpu_device, vertex_buffer);
    // Gpu.release_gpu_buffer (gpu_device, index_buffer);

    // Release window
    Gpu.release_window_from_gpu_device (gpu_device, window);

    // Destoy window, device and quit
    Video.destroy_window (window);
    Gpu.destroy_gpu_device (gpu_device);

    // Quit SDL
    Init.quit ();
}