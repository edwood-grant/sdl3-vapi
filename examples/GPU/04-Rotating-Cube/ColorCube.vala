using SDL;
using Math3D;

class Cube {
    private const FVector3[] _VERTICES = {
        { -1, -1, -1 },
        { -1, +1, -1 },
        { +1, +1, -1 },
        { +1, -1, -1 },

        { -1, -1, +1 },
        { -1, +1, +1 },
        { +1, +1, +1 },
        { +1, -1, +1 },
    };

    private const uint16[] _INDICES = {
        2, 0, 1, 2, 3, 0,
        4, 6, 5, 4, 7, 6,
        0, 7, 4, 0, 3, 7,
        1, 0, 4, 1, 4, 5,
        1, 5, 2, 5, 6, 2,
        3, 6, 7, 3, 2, 6
    };

    private Pixels.Color[] _vertex_colors = {
        { 255, 255, 255, 255 },
        { 255, 255, 255, 255 },
        { 255, 255, 255, 255 },
        { 255, 255, 255, 255 },

        { 255, 255, 255, 255 },
        { 255, 255, 255, 255 },
        { 255, 255, 255, 255 },
        { 255, 255, 255, 255 },
    };

    private unowned Gpu.GPUDevice? _device;
    private Gpu.GPUBuffer? _vertex_buffer;
    private Gpu.GPUBuffer? _index_buffer;
    private Gpu.GPUTransferBuffer? _transfer_buffer;

    private FVector3 _position = { 0, 0, 0 };
    private FVector3 _rotation = { 0, 0, 0 };

    public Pixels.Color[] vertex_colors {
        get { return _vertex_colors; }
        set { _vertex_colors = value; }
    }

    public FVector3 position {
        get { return _position; }
        set { _position = value; }
    }

    public FVector3 rotation {
        get { return _rotation; }
        set { _rotation = value; }
    }

    public Cube (Gpu.GPUDevice device) {
        _device = device;
        create_gpu_buffers ();
    }

    public void transfer_and_upload () {
        transfer_data ();
        upload_to_gpu ();
    }

    public void draw (Gpu.GPUCommandBuffer cmd_buf, Gpu.GPURenderPass render_pass, Matrix4x4 proj_view) {
        var buffer_binding = Gpu.GPUBufferBinding () {
            buffer = _vertex_buffer,
            offset = 0,
        };
        Gpu.bind_gpu_vertex_buffers (render_pass, 0, { buffer_binding, });

        buffer_binding.buffer = _index_buffer;
        Gpu.bind_gpu_index_buffer (render_pass, buffer_binding, Gpu.GPUIndexElementSize.SIZE_16BIT);

        Matrix4x4[] matrices = {
            proj_view,
            Matrix4x4.identity (),
        };

        matrices[1] = get_model_transform ();
        Gpu.push_gpu_vertex_uniform_data (cmd_buf, 0, matrices, (uint32) sizeof (Matrix4x4) * 2);
        Gpu.draw_gpu_indexed_primitives (render_pass, _INDICES.length, 1, 0, 0, 0);
    }

    public void clean_up () {
        Gpu.release_gpu_buffer (_device, _vertex_buffer);
        Gpu.release_gpu_buffer (_device, _index_buffer);
        Gpu.release_gpu_transfer_buffer (_device, _transfer_buffer);
        _device = null;
    }

    private Matrix4x4 get_model_transform () {
        var model = Matrix4x4.identity ();
        model = Matrix4x4.multiply (model, Matrix4x4.rotationZ (_rotation.z));
        model = Matrix4x4.multiply (model, Matrix4x4.rotationY (_rotation.y));
        model = Matrix4x4.multiply (model, Matrix4x4.rotationX (_rotation.x));
        model = Matrix4x4.multiply (model, Matrix4x4.translation (_position.x, _position.y, _position.z));
        return model;
    }

    private void create_gpu_buffers () {
        // Create the VertexBuffer
        var vertex_buffer_create_info = Gpu.GPUBufferCreateInfo () {
            usage = Gpu.GPUBufferUsageFlags.VERTEX,
            size = (uint32) sizeof (PositionColorVertex) * _VERTICES.length,
        };
        _vertex_buffer = Gpu.create_gpu_buffer (_device, vertex_buffer_create_info);

        // Create the IndexBuffer
        var index_buffer_create_info = Gpu.GPUBufferCreateInfo () {
            usage = Gpu.GPUBufferUsageFlags.INDEX,
            size = (uint32) sizeof (uint16) * _INDICES.length,
        };
        _index_buffer = Gpu.create_gpu_buffer (_device, index_buffer_create_info);

        // To upload data into the gpu, we have to use a transfer buffer
        var transfer_buffer_create_info = Gpu.GPUTransferBufferCreateInfo () {
            usage = Gpu.GPUTransferBufferUsage.UPLOAD,
            size = ((uint32) sizeof (PositionColorVertex) * _VERTICES.length)
                + ((uint32) sizeof (uint16) * _INDICES.length)
        };
        _transfer_buffer = Gpu.create_gpu_transfer_buffer (_device, transfer_buffer_create_info);
    }

    private void transfer_data () {
        var vertex_transfer_data = (PositionColorVertex*) Gpu.map_gpu_transfer_buffer (_device,
                                                                                       _transfer_buffer,
                                                                                       false);

        // Transfer the Position Color Vertex Data
        for (int i = 0; i < _VERTICES.length; i++) {
            var pos = _VERTICES[i];
            var col = _vertex_colors[i];
            vertex_transfer_data[i] = { pos.x, pos.y, pos.z, col.r, col.g, col.b, col.a };
        }

        // Transfer the indices data
        var index_transfer_data = (uint16*) &vertex_transfer_data[_VERTICES.length];
        for (int i = 0; i < _INDICES.length; i++) {
            index_transfer_data[i] = _INDICES[i];
        }
        Gpu.unmap_gpu_transfer_buffer (_device, _transfer_buffer);
    }

    private void upload_to_gpu () {
        // Create an upload command buffer and start a copy pass
        Gpu.GPUCommandBuffer? upload_cmd_buf = Gpu.acquire_gpu_command_buffer (_device);
        Gpu.GPUCopyPass? copy_pass = Gpu.begin_gpu_copy_pass (upload_cmd_buf);

        // Upload the transfer data to the vertex buffer, and upload to the GPU.
        var buffer_location = Gpu.GPUTransferBufferLocation () {
            transfer_buffer = _transfer_buffer,
            offset = 0,
        };
        var buffer_region = Gpu.GPUBufferRegion () {
            buffer = _vertex_buffer,
            offset = 0,
            size = (uint32) sizeof (PositionColorVertex) * _VERTICES.length,
        };
        Gpu.upload_to_gpu_buffer (copy_pass, buffer_location, buffer_region, false);

        // Change the buffer for the indices, and upload to the GPU.
        var index_buffer_location = Gpu.GPUTransferBufferLocation () {
            transfer_buffer = _transfer_buffer,
            offset = (uint32) sizeof (PositionColorVertex) * _VERTICES.length,
        };
        var index_buffer_region = Gpu.GPUBufferRegion () {
            buffer = _index_buffer,
            offset = 0,
            size = (uint32) sizeof (uint16) * _INDICES.length,
        };
        Gpu.upload_to_gpu_buffer (copy_pass, index_buffer_location, index_buffer_region, false);

        // End the upload, finish the command buffer and release the transfer buffer
        // This is ok if you only plan to do this only once
        Gpu.end_gpu_copy_pass (copy_pass);
        Gpu.submit_gpu_command_buffer (upload_cmd_buf);
    }
}