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
 * https://wiki.libsdl.org/SDL3_image/CategoryAPI
 */

/**
 * The SDL3 Image Library Vala bindings This is a simple library to load images
 * of various formats as SDL surfaces. It can load BMP, GIF, JPEG, LBM, PCX,
 * PNG, PNM (PPM/PGM/PBM), QOI, TGA, XCF, XPM, and simple SVG format images. It
 * can also load AVIF, JPEG-XL, TIFF, and WebP images, depending on build
 * options.
 *
 *   * SDL3 Image Reference: [[https://wiki.libsdl.org/SDL3_image/]]
 */
[CCode (cheader_filename = "SDL3_image/SDL_image.h")]
namespace SDL3.Image {
    [Compact, CCode (cname = "IMG_Animation", free_function="")]
    public class Animation {
        public int w;
        public int h;
        public int count;
        [CCode (array_length = false)]
        public SDL3.Surface.Surface[] frames;
        [CCode (array_length = false)]
        public int[] delays;
    } // Animation

    [CCode (cname = "IMG_FreeAnimation")]
    public static void free_animation (Animation anim);

    [CCode (cname = "IMG_isAVIF")]
    public static bool is_avif (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isBMP")]
    public static bool is_bmp (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isCUR")]
    public static bool is_cur (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isGIF")]
    public static bool is_gif (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isICO")]
    public static bool is_ico (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isJPG")]
    public static bool is_jpg (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isJXL")]
    public static bool is_jxl (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isLBM")]
    public static bool is_lbm (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isPCX")]
    public static bool is_pcx (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isPNG")]
    public static bool is_png (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isPNM")]
    public static bool is_pnm (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isQOI")]
    public static bool is_qoi (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isSVG")]
    public static bool is_svg (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isTIF")]
    public static bool is_tif (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isWEBP")]
    public static bool is_webp (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isXCF")]
    public static bool is_xcf (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isXPM")]
    public static bool is_xpm (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_isXV")]
    public static bool is_xv (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_Load")]
    public static SDL3.Surface.Surface ? load (string file);

    [CCode (cname = "IMG_Load_IO")]
    public static SDL3.Surface.Surface ? load_io (SDL3.IOStream.IOStream src, bool close_io);

    [CCode (cname = "IMG_LoadAnimation")]
    public static Animation ? load_animation (string file);

    [CCode (cname = "IMG_LoadAnimation_IO")]
    public static Animation ? load_animation_io (SDL3.IOStream.IOStream src, bool close_io);

    [CCode (cname = "IMG_LoadAnimationTyped_IO")]
    public static Animation ? load_animation_typed_io (SDL3.IOStream.IOStream src, bool close_io, string type);

    [CCode (cname = "IMG_LoadAVIF_IO")]
    public static SDL3.Surface.Surface ? load_avif_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadBMP_IO")]
    public static SDL3.Surface.Surface ? load_bmp_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadCUR_IO")]
    public static SDL3.Surface.Surface ? load_cur_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadGIF_IO")]
    public static SDL3.Surface.Surface ? load_gif_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadGIFAnimation_IO")]
    public static Animation ? load_gif_animation_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadICO_IO")]
    public static SDL3.Surface.Surface ? load_ico_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadJPG_IO")]
    public static SDL3.Surface.Surface ? load_jpg_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadJXL_IO")]
    public static SDL3.Surface.Surface ? load_jxl_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadLBM_IO")]
    public static SDL3.Surface.Surface ? load_lbm_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadPCX_IO")]
    public static SDL3.Surface.Surface ? load_pcx_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadPNG_IO")]
    public static SDL3.Surface.Surface ? load_png_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadPNM_IO")]
    public static SDL3.Surface.Surface ? load_pnm_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadQOI_IO")]
    public static SDL3.Surface.Surface ? load_qoi_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadSizedSVG_IO")]
    public static SDL3.Surface.Surface ? load_sized_svg_io (SDL3.IOStream.IOStream src, int width, int height);

    [CCode (cname = "IMG_LoadSVG_IO")]
    public static SDL3.Surface.Surface ? load_svg_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadTexture")]
    public static SDL3.Render.Texture ? load_texture (SDL3.Render.Renderer renderer, string file);

    [CCode (cname = "IMG_LoadTexture_IO")]
    public static SDL3.Render.Texture ? load_texture_io (SDL3.Render.Renderer renderer,
                                                         SDL3.IOStream.IOStream src,
                                                         bool close_io);

    [CCode (cname = "IMG_LoadTextureTyped_IO")]
    public static SDL3.Render.Texture ? load_texture_typed_io (SDL3.Render.Renderer renderer,
                                                               SDL3.IOStream.IOStream src,
                                                               bool close_io,
                                                               string type);

    [CCode (cname = "IMG_LoadTGA_IO")]
    public static SDL3.Surface.Surface ? load_tga_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadTIF_IO")]
    public static SDL3.Surface.Surface ? load_tif_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadTyped_IO")]
    public static SDL3.Surface.Surface ? load_typed_io (SDL3.IOStream.IOStream src, bool close_io, string type);

    [CCode (cname = "IMG_LoadWEBP_IO")]
    public static SDL3.Surface.Surface ? load_webp_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadWEBPAnimation_IO")]
    public static Animation ? load_webp_animation_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadXCF_IO")]
    public static SDL3.Surface.Surface ? load_xcf_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadXPM_IO")]
    public static SDL3.Surface.Surface ? load_xpm_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_LoadXV_IO")]
    public static SDL3.Surface.Surface ? load_xv_io (SDL3.IOStream.IOStream src);

    [CCode (cname = "IMG_ReadXPMFromArray")]
    public static SDL3.Surface.Surface ? read_xpm_from_array ([CCode (array_null_terminated = true)]
                                                              string[] xpm);

    [CCode (cname = "IMG_ReadXPMFromArrayToRGB888")]
    public static SDL3.Surface.Surface ? read_xspm_from_array_to_rgb888 ([CCode (array_null_terminated = true)]
                                                                         string[] xpm);

    [CCode (cname = "IMG_SaveAVIF")]
    public static bool save_avif (SDL3.Surface.Surface surface, string file, int quality);

    [CCode (cname = "IMG_SaveAVIF_IO")]
    public static bool save_avif_io (SDL3.Surface.Surface surface,
                                     SDL3.IOStream.IOStream dst,
                                     bool close_io,
                                     int quality);

    [CCode (cname = "IMG_SaveJPG")]
    public static bool save_jpg (SDL3.Surface.Surface surface, string file, int quality);

    [CCode (cname = "IMG_SaveJPG_IO")]
    public static bool save_jpg_io (SDL3.Surface.Surface surface,
        SDL3.IOStream.IOStream dst,
        bool close_io,
        int quality);

    [CCode (cname = "IMG_SavePNG")]
    public static bool save_png (SDL3.Surface.Surface surface, string file);

    [CCode (cname = "IMG_SavePNG_IO")]
    public static bool save_png_io (SDL3.Surface.Surface surface, SDL3.IOStream.IOStream dst, bool close_io);

    [CCode (cname = "IMG_Version")]
    public static int version ();

    [CCode (cname = "SDL_IMAGE_MAJOR_VERSION")]
    public const int MAJOR_VERSION;

    [CCode (cname = "SDL_IMAGE_VERSION")]
    public const int VERSION;

    [CCode (cname = "SDL_IMAGE_VERSION_ATLEAST")]
    public static bool sdl_image_version_at_least (int major, int minor, int micro);
} // SDL3.Image
