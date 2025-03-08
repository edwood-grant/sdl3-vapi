using SDL;

public static SDL.Gpu.GPUShader ? load_shader (SDL.Gpu.GPUDevice device,
                                               string shader_filename,
                                               uint32 sampler_count,
                                               uint32 uniform_buffer_count,
                                               uint32 storage_buffer_count,
                                               uint32 storage_texture_count) {

    // Auto-detect the shader stage from the file name for convenience
    SDL.Gpu.GPUShaderStage stage;
    if (shader_filename.contains (".vert")) {
        stage = SDL.Gpu.GPUShaderStage.VERTEX;
    } else if (shader_filename.contains (".frag")) {
        stage = SDL.Gpu.GPUShaderStage.FRAGMENT;
    } else {
        SDL.Log.log ("Invalid shader stage!");
        return null;
    }

    // Auto detect the available shader formats for the platform and choose the correct variant
    SDL.Gpu.GPUShaderFormat backend_formats = SDL.Gpu.get_gpu_shader_formats (device);
    SDL.Gpu.GPUShaderFormat format = SDL.Gpu.GPUShaderFormat.INVALID;
    string entry_point = "";
    string full_shader_path = SDL.FileSystem.get_base_path ();
    if ((backend_formats & SDL.Gpu.GPUShaderFormat.SPIRV) != 0) {
        format = SDL.Gpu.GPUShaderFormat.SPIRV;
        full_shader_path += "%s.spv".printf (shader_filename);
        entry_point = "main";
    } else if ((backend_formats & SDL.Gpu.GPUShaderFormat.MSL) != 0) {
        format = SDL.Gpu.GPUShaderFormat.MSL;
        full_shader_path += "%s.msl".printf (shader_filename);
        entry_point = "main0";
    } else if ((backend_formats & SDL.Gpu.GPUShaderFormat.DXIL) != 0) {
        format = SDL.Gpu.GPUShaderFormat.DXIL;
        full_shader_path += "%s.dxil".printf (shader_filename);
        entry_point = "main";
    } else {
        SDL.Log.log ("Unrecognized backend shader format!");
        return null;
    }

    size_t code_buf_size;
    var code_buf = SDL.IOStream.load_file (full_shader_path, out code_buf_size);

    // This is also a valid  method with GLib.FileStream
    /* var code_stream = GLib.FileStream.open (full_shader_path, "r");
       if (code_stream == null) {
       SDL.Log.log ("Failed to load shader from disk! %s", full_shader_path);
       return null;
       }

       // get file size:
       code_stream.seek (0, FileSeek.END);
       size_t code_buf_size = code_stream.tell ();
       code_stream.rewind ();
       // load content:
       uint8[] code_buf = new uint8[code_buf_size];
       code_stream.read (code_buf);
     */

    // Fill the shader information
    var shader_info = SDL.Gpu.GPUShaderCreateInfo () {
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

    SDL.Gpu.GPUShader? shader = SDL.Gpu.create_gpu_shader (device, shader_info);
    if (shader == null) {
        SDL.Log.log ("Failed to create shader!");
        SDL.StdInc.free (code_buf);
        return null;
    }

    SDL.StdInc.free (code_buf);
    return shader;
}