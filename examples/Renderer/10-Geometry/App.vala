using SDL;

const int WINDOW_WIDTH = 640;
const int WINDOW_HEIGHT = 480;

SDL.Video.Window? window = null;
SDL.Render.Renderer? renderer = null;

SDL.Render.Texture? texture = null;
int texture_width = 0;
int texture_height = 0;
SDL.Render.Vertex vertices_four[4];
SDL.Render.Vertex vertices_three[3];

public int main (string[] args) {
    SDL.Init.set_app_metadata ("SDL3 Vala Renderer Example 10 - Geometry", "1.0",
                               "dev.vala.example.renderer-10-geometry");

    bool success = Init.init (Init.InitFlags.VIDEO);
    if (!success) {
        SDL.Log.log ("Couldn't initialize SDL: %s", SDL.Error.get_error ());
        return 1;
    }
    success = SDL.Render.create_window_and_renderer ("SDL3 Vala Renderer Example 10 - Geometry",
                                                     WINDOW_WIDTH, WINDOW_HEIGHT, 0,
                                                     out window, out renderer);
    if (!success) {
        SDL.Log.log ("Couldn't create window/renderer: %s", SDL.Error.get_error ());
        return 1;
    }

    /* Textures are pixel data that we upload to the video hardware for fast drawing. Lots of 2D
       engines refer to these as "sprites." We'll do a static texture (upload once, draw many
       times) with data from a bitmap file. */

    /* SDL_Surface is pixel data the CPU can access. SDL_Texture is pixel data the GPU can access.
       Load a .bmp into a surface, move it to a texture from there. */
    var bmp_path = SDL.FileSystem.get_base_path () + "sample.bmp";
    var surface = SDL.Surface.load_bmp (bmp_path);
    if (surface == null) {
        SDL.Log.log ("Couldn't load bitmap: %s", SDL.Error.get_error ());
        return 1;
    }

    texture_width = surface.w;
    texture_height = surface.h;

    texture = SDL.Render.create_texture_from_surface (renderer, surface);
    if (texture == null) {
        SDL.Log.log ("Couldn't create static texture: %s", SDL.Error.get_error ());
        return 1;
    }

    // Done with this, the texture has a copy of the pixels now.
    SDL.Surface.destroy_surface (surface);

    bool is_running = true;
    SDL.Events.Event ev;
    while (is_running) {
        while (SDL.Events.poll_event (out ev)) {
            if (ev.type == SDL.Events.EventType.QUIT) {
                is_running = false;
            }
        }

        uint64 now = SDL.Timer.get_ticks ();

        // We'll have the triangle grow and shrink over a few seconds. */
        float direction = ((now % 2000) >= 1000) ? 1.0f : -1.0f;
        float scale = ((float) (((int) (now % 1000)) - 500) / 500.0f) * direction;
        float size = 200.0f + (200.0f * scale);

        // Black, full alpha
        SDL.Render.set_render_draw_color (renderer, 0, 0, 0, SDL.Pixels.ALPHA_OPAQUE);
        SDL.Render.render_clear (renderer);
        {
            clear_vertex_data (vertices_three);
            clear_vertex_data (vertices_four);

            // Draw a single triangle with a different color at each vertex. Center this one and
            // make it grow and shrink. You always draw triangles with this, but you can string
            // triangles together to form polygons.
            vertices_three[0].position.x = ((float) WINDOW_WIDTH) / 2.0f;
            vertices_three[0].position.y = (((float) WINDOW_HEIGHT) - size) / 2.0f;
            vertices_three[0].color.r = 1.0f;
            vertices_three[0].color.a = 1.0f;
            vertices_three[1].position.x = (((float) WINDOW_WIDTH) + size) / 2.0f;
            vertices_three[1].position.y = (((float) WINDOW_HEIGHT) + size) / 2.0f;
            vertices_three[1].color.g = 1.0f;
            vertices_three[1].color.a = 1.0f;
            vertices_three[2].position.x = (((float) WINDOW_WIDTH) - size) / 2.0f;
            vertices_three[2].position.y = (((float) WINDOW_HEIGHT) + size) / 2.0f;
            vertices_three[2].color.b = 1.0f;
            vertices_three[2].color.a = 1.0f;
            SDL.Render.render_geometry (renderer, null, vertices_three, null);


            // you can also map a texture to the geometry! Texture coordinates go from 0.0f to 1.0f.
            // That will be the location in the texture bound to this vertex.
            vertices_three[0].position.x = 10.0f;
            vertices_three[0].position.y = 10.0f;
            vertices_three[0].color.r = 1.0f;
            vertices_three[0].color.g = 1.0f;
            vertices_three[0].color.b = 1.0f;
            vertices_three[0].color.a = 1.0f;
            vertices_three[0].tex_coord.x = 0.0f;
            vertices_three[0].tex_coord.y = 0.0f;

            vertices_three[1].position.x = 150.0f;
            vertices_three[1].position.y = 10.0f;
            vertices_three[1].color.r = 1.0f;
            vertices_three[1].color.g = 1.0f;
            vertices_three[1].color.b = 1.0f;
            vertices_three[1].color.a = 1.0f;
            vertices_three[1].tex_coord.x = 1.0f;
            vertices_three[1].tex_coord.y = 0.0f;
            vertices_three[2].position.x = 10.0f;
            vertices_three[2].position.y = 150.0f;
            vertices_three[2].color.r = 1.0f;
            vertices_three[2].color.g = 1.0f;
            vertices_three[2].color.b = 1.0f;
            vertices_three[2].color.a = 1.0f;
            vertices_three[2].tex_coord.x = 0.0f;
            vertices_three[2].tex_coord.y = 1.0f;
            SDL.Render.render_geometry (renderer, texture, vertices_three, null);

            // Did that only draw half of the texture? You can do multiple triangles sharing some
            // vertices, using indices, to get the whole thing on the screen:
            // Let's just move this over so it doesn't overlap...
            for (int i = 0; i < vertices_three.length; i++) {
                vertices_three[i].position.x += 450;
                vertices_four[i] = vertices_three[i];
            }

            // We need one more vertex, since the two triangles can share two of them.
            vertices_four[3].position.x = 600.0f;
            vertices_four[3].position.y = 150.0f;
            vertices_four[3].color.r = 1.0f;
            vertices_four[3].color.g = 1.0f;
            vertices_four[3].color.b = 1.0f;
            vertices_four[3].color.a = 1.0f;
            vertices_four[3].tex_coord.x = 1.0f;
            vertices_four[3].tex_coord.y = 1.0f;

            // And an index to tell it to reuse some of the vertices between triangles...
            // Four 4 vertices, but 6 actual places they used. Indices need less bandwidth to
            // transfer and can reorder vertices easily!
            const int INDICES[] = { 0, 1, 2, 1, 2, 3 };
            SDL.Render.render_geometry (renderer, texture, vertices_four, INDICES);
        }
        SDL.Render.render_present (renderer);
    }

    SDL.Render.destroy_texture (texture);
    SDL.Render.destroy_renderer (renderer);
    SDL.Video.destroy_window (window);
    SDL.Init.quit ();

    return 0;
}

void clear_vertex_data (SDL.Render.Vertex[] vertices) {
    for (int i = 0; i < vertices.length; i++) {
        vertices[i].position.x = 0;
        vertices[i].position.y = 0;
        vertices[i].color.r = 0;
        vertices[i].color.g = 0;
        vertices[i].color.b = 0;
        vertices[i].color.a = 0;
        vertices[i].tex_coord.x = 0;
        vertices[i].tex_coord.y = 0;
    }
}