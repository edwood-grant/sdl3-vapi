using SDL;

const Pixels.FColor F_COLOR_YELLOW = { 1, 1, 0, 1 };

const bool USE_SDF = true;
const float FONT_POINT_SIZE = 36.0f;
const string FONT_NORMAL_NAME = "HomeVideo-Regular.ttf";
const string FONT_FALLBACK_NAME = "OpenMoji-black-glyf.ttf";
const string DEFAULT_TEXT = "\nSDL is cool!💻\n\nVala is also cool!✌️";

public const int MAX_VERTEX_COUNT = 4000;
public const int MAX_INDEX_COUNT = 6000;

public const Gpu.GPUShaderFormat SUPPORTED_FORMATS =
    Gpu.GPUShaderFormat.SPIRV
    | Gpu.GPUShaderFormat.DXIL
    | Gpu.GPUShaderFormat.MSL;

public struct Vec3 {
    public float x;
    public float y;
    public float z;
}

public struct Vertex {
    public Vec3 position;
    public Pixels.FColor color;
    public Rect.FPoint uv;
}

public class GeometryData {
    public Vertex[] vertices;
    public uint16[] indices;
    public int vertex_count;
    public int index_count;

    public GeometryData () {
        vertices.resize (MAX_VERTEX_COUNT * (int) sizeof (Vertex));
        indices.resize (MAX_INDEX_COUNT * (int) sizeof (int));
    }

    ~GeometryData () {
        vertices.resize (0);
        indices.resize (0);
    }

    public void set_data_from_atlas (Ttf.GPUAtlasDrawSequence atlas_sequence) {
        vertex_count = 0;
        index_count = 0;
        for (unowned var seq = atlas_sequence; seq != null; seq = seq.next) {
            for (int i = 0; i < seq.xy.length; i++) {
                vertices[vertex_count + i] = Vertex () {
                    position = Vec3 () {
                        x = seq.xy[i].x, y = seq.xy[i].y, z = 0.0f,
                    },
                    color = F_COLOR_YELLOW,
                    uv = Rect.FPoint () {
                        x = seq.uv[i].x, y = seq.uv[i].y,
                    }
                };
            }

            for (int i = 0; i < seq.indices.length; i++) {
                indices[index_count + i] = (uint16) seq.indices[i];
            }
            vertex_count += seq.xy.length;
            index_count += seq.indices.length;
        }
    }

    public void transfer_data (Gpu.GPUDevice gpu_device, Gpu.GPUTransferBuffer transfer_buffer) {
        var transfer_vertex_data = (Vertex*) Gpu.map_gpu_transfer_buffer (gpu_device,
                                                                          transfer_buffer,
                                                                          false);
        // Set vertex data
        for (int i = 0; i < vertex_count; i++) {
            var vert = vertices[i];
            transfer_vertex_data[i] = Vertex () {
                position = vert.position,
                color = vert.color,
                uv = vert.uv,
            };
        }

        // Tranfer indices after the max vertex count
        var transfer_index_data = (uint16*) &transfer_vertex_data[MAX_VERTEX_COUNT];
        for (int i = 0; i < index_count; i++) {
            transfer_index_data[i] = indices[i];
        }

        // Unmap the transfer_buffer
        Gpu.unmap_gpu_transfer_buffer (gpu_device, transfer_buffer);
    }

    public void upload_data (Gpu.GPUCommandBuffer cmd_buf, Gpu.GPUTransferBuffer transfer_buffer,
                             Gpu.GPUBuffer vertex_buffer, Gpu.GPUBuffer index_buffer) {
        // Begin the copy pass
        var copy_pass = Gpu.begin_gpu_copy_pass (cmd_buf);

        // Create the basic location and region buffer for vertex data
        var transfer_location = Gpu.GPUTransferBufferLocation () {
            transfer_buffer = transfer_buffer,
            offset = 0,
        };
        var buffer_region = Gpu.GPUBufferRegion ()
        {
            buffer = vertex_buffer,
            offset = 0,
            size = (uint32) sizeof (Vertex) * vertex_count,
        };

        // Upload the Vertex data
        Gpu.upload_to_gpu_buffer (copy_pass, transfer_location, buffer_region, false);

        // Change the buffer for the indices
        transfer_location.offset = (uint32) sizeof (Vertex) * MAX_VERTEX_COUNT;
        buffer_region.buffer = index_buffer;
        buffer_region.size = (uint32) sizeof (uint16) * index_count;

        // Upload the index data
        Gpu.upload_to_gpu_buffer (copy_pass, transfer_location, buffer_region, false);
        Gpu.end_gpu_copy_pass (copy_pass);
    }
}