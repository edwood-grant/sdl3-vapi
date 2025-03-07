/*
 * Copyright (c) 2025 Italo Felipe Capasso Ballesteros <italo@gp-mail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), regardless
 * of their gender, ethnicity or affiliation, to deal in the Software without
 * restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * 1. You, and any organization that may use the Software, unequivocally supports
 *    the principles and ethos of Inclusion, Diversity, and Equity (IDE or DEI).
 *
 * 2. You, and any organization that may use the Software, supports the Contributor
 *    Covenant (https://www.contributor-covenant.org) or any Code of Conduct that
 *    is compatible with it and supports the same spirit.
 *
 * 3. The above copyright notice and this permission notice shall be included in
 *    its entirety in all copies or substantial portions of the Software, credits
 *    screen or "about" page included.
 *
 * 4. This notice may not be removed or altered from any source distribution.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Author:
 *   Italo Felipe Capasso Ballesteros <italo@gp-mail.com>
 */

/*
 * The API order goes by the category classification expressed in the docs
 * https://wiki.libsdl.org/SDL3_ttf/CategoryAPI
 */

/**
 * The SDL3 TTF Library Vala bindings
 *
 * This library is a wrapper around the FreeType and Harfbuzz libraries,
 * allowing you to use TrueType fonts to render text in SDL applications.
 *
 *   * [[https://wiki.libsdl.org/SDL3_ttf/]]
 */
[CCode (cheader_filename = "SDL3_ttf/SDL_ttf.h")]
namespace SDL.Ttf {
    [CCode (cname = "SDL_TTF_MAJOR_VERSION")]
    public const int MAJOR_VERSION;

    [CCode (cname = "SDL_TTF_VERSION")]
    public const int VERSION;

    [CCode (cname = "SDL_TTF_VERSION_ATLEAST")]
    public static bool version_at_least (int major, int minor, int micro);

    [CCode (cname = "TTF_AddFallbackFont")]
    public static bool add_fallback_font (Font font, Font fallback);

    [CCode (cname = "TTF_AppendTextString")]
    public static bool append_text_string (Text text, string text_to_append);

    [CCode (cname = "TTF_ClearFallbackFonts")]
    public static void clear_fallback_fonts (Font font);

    [CCode (cname = "TTF_CloseFont")]
    public static void close_font (Font font);

    [CCode (cname = "TTF_CopyFont")]
    public static Font ? copy_font (Font existing_font);

    [CCode (cname = "TTF_COPY_OPERATION_IMAGE")]
    public const int32 COPY_OPERATION_IMAGE;

    [CCode (cname = "TTF_CreateGPUTextEngine")]
    public static TextEngine ? create_gpu_text_engine (SDL.Gpu.GPUDevice device);

    [CCode (cname = "TTF_CreateGPUTextEngineWithProperties")]
    public static TextEngine ? create_gpu_text_engine_with_properties (SDL.Properties.PropertiesID props);

    [CCode (cname = "TTF_CreateRendererTextEngine")]
    public static TextEngine ? create_renderer_text_engine (SDL.Render.Renderer renderer);

    [CCode (cname = "TTF_CreateRendererTextEngineWithProperties")]
    public static TextEngine ? create_renderer_text_engine_with_peoperties (SDL.Properties.PropertiesID props);

    [CCode (cname = "TTF_CreateSurfaceTextEngine")]
    public static TextEngine ? create_surface_text_engine ();

    [CCode (cname = "TTF_CreateText")]
    public static Text ? create_text (TextEngine engine, Font font, string text);

    [CCode (cname = "TTF_DeleteTextString")]
    public static bool delete_text_string (Text text, int offset, int length);

    [CCode (cname = "TTF_DestroyGPUTextEngine")]
    public static void destroy_gpu_text_engine (TextEngine engine);

    [CCode (cname = "TTF_DestroyRendererTextEngine")]
    public static void destroy_renderer_text_engine (TextEngine engine);

    [CCode (cname = "TTF_DestroySurfaceTextEngine")]
    public static void destroy_surface_text_engine (TextEngine engine);

    [CCode (cname = "TTF_DestroyText")]
    public static void destroy_text (Text text);

    [CCode (cname = "TTF_Direction", cprefix = "TTF_DIRECTION_", has_type_id = false)]
    public enum Direction {
        INVALID,
        LTR,
        RTL,
        TTB,
        BTT,
    } // Direction

    [CCode (cname = "TTF_DrawRendererText")]
    public static bool draw_renderer_text (Text text, float x, float y);

    [CCode (cname = "TTF_DrawSurfaceText")]
    public static bool draw_surface_text (Text text, int x, int y, SDL.Surface.Surface surface);

    [Compact, CCode (cname = "TTF_Font", free_function = "", has_type_id = false)]
    public class Font {}

    [CCode (cname = "TTF_FontHasGlyph")]
    public static bool font_has_glyph (Font font, uint32 ch);

    [CCode (cname = "TTF_FontIsFixedWidth")]
    public static bool font_is_fixed_width (Font font);

    [CCode (cname = "TTF_FontIsScalable")]
    public static bool font_is_scalable (Font font);

    [Flags, CCode (cname = "Uint32", cprefix = "TTF_STYLE_", has_type_id = false)]
    public enum FontStyleFlags {
        NORMAL,
        BOLD,
        ITALIC,
        UNDERLINE,
        STRIKETHROUGH,
    } // FontStyleFlags

    [CCode (cname = "TTF_GetFontAscent")]
    public static int get_font_ascent (Font font);

    [CCode (cname = "TTF_GetFontDescent")]
    public static int get_font_descent (Font font);

    [CCode (cname = "TTF_GetFontDirection")]
    public static Direction get_font_direction (Font font);

    [CCode (cname = "TTF_GetFontDPI")]
    public static bool get_font_dpi (Font font, out int hdpi, out int vdpi);

    [CCode (cname = "TTF_GetFontFamilyName")]
    public static string get_font_family_name (Font font);

    [CCode (cname = "TTF_GetFontGeneration")]
    public static uint32 get_font_generation (Font font);

    [CCode (cname = "TTF_GetFontHeight")]
    public static int get_font_height (Font font);

    [CCode (cname = "TTF_GetFontHinting")]
    public static HintingFlags get_font_hinting (Font font);

    [CCode (cname = "TTF_GetFontKerning")]
    public static bool get_font_kerning (Font font);

    [CCode (cname = "TTF_GetFontLineSkip")]
    public static int get_font_line_skip (Font font);

    [CCode (cname = "TTF_GetFontOutline")]
    public static int get_font_outline (Font font);

    [CCode (cname = "TTF_GetFontProperties")]
    public static SDL.Properties.PropertiesID get_font_properties (Font font);

    [CCode (cname = "TTF_GetFontScript")]
    public static uint32 get_font_script (Font font);

    [CCode (cname = "TTF_GetFontSDF")]
    public static bool get_font_sdf (Font font);

    [CCode (cname = "TTF_GetFontSize")]
    public static float get_font_size (Font font);

    [CCode (cname = "TTF_GetFontStyle")]
    public static FontStyleFlags get_font_style (Font font);

    [CCode (cname = "TTF_GetFontStyleName")]
    public static string get_font_style_name (Font font);

    [CCode (cname = "TTF_GetFontWrapAlignment")]
    public static HorizontalAlignment get_font_wrap_alignment (Font font);

    [CCode (cname = "TTF_GetFreeTypeVersion")]
    public static void get_freetype_version (out int? major, out int? minor, out int? patch);

    [CCode (cname = "TTF_GetGlyphImage")]
    public static SDL.Surface.Surface ? get_glyph_image (Font font, uint32 ch, ImageType image_type);

    [CCode (cname = "TTF_GetGlyphImageForIndex")]
    public static SDL.Surface.Surface ? get_glyph_image_for_index (Font font, uint32 glyph_index, ImageType image_type);

    [CCode (cname = "TTF_GetGlyphKerning")]
    public static bool get_glyph_kerning (Font font, uint32 previous_ch, uint32 ch, out int? kerning);

    [CCode (cname = "TTF_GetGlyphMetrics")]
    public static bool get_glyph_metrics (Font font,
        uint32 ch,
        out int minx,
        out int maxx,
        out int miny,
        out int maxy,
        out int advance);

    [CCode (cname = "TTF_GetGlyphScript")]
    public static uint32 get_glyph_script (uint32 ch);

    [CCode (cname = "TTF_GetGPUTextDrawData", array_null_terminated = true)]
    public static GPUAtlasDrawSequence[] ? get_gpu_text_draw_data (Text text);

    [CCode (cname = "TTF_GetGPUTextEngineWinding")]
    public static GPUTextEngineWinding get_gpu_text_engine_windind (TextEngine engine);

    [CCode (cname = "TTF_GetHarfBuzzVersion")]
    public static void get_harf_buzz_version (out int? major, out int? minor, out int? patch);

    [CCode (cname = "TTF_GetNextTextSubString")]
    public static bool get_next_text_substring (Text text, SubString substring, out SubString next);

    [CCode (cname = "TTF_GetNumFontFaces")]
    public static int get_num_font_faces (Font font);

    [CCode (cname = "TTF_GetPreviousTextSubString")]
    public static bool get_previous_text_substring (Text text, SubString substring, out SubString previous);

    [CCode (cname = "TTF_GetStringSize")]
    public static bool get_string_size (Font font, string text, out int w, out int h);

    [CCode (cname = "TTF_GetStringSizeWrapped")]
    public static bool get_string_size_wrapped (Font font, string text, int wrap_width, out int w, out int h);

    [CCode (cname = "TTF_GetTextColor")]
    public static bool get_text_color (Text text, out uint8 r, out uint8 g, out uint8 b, out uint8 a);

    [CCode (cname = "TTF_GetTextColorFloat")]
    public static bool get_text_color_float (Text text, out float r, out float g, out float b, out float a);

    [CCode (cname = "TTF_GetTextDirection")]
    public static Direction get_text_direction (Text text);

    [CCode (cname = "TTF_GetTextEngine")]
    public static TextEngine ? get_text_engine (Text text);

    [CCode (cname = "TF_GetTextFont")]
    public static Font ? get_text_font (Text text);

    [CCode (cname = "TTF_GetTextPosition")]
    public static bool get_text_position (Text text, out int x, out int y);

    [CCode (cname = "TTF_GetTextProperties")]
    public static SDL.Properties.PropertiesID get_text_properties (Text text);

    [CCode (cname = "TTF_GetTextScript")]
    public static uint32 get_text_script (Text text);

    [CCode (cname = "TTF_GetTextSize")]
    public static bool get_text_size (Text text, out int? w, out int? h);

    [CCode (cname = "TTF_GetTextSubString")]
    public static bool get_text_substring (Text text, int offset, out SubString substring);

    [CCode (cname = "TTF_GetTextSubStringForLine")]
    public static bool get_text_substring_for_line (Text text, int line, SubString substring);

    [CCode (cname = "TTF_GetTextSubStringForPoint")]
    public static bool get_text_substring_for_point (Text text, int x, int y, SubString substring);

    [CCode (cname = "TTF_GetTextSubStringsForRange")]
    public static SubString[] ? get_text_substring_for_range (Text text, int offset, int length);

    [CCode (cname = "TTF_GetTextWrapWidth")]
    public static bool get_tert_wrap_width (Text text, out int wrap_width);

    [CCode (cname = "TTF_GPUTextEngineWinding", cprefix = "TTF_GPU_TEXTENGINE_WINDING_", has_type_id = false)]
    public enum GPUTextEngineWinding {
        INVALID,
        CLOCKWISE,
        COUNTER_CLOCKWISE,
    } // GPUTextEngineWinding

    [CCode (cname = "TTF_GPUAtlasDrawSequence", has_type_id = false)]
    public struct GPUAtlasDrawSequence {
        public SDL.Gpu.GPUTexture atlas_texture; /**< Texture atlas that stores the glyphs */
        public SDL.Rect.FPoint[] xy; /**< An array of vertex positions */
        public SDL.Rect.FPoint[] uv; /**< An array of normalized texture coordinates for each vertex */
        public int num_vertices; /**< Number of vertices */
        public int[] indices; /**< An array of indices into the 'vertices' arrays */
        public int num_indices; /**< Number of indices */
        public ImageType image_type; /**< The image type of this draw sequence */
        public GPUAtlasDrawSequence? next; /**< The next sequence (will be NULL in case of the last sequence) */
    } // GPUAtlasDrawSequence

    [Flags, CCode (cname = "TTF_HintingFlags", cprefix = "TTF_HINTING_", has_type_id = false)]
    public enum HintingFlags {
        NORMAL,
        LIGHT,
        MONO,
        NONE,
        LIGHT_SUBPIXEL,
    } // HintingFlags

    [CCode (cname = "TTF_HorizontalAlignment", cprefix = "TTF_HORIZONTAL_ALIGN_", has_type_id = false)]
    public enum HorizontalAlignment {
        INVALID,
        LEFT,
        CENTER,
        RIGHT,
    } // HorizontalAlignment

    [CCode (cname = "TTF_ImageType", cprefix = "TTF_IMAGE_", has_type_id = false)]
    public enum ImageType {
        INVALID,
        ALPHA,
        COLOR,
        SDF,
    } // ImageType

    [CCode (cname = "TTF_Init")]
    public static bool init ();

    [CCode (cname = "TTF_InsertTextString")]
    public static bool insert_text_string (Text text, int offset, string text_to_insert);

    // Not implemente due to backward compatibility inecesary for the bindings
    // #define TTF_MAJOR_VERSION   SDL_TTF_MAJOR_VERSION

    [CCode (cname = "TTF_MeasureString")]
    public static bool measure_string (Font font,
        string text,
        int max_width,
        out int? measured_width,
        out size_t? measured_length);

    [CCode (cname = "TTF_OpenFont")]
    public static Font ? open_font (string file, float point_size);

    [CCode (cname = "TTF_OpenFontIO")]
    public static Font ? open_font_io (SDL.IOStream.IOStream src, bool close_io, float pointt_size);

    [CCode (cname = "TTF_OpenFontWithProperties")]
    public static Font ? open_font_with_properties (SDL.Properties.PropertiesID props);

    [CCode (cname = "TTF_Quit")]
    public static void quit ();

    [CCode (cname = "TTF_RemoveFallbackFont")]
    public static void remove_fallback_font (Font font, Font fallback);

    [CCode (cname = "TTF_RenderGlyph_Blended")]
    public static SDL.Surface.Surface ? render_glyph_blended (Font font, uint32 ch, SDL.Pixels.Color fg);

    [CCode (cname = "TTF_RenderGlyph_LCD")]
    public static SDL.Surface.Surface ? render_glyph_lcd (Font font,
                                                          uint32 ch,
                                                          SDL.Pixels.Color fg,
                                                          SDL.Pixels.Color bg);

    [CCode (cname = "TTF_RenderGlyph_Shaded")]
    public static SDL.Surface.Surface ? render_glyph_shaded (Font font,
                                                             uint32 ch,
                                                             SDL.Pixels.Color fg,
                                                             SDL.Pixels.Color bg);

    [CCode (cname = "TTF_RenderGlyph_Solid")]
    public static SDL.Surface.Surface ? render_glyph_solid (Font font,
                                                            uint32 ch,
                                                            SDL.Pixels.Color fg);

    [CCode (cname = "TTF_RenderText_Blended")]
    public static SDL.Surface.Surface ? render_text_blended (Font font,
                                                             string text,
                                                             size_t length,
                                                             SDL.Pixels.Color fg);

    [CCode (cname = "TTF_RenderText_Blended_Wrapped")]
    public static SDL.Surface.Surface ? render_text_blended_wrapped (Font font,
                                                                     string text,
                                                                     size_t length,
                                                                     SDL.Pixels.Color fg,
                                                                     int wrap_width);

    [CCode (cname = "TTF_RenderText_LCD")]
    public static SDL.Surface.Surface ? render_text_lcd (Font font,
                                                         string text,
                                                         size_t length,
                                                         SDL.Pixels.Color fg,
                                                         SDL.Pixels.Color bg);

    [CCode (cname = "TTF_RenderText_LCD_Wrapped")]
    public static SDL.Surface.Surface ? render_text_lcd_wrapped (Font font,
                                                                 string text,
                                                                 size_t length,
                                                                 SDL.Pixels.Color fg,
                                                                 SDL.Pixels.Color bg,
                                                                 int wrap_width);

    [CCode (cname = "TTF_RenderText_Shaded")]
    public static SDL.Surface.Surface ? render_text_shaded (Font font,
                                                            string text,
                                                            size_t length,
                                                            SDL.Pixels.Color fg,
                                                            SDL.Pixels.Color bg);

    [CCode (cname = "TTF_RenderText_Shaded_Wrapped")]
    public static SDL.Surface.Surface ? render_text_shaded_wrapped (Font font,
                                                                    string text,
                                                                    size_t length,
                                                                    SDL.Pixels.Color fg,
                                                                    SDL.Pixels.Color bg,
                                                                    int wrap_width);

    [CCode (cname = "TTF_RenderText_Solid")]
    public static SDL.Surface.Surface ? render_text_solid (Font font,
                                                           string text,
                                                           size_t length,
                                                           SDL.Pixels.Color fg);

    [CCode (cname = "TTF_RenderText_Solid_Wrapped")]
    public static SDL.Surface.Surface ? render_text_solid_wrapped (Font font,
                                                                   string text,
                                                                   size_t length,
                                                                   SDL.Pixels.Color fg,
                                                                   int wrapLength);

    [CCode (cname = "TTF_SetFontDirection")]
    public static bool set_font_direction (Font font, Direction direction);

    [CCode (cname = "TTF_SetFontHinting")]
    public static void set_font_hinting (Font font, HintingFlags hinting);

    [CCode (cname = "TTF_SetFontKerning")]
    public static void set_font_kerning (Font font, bool enabled);

    [CCode (cname = "TTF_SetFontLanguage")]
    public static bool set_font_language (Font font, string? language_bcp47);

    [CCode (cname = "TTF_SetFontLineSkip")]
    public static void set_font_line_skip (Font font, int lineskip);

    [CCode (cname = "TTF_SetFontOutline")]
    public static bool set_font_outline (Font font, int outline);

    [CCode (cname = "TTF_SetFontScript")]
    public static bool set_font_script (Font font, uint32 script);

    [CCode (cname = "TTF_SetFontSDF")]
    public static bool set_font_sdf (Font font, bool enabled);

    [CCode (cname = "TTF_SetFontSize")]
    public static bool set_font_size (Font font, float point_size);

    [CCode (cname = "TTF_SetFontSizeDPI")]
    public static bool set_font_size_dpi (Font font, float pointt_size, int hdpi, int vdpi);

    [CCode (cname = "TTF_SetFontStyle")]
    public static void set_font_style (Font font, FontStyleFlags style);

    [CCode (cname = "TTF_SetFontWrapAlignment")]
    public static void set_font_wrap_alignment (Font font, HorizontalAlignment align);

    [CCode (cname = "TTF_SetGPUTextEngineWinding")]
    public static void set_gpu_text_engine_winding (TextEngine engine, GPUTextEngineWinding winding);

    [CCode (cname = "TTF_SetTextColor")]
    public static bool set_text_color (Text text, uint8 r, uint8 g, uint8 b, uint8 a);

    [CCode (cname = "TTF_SetTextColorFloat")]
    public static bool set_text_color_float (Text text, float r, float g, float b, float a);

    [CCode (cname = "TTF_SetTextDirection")]
    public static bool set_text_direction (Text text, Direction direction);

    [CCode (cname = "TTF_SetTextEngine")]
    public static bool set_text_engine (Text text, TextEngine engine);

    [CCode (cname = "TTF_SetTextFont")]
    public static bool set_text_font (Text text, Font font);

    [CCode (cname = "TTF_SetTextPosition")]
    public static bool set_text_position (Text text, int x, int y);

    [CCode (cname = "TTF_SetTextScript")]
    public static bool set_text_script (Text text, uint32 script);

    [CCode (cname = "TTF_SetTextString")]
    public static bool set_text_string (Text text, string text_to_set);

    [CCode (cname = "TTF_SetTextWrapWhitespaceVisible")]
    public static bool set_text_wrap_whitespace_visible (Text text, bool visible);

    [CCode (cname = "TTF_SetTextWrapWidth")]
    public static bool set_text_wrap_width (Text text, int wrap_width);

    [CCode (cname = "TTF_StringToTag")]
    public static uint32 string_to_tag (string text);

    [CCode (cname = "TTF_SubString", has_type_id = false)]
    public struct SubString {
        public SubStringFlags flags;
        public int offset;
        public int length;
        public int line_index;
        public int cluster_index;
        public SDL.Rect.Rect rect;
    } // SubString;

    [Flags, CCode (cname = "Uint32", cprefix = "TTF_SUBSTRING_", has_type_id = false)]
    public enum  SubStringFlags {
        DIRECTION_MASK,
        TEXT_START,
        LINE_START,
        LINE_END,
        TEXT_END,
    } // SubStringFlags

    [CCode (cname = "TTF_TagToString")]
    public static void tag_to_string (uint32 tag, out string? text);

    [CCode (cname = "TTF_Text", has_type_id = false)]
    public struct Text {
        public string text;
        public int num_lines;
        public int refcount;
        [CCode (cname = "internal")]
        public TextData internal_data;
    } // Text

    [Compact, CCode (cname = "TTF_TextData", free_function = "", has_type_id = false)]
    public class TextData {}

    [Compact, CCode (cname = "TTF_TextEngine", free_function = "", has_type_id = false)]
    public class TextEngine {}

    [CCode (cname = "TTF_TextWrapWhitespaceVisible")]
    public static bool text_wrap_whitespace_visible (Text text);

    [CCode (cname = "TTF_UpdateText")]
    public static bool update_text (Text text);

    [CCode (cname = "TTF_Version")]
    public static int version ();

    [CCode (cname = "TTF_WasInit")]
    public static int was_init ();

    [CCode (cname = "UNICODE_BOM_NATIVE")]
    public const int32 UNICODE_BOM_NATIVE;

    namespace TTFPropGPUTextEngine {
        [CCode (cname = "TTF_PROP_GPU_TEXT_ENGINE_DEVICE")]
        public const string DEVICE;

        [CCode (cname = "TTF_PROP_GPU_TEXT_ENGINE_ATLAS_TEXTURE_SIZE")]
        public const string ATLAS_TEXTURE_SIZE;
    } // TTFPropGPUTextEngine

    namespace TTFPropRendererTextEngine {
        [CCode (cname = "TTF_PROP_RENDERER_TEXT_ENGINE_RENDERER")]
        public const string DEVICE;

        [CCode (cname = "TTF_PROP_RENDERER_TEXT_ENGINE_ATLAS_TEXTURE_SIZE")]
        public const string ATLAS_TEXTURE_SIZE;
    } // TTFPropRendererTextEngine

    namespace TTFPropFont {
        [CCode (cname = "TTF_PROP_FONT_OUTLINE_LINE_CAP_NUMBER")]
        public const string OUTLINE_LINE_CAP_NUMBER;

        [CCode (cname = "TTF_PROP_FONT_OUTLINE_LINE_JOIN_NUMBER")]
        public const string OUTLINE_LINE_JOIN_NUMBER;

        [CCode (cname = "TTF_PROP_FONT_OUTLINE_MITER_LIMIT_NUMBER")]
        public const string OUTLINE_MITER_LIMIT_NUMBER;
    } // TTFPropFont

    namespace TTFPropFontCreate {
        [CCode (cname = "TTF_PROP_FONT_CREATE_FILENAME_STRING")]
        public const string FILENAME_STRING;

        [CCode (cname = "TTF_PROP_FONT_CREATE_IOSTREAM_POINTER")]
        public const string IOSTREAM_POINTER;

        [CCode (cname = "TTF_PROP_FONT_CREATE_IOSTREAM_OFFSET_NUMBER")]
        public const string IOSTREAM_OFFSET_NUMBER;

        [CCode (cname = "TTF_PROP_FONT_CREATE_IOSTREAM_AUTOCLOSE_BOOLEAN")]
        public const string IOSTREAM_AUTOCLOSE_BOOLEAN;

        [CCode (cname = "TTF_PROP_FONT_CREATE_SIZE_FLOAT")]
        public const string SIZE_FLOAT;

        [CCode (cname = "TTF_PROP_FONT_CREATE_FACE_NUMBER")]
        public const string FACE_NUMBER;

        [CCode (cname = "TTF_PROP_FONT_CREATE_HORIZONTAL_DPI_NUMBER")]
        public const string HORIZONTAL_DPI_NUMBER;

        [CCode (cname = "TTF_PROP_FONT_CREATE_VERTICAL_DPI_NUMBER")]
        public const string VERTICAL_DPI_NUMBER;

        [CCode (cname = "TTF_PROP_FONT_CREATE_EXISTING_FONT")]
        public const string EXISTING_FONT;
    }
}