using SDL;

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;

public class ContextGpu {
    public Video.Window? window = null;

    public Gpu.GPUDevice? gpu_device = null;
    public Gpu.GPUCommandBuffer? cmd_buf;

    public Gpu.GPUTransferBuffer? transfer_buffer;

    public Gpu.GPUBuffer? vertex_buffer;
    public Gpu.GPUBuffer? index_buffer;

    public Gpu.GPUGraphicsPipeline? pipeline = null;
    public Gpu.GPUSampler? sampler;

    public bool init () {
        Init.set_app_metadata ("SDL3 Vala TTF 03 - Text Engine GPU", "1.0",
                               "dev.vala.example.ttf-02-text-engine");

        if (!Init.init (Init.InitFlags.VIDEO | Init.InitFlags.EVENTS)) {
            SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
            return false;
        }

        window = Video.create_window ("SDL3 Vala TTF 03 - Text Engine GPU",
                                      WINDOW_WIDTH, WINDOW_HEIGHT, 0);
        if (window == null) {
            SDL.Log.log ("Couldn't create window: %s", SDL.Error.get_error ());
            return false;
        }

        gpu_device = Gpu.create_gpu_device (SUPPORTED_FORMATS, true, null);
        if (gpu_device == null) {
            SDL.Log.log ("Couldn't create GPU device: %s", SDL.Error.get_error ());
            return false;
        }

        if (!Gpu.claim_window_for_gpu_device (gpu_device, window)) {
            SDL.Log.log ("Couldn't cclaim window for GPU device: %s", SDL.Error.get_error ());
            return false;
        }

        if (!create_gpu_graphics_pipeline ()) {
            return false;
        }
        if (!create_buffers ()) {
            return false;
        }
        if (!create_samplers ()) {
            return false;
        }

        return true;
    }

    private bool create_gpu_graphics_pipeline () {
        var vertex_shader = load_shader (gpu_device, "GPUText.vert", 0, 1, 0, 0);
        var fragment_shader = load_shader (gpu_device, USE_SDF ? "GPUTextSDF.frag" : "GPUText.frag", 1, 0, 0, 0);

        var blend_st = Gpu.GPUColorTargetBlendState () {
            enable_blend = true,
            alpha_blend_op = Gpu.GPUBlendOp.ADD,
            color_blend_op = Gpu.GPUBlendOp.ADD,
            color_write_mask = 0xF,
            src_alpha_blendfactor = Gpu.GPUBlendFactor.SRC_ALPHA,
            dst_alpha_blendfactor = Gpu.GPUBlendFactor.DST_ALPHA,
            src_color_blendfactor = Gpu.GPUBlendFactor.SRC_ALPHA,
            dst_color_blendfactor = Gpu.GPUBlendFactor.ONE_MINUS_SRC_ALPHA,
        };

        var color_desc = Gpu.GPUColorTargetDescription () {
            format = Gpu.get_gpu_swapchain_texture_format (this.gpu_device, this.window),
            blend_state = blend_st,
        };

        var target_inf = Gpu.GPUGraphicsPipelineTargetInfo () {
            color_target_descriptions = { color_desc, },
            has_depth_stencil_target = false,
            depth_stencil_format = Gpu.GPUTextureFormat.INVALID, // Need to init this to avoid crashes
        };

        var verter_buffer_desc = Gpu.GPUVertexBufferDescription () {
            slot = 0,
            pitch = (uint32) sizeof (Vertex),
            input_rate = Gpu.GPUVertexInputRate.VERTEX,
            instance_step_rate = 0,
        };

        var veterx_attrib_0 = Gpu.GPUVertexAttribute () {
            location = 0,
            buffer_slot = 0,
            format = Gpu.GPUVertexElementFormat.FLOAT3,
            offset = 0,
        };

        var veterx_attrib_1 = Gpu.GPUVertexAttribute () {
            location = 1,
            buffer_slot = 0,
            format = Gpu.GPUVertexElementFormat.FLOAT4,
            offset = (uint32) sizeof (float) * 3,
        };

        var veterx_attrib_2 = Gpu.GPUVertexAttribute () {
            location = 2,
            buffer_slot = 0,
            format = Gpu.GPUVertexElementFormat.FLOAT2,
            offset = (uint32) sizeof (float) * 7,
        };

        var vertex_st = Gpu.GPUVertexInputState () {
            vertex_buffer_descriptions = { verter_buffer_desc },
            vertex_attributes = { veterx_attrib_0, veterx_attrib_1, veterx_attrib_2, },
        };

        var graphics_pipeline_create_info = Gpu.GPUGraphicsPipelineCreateInfo () {
            target_info = target_inf,
            vertex_input_state = vertex_st,
            primitive_type = Gpu.GPUPrimitiveType.TRIANGLELIST,
            vertex_shader = vertex_shader,
            fragment_shader = fragment_shader,
        };

        pipeline = Gpu.create_gpu_graphics_pipeline (gpu_device, graphics_pipeline_create_info);

        // Release shaders
        Gpu.release_gpu_shader (gpu_device, vertex_shader);
        Gpu.release_gpu_shader (gpu_device, fragment_shader);

        if (pipeline == null) {
            return false;
        }

        return true;
    }

    private bool create_buffers () {
        var vertex_buf_info = Gpu.GPUBufferCreateInfo () {
            usage = Gpu.GPUBufferUsageFlags.VERTEX,
            size = (uint32) sizeof (Vertex) * MAX_VERTEX_COUNT
        };
        vertex_buffer = Gpu.create_gpu_buffer (gpu_device, vertex_buf_info);

        var index_buf_info = Gpu.GPUBufferCreateInfo () {
            usage = Gpu.GPUBufferUsageFlags.INDEX,
            size = (uint32) sizeof (int) * MAX_INDEX_COUNT
        };
        index_buffer = Gpu.create_gpu_buffer (gpu_device, index_buf_info);

        var trans_buf_info = Gpu.GPUTransferBufferCreateInfo () {
            usage = Gpu.GPUTransferBufferUsage.UPLOAD,
            size = (uint32) sizeof (Vertex) * MAX_VERTEX_COUNT + (uint32) sizeof (int) * MAX_INDEX_COUNT,
        };
        transfer_buffer = Gpu.create_gpu_transfer_buffer (gpu_device, trans_buf_info);

        if (vertex_buffer == null || index_buffer == null || transfer_buffer == null) {
            return false;
        }

        return true;
    }

    private bool create_samplers () {
        var sampler_info = Gpu.GPUSamplerCreateInfo () {
            min_filter = Gpu.GPUFilter.LINEAR,
            mag_filter = Gpu.GPUFilter.LINEAR,
            mipmap_mode = Gpu.GPUSamplerMipmapMode.LINEAR,
            address_mode_u = Gpu.GPUSamplerAddressMode.CLAMP_TO_EDGE,
            address_mode_v = Gpu.GPUSamplerAddressMode.CLAMP_TO_EDGE,
            address_mode_w = Gpu.GPUSamplerAddressMode.CLAMP_TO_EDGE,
        };

        sampler = Gpu.create_gpu_sampler (gpu_device, sampler_info);
        if (sampler == null) {
            return false;
        }

        return true;
    }

    private Gpu.GPUShader? load_shader (Gpu.GPUDevice device,
                                        string shader_filename,
                                        uint32 sampler_count,
                                        uint32 uniform_buffer_count,
                                        uint32 storage_buffer_count,
                                        uint32 storage_texture_count) {

        // Auto-detect the shader stage from the file name for convenience
        Gpu.GPUShaderStage stage;
        if (shader_filename.contains (".vert")) {
            stage = Gpu.GPUShaderStage.VERTEX;
        } else if (shader_filename.contains (".frag")) {
            stage = Gpu.GPUShaderStage.FRAGMENT;
        } else {
            SDL.Log.log ("Invalid shader stage!");
            return null;
        }

        // Auto detect the available shader formats for the platform and choose the correct variant
        Gpu.GPUShaderFormat backend_formats = Gpu.get_gpu_shader_formats (device);
        Gpu.GPUShaderFormat format = Gpu.GPUShaderFormat.INVALID;
        string entry_point = "";
        string full_shader_path = FileSystem.get_base_path ();
        if ((backend_formats & Gpu.GPUShaderFormat.SPIRV) != 0) {
            format = Gpu.GPUShaderFormat.SPIRV;
            full_shader_path += "%s.spv".printf (shader_filename);
            entry_point = "main";
        } else if ((backend_formats & Gpu.GPUShaderFormat.MSL) != 0) {
            format = Gpu.GPUShaderFormat.MSL;
            full_shader_path += "%s.msl".printf (shader_filename);
            entry_point = "main0";
        } else if ((backend_formats & Gpu.GPUShaderFormat.DXIL) != 0) {
            format = Gpu.GPUShaderFormat.DXIL;
            full_shader_path += "%s.dxil".printf (shader_filename);
            entry_point = "main";
        } else {
            SDL.Log.log ("Unrecognized backend shader format!");
            return null;
        }

        size_t code_buf_size;
        var code_buf = IOStream.load_file (full_shader_path, out code_buf_size);

        // Fill the shader information
        var shader_info = Gpu.GPUShaderCreateInfo () {
            entrypoint = entry_point,
            code = code_buf,
            code_size = code_buf_size,
            format = format,
            stage = stage,
            num_samplers = sampler_count,
            num_uniform_buffers = uniform_buffer_count,
            num_storage_buffers = storage_buffer_count,
            num_storage_textures = storage_texture_count,
            props = 0,
        };

        Gpu.GPUShader? shader = Gpu.create_gpu_shader (device, shader_info);
        if (shader == null) {
            SDL.Log.log ("Failed to create shader!");
            StdInc.free (code_buf);
            return null;
        }

        StdInc.free (code_buf);
        return shader;
    }

    public void free () {
        Gpu.release_gpu_transfer_buffer (gpu_device, transfer_buffer);
        Gpu.release_gpu_sampler (gpu_device, sampler);
        Gpu.release_gpu_buffer (gpu_device, vertex_buffer);
        Gpu.release_gpu_buffer (gpu_device, index_buffer);

        Gpu.release_gpu_graphics_pipeline (gpu_device, pipeline);
        Gpu.release_window_from_gpu_device (gpu_device, window);
        Gpu.destroy_gpu_device (gpu_device);

        Video.destroy_window (window);

        Init.quit ();
    }
}