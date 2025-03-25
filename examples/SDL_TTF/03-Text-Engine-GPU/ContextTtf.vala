using SDL;

class ContextTtf {
    private List<Ttf.Text> _texts;
    private HashTable<string, Ttf.Font> _fonts;
    private Ttf.TextEngine? _gpu_text_engine;

    public bool init (Gpu.GPUDevice gpu_device) {
        if (!Ttf.init ()) {
            SDL.Log.log ("Couldn't initialize SDL TTF: %s", SDL.Error.get_error ());
            return false;
        }

        _gpu_text_engine = Ttf.create_gpu_text_engine (gpu_device);
        if (_gpu_text_engine == null) {
            SDL.Log.log ("Couldn't create the GPU text engine: %s", SDL.Error.get_error ());
            return false;
        }

        _fonts = new HashTable<string, Ttf.Font> (str_hash, str_equal);
        _texts = new List<Ttf.Text> ();
        return true;
    }

    public unowned Ttf.Text? create_gpu_text (string font_name, string? font_fallback, float font_size, string content,
                                              Ttf.HorizontalAlignment alignment) {
        unowned Ttf.Font? font = load_font (font_name, font_size, alignment);
        if (font == null) {
            return null;
        }

        if (font_fallback != null) {
            unowned Ttf.Font? fallback = load_font (font_fallback, font_size, alignment);
            if (fallback == null) {
                return null;
            }

            var added_fallback = Ttf.add_fallback_font (font, fallback);
            if (!added_fallback) {
                SDL.Log.log ("Couldn't add fallback font: %s\n", SDL.Error.get_error ());
            }
        }

        var text_element = Ttf.create_text (_gpu_text_engine, font, content, 0);
        if (text_element == null) {
            SDL.Log.log ("Couldn't create text %s: %s", content, SDL.Error.get_error ());
            return null;
        }

        _texts.append ((owned) text_element);
        return _texts.last ().data;
    }

    private unowned Ttf.Font? load_font (string font_name, float font_size, Ttf.HorizontalAlignment alignment) {
        var font_key = "%s-%d".printf (font_name, (int) font_size);

        if (_fonts.contains (font_key)) {
            return _fonts.get (font_key);
        }

        var font_full_path = FileSystem.get_base_path () + font_name;
        var font = Ttf.open_font (font_full_path, font_size);
        if (font == null) {
            SDL.Log.log ("Couldn't open font %s: %s", font_name, SDL.Error.get_error ());
            return null;
        }
        Ttf.set_font_wrap_alignment (font, alignment);

        _fonts.set (font_key, (owned) font);
        return _fonts.get (font_key);
    }

    public void free () {
        _texts.foreach ((txt) => {
            Ttf.destroy_text (txt);
        });

        Ttf.destroy_gpu_text_engine (_gpu_text_engine);

        _fonts.foreach ((fnt_key) => {
            Ttf.close_font (_fonts[fnt_key]);
        });
        _fonts.remove_all ();

        Ttf.quit ();
    }
}