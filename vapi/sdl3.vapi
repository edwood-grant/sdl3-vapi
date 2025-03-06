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
 * https://wiki.libsdl.org/SDL3/APIByCategory
 */

///
/// MAIN NAMESPACE
///

/**
 * The SDL3 Library Vala bindings
 *
 * Simple DirectMedia Layer is a cross-platform development library
 * designed to provide low level access to audio, keyboard, mouse,
 * joystick, and graphics hardware.
 *
 *  * SDL3 Reference: [[https://wiki.libsdl.org/SDL3/]]
 *
 */
[CCode (cheader_filename = "SDL3/SDL.h")]
namespace SDL {}

///
/// BASICS
///

/**
 * Application entry points (SDL_main.h)
 *
 * Redefines main() if necessary so that it is called by SDL. <<BR>>
 * In Vala, this is done with custom entry point to handle manual main
 * initialization and add custom callbacks.
 *
 *  * [[https://wiki.libsdl.org/SDL3/CategoryMain]]
 *
 */
[CCode (cheader_filename = "SDL3/SDL_main.h")]
namespace SDL.Main {
    /**
     * Defines custom entry point callbacks for SDL's use with //SDL_MAIN_HANDLED.//
     *
     *  * [[https://wiki.libsdl.org/SDL3/SDL_EnterAppMainCallbacks]]
     *
     */
#if SDL_MAIN_USE_PTR_ARRAY
    [CCode (cname = "SDL_EnterAppMainCallbacks")]
    public static int enter_app_main_callbacks ([CCode (array_length_pos = 0.9)] string[] args,
        [CCode (delegate_target = false)] Init.AppInitFuncGLib appinit,
        [CCode (delegate_target = false)] Init.AppIterateFuncGLib appiter,
        [CCode (delegate_target = false)] Init.AppEventFuncGLib appevent,
        [CCode (delegate_target = false)] Init.AppQuitFuncGLib appquit);
#else
    [CCode (cname = "SDL_EnterAppMainCallbacks")]
    public static int enter_app_main_callbacks ([CCode (array_length_pos = 0.9)] string[] args,
        [CCode (delegate_target = false)] Init.AppInitFuncPosix appinit,
        [CCode (delegate_target = false)] Init.AppIterateFuncPosix appiter,
        [CCode (delegate_target = false)] Init.AppEventFuncPosix appevent,
        [CCode (delegate_target = false)] Init.AppQuitFuncPosix appquit);
#endif

    /**
     * Callback from the application to let the suspend continue. Works on Xbox GDK only.
     *
     *  * [[https://wiki.libsdl.org/SDL3/SDL_GDKSuspendComplete]]
     *
     */
    [CCode (cname = "SDL_GDKSuspendComplete")]
    public static void gdk_suspend_complete ();

    [CCode (cname = "SDL_RegisterApp")]
    public static bool register_app (string? name, uint32 style, void* h_inst);

    [CCode (cname = "SDL_RunApp")]
    public static int run_app ([CCode (array_length_pos = 0.9)] string[] args,
        MainFunc main_function,
        void* reserved);

    [CCode (cname = "SDL_SetMainReady")]
    public static void set_main_ready ();

    [CCode (cname = "SDL_UnregisterApp")]
    public static void unregister_app ();

    [CCode (cname = "SDL_main_func", has_target = false)]
    public delegate int MainFunc ([CCode (array_length_pos = 0.9)] string[] args);
} // SDL.Main

///
/// Initialization and Shutdown (SDL_init.h)
///
[CCode (cheader_filename = "SDL3/SDL_init.h")]
namespace SDL.Init {
    [CCode (cname = "SDL_GetAppMetadataProperty")]
    public static unowned string ? get_app_metadata_property (string name);

    [CCode (cname = "SDL_Init")]
    public static bool init (InitFlags flags);

    [CCode (cname = "SDL_InitSubSystem")]
    public static int init_subsystem (InitFlags flags);

    [CCode (cname = "SDL_IsMainThread")]
    public static bool is_main_thread ();

    [CCode (cname = "SDL_Quit")]
    public static void quit ();

    [CCode (cname = "SDL_QuitSubSystem")]
    public static int quit_subsystem (InitFlags flags);

    [CCode (cname = "SDL_RunOnMainThread", has_target = true, instance_pos = 1)]
    public static AppResult run_on_main_thread (MainThreadCallback callback, bool wait_complete);

    [CCode (cname = "SDL_SetAppMetadata")]
    public static bool set_app_metadata (string? app_name, string? app_version, string? app_identifier);

    [CCode (cname = "SDL_SetAppMetadataProperty")]
    public static bool set_app_metadata_property (string name, string? value);

    [CCode (cname = "SDL_PROP_APP_METADATA_TYPE_STRING")]
    public const string PROP_APP_METADATA_NAME_STRING;

    [CCode (cname = "SDL_PROP_APP_METADATA_TYPE_STRING")]
    public const string PROP_APP_METADATA_VERSION_STRING;

    [CCode (cname = "SDL_PROP_APP_METADATA_TYPE_STRING")]
    public const string PROP_APP_METADATA_IDENTIFIER_STRING;

    [CCode (cname = "SDL_PROP_APP_METADATA_TYPE_STRING")]
    public const string PROP_APP_METADATA_CREATOR_STRING;

    [CCode (cname = "SDL_PROP_APP_METADATA_TYPE_STRING")]
    public const string PROP_APP_METADATA_COPYRIGHT_STRING;

    [CCode (cname = "SDL_PROP_APP_METADATA_TYPE_STRING")]
    public const string PROP_APP_METADATA_URL_STRING;

    [CCode (cname = "SDL_PROP_APP_METADATA_TYPE_STRING")]
    public const string PROP_APP_METADATA_TYPE_STRING;

    [CCode (cname = "SDL_WasInit")]
    public static InitFlags was_init (InitFlags flags);

#if SDL_MAIN_USE_PTR_ARRAY
    [CCode (cname = "SDL_AppEvent_func", has_target = false, has_type_id = false)]
    public delegate AppResult AppEventFuncGLib (GLib.PtrArray app_state, Events.Event current_event);

    [CCode (cname = "SDL_AppInit_func", has_target = false, has_type_id = false)]
    public delegate AppResult AppInitFuncGLib (out GLib.PtrArray app_state, [CCode (array_length_pos = 1.9)] string[] args);

    [CCode (cname = "SDL_AppIterate_func", has_target = false, has_type_id = false)]
    public delegate AppResult AppIterateFuncGLib (GLib.PtrArray app_state);

    [CCode (cname = "SDL_AppQuit_func", has_target = true, instance_pos = 0)]
    public delegate void AppQuitFuncGLib (GLib.PtrArray app_state, AppResult result);
#else
    [CCode (cname = "SDL_AppEvent_func", has_target = false, has_type_id = false)]
    public delegate AppResult AppEventFuncPosix (void* app_state, Events.Event current_event);

    [CCode (cname = "SDL_AppInit_func", has_target = false, has_type_id = false)]
    public delegate AppResult AppInitFuncPosix (out void* app_state, [CCode (array_length_pos = 1.9)] string[] args);

    [CCode (cname = "SDL_AppIterate_func", has_target = false, has_type_id = false)]
    public delegate AppResult AppIterateFuncPosix (void* app_state);

    [CCode (cname = "SDL_AppQuit_func", has_target = true, instance_pos = 0)]
    public delegate void AppQuitFuncPosix (void* app_state, AppResult result);
#endif

    [Flags, CCode (cname = "int", cprefix = "SDL_INIT_", has_type_id = false)]
    public enum InitFlags {
        AUDIO,
        VIDEO,
        JOYSTICK,
        HAPTIC,
        GAMEPAD,
        EVENTS,
        SENSOR,
        CAMERA
    } // InitFlags

    [CCode (cname = "SDL_MainThreadCallback", has_target = true)]
    public delegate AppResult MainThreadCallback ();

    [CCode (cname = "SDL_AppResult", cprefix = "SDL_APP_", has_type_id = false)]
    public enum AppResult {
        CONTINUE,
        SUCCESS,
        FAILURE
    } // AppResult
} // SDL.Init

///
/// Configuration Variables (SDL_hints.c)
///
[CCode (cheader_filename = "SDL3/SDL_hints.h")]
namespace SDL.Hints {
    [CCode (cname = "SDL_AddHintCallback")]
    public static bool add_hint_callback (string name, HintCallback callback);

    [CCode (cname = "SDL_GetHint")]
    public static unowned string ? get_hint (string name);

    [CCode (cname = "SDL_GetHintBoolean")]
    public static bool get_hint_boolean (string name, bool default_value);

    [CCode (cname = "SDL_RemoveHintCallback")]
    public static void remove_hint_callback (string name, HintCallback callback);

    [CCode (cname = "SDL_ResetHint")]
    public static bool reset_hint (string name);

    [CCode (cname = "SDL_ResetHints")]
    public static void reset_hints ();

    [CCode (cname = "SDL_SetHint")]
    public static bool set_hint (string name, string? value);

    [CCode (cname = "SDL_SetHintWithPriority")]
    public static bool set_hint_with_priority (string name, string? value, HintPriority priority);

    [CCode (cname = "SDL_HintCallback", has_target = true, instance_pos = 0)]
    public delegate void HintCallback (string name, string? old_value, string? new_value);

    [CCode (cname = "SDL_HintPriority", cprefix = "SDL_HINT_", has_type_id = false)]
    public enum HintPriority {
        DEFAULT,
        NORMAL,
        OVERRIDE
    } // HintPriority

    [CCode (cname = "SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED")]
    public const string ALLOW_ALT_TAB_WHILE_GRABBED;

    [CCode (cname = "SDL_HINT_ANDROID_ALLOW_RECREATE_ACTIVITY")]
    public const string ANDROID_ALLOW_RECREATE_ACTIVITY;

    [CCode (cname = "SDL_HINT_ANDROID_BLOCK_ON_PAUSE")]
    public const string ANDROID_BLOCK_ON_PAUSE;

    [CCode (cname = "SDL_HINT_ANDROID_LOW_LATENCY_AUDIO")]
    public const string ANDROID_LOW_LATENCY_AUDIO;

    [CCode (cname = "SDL_HINT_ANDROID_TRAP_BACK_BUTTON")]
    public const string ANDROID_TRAP_BACK_BUTTON;

    [CCode (cname = "SDL_HINT_APP_ID")]
    public const string APP_ID;

    [CCode (cname = "SDL_HINT_APP_NAME")]
    public const string APP_NAME;

    [CCode (cname = "SDL_HINT_APPLE_TV_CONTROLLER_UI_EVENTS")]
    public const string APPLE_TV_CONTROLLER_UI_EVENTS;

    [CCode (cname = "SDL_HINT_APPLE_TV_REMOTE_ALLOW_ROTATION")]
    public const string APPLE_TV_REMOTE_ALLOW_ROTATION;

    [CCode (cname = "SDL_HINT_ASSERT")]
    public const string ASSERT;

    [CCode (cname = "SDL_HINT_AUDIO_ALSA_DEFAULT_DEVICE")]
    public const string AUDIO_ALSA_DEFAULT_DEVICE;

    [CCode (cname = "SDL_HINT_AUDIO_ALSA_DEFAULT_PLAYBACK_DEVICE")]
    public const string AUDIO_ALSA_DEFAULT_PLAYBACK_DEVICE;

    [CCode (cname = "SDL_HINT_AUDIO_ALSA_DEFAULT_RECORDING_DEVICE")]
    public const string AUDIO_ALSA_DEFAULT_RECORDING_DEVICE;

    [CCode (cname = "SDL_HINT_AUDIO_CATEGORY")]
    public const string AUDIO_CATEGORY;

    [CCode (cname = "SDL_HINT_AUDIO_CHANNELS")]
    public const string AUDIO_CHANNELS;

    [CCode (cname = "SDL_HINT_AUDIO_DEVICE_APP_ICON_NAME")]
    public const string AUDIO_DEVICE_APP_ICON_NAME;

    [CCode (cname = "SDL_HINT_AUDIO_DEVICE_SAMPLE_FRAMES")]
    public const string AUDIO_DEVICE_SAMPLE_FRAMES;

    [CCode (cname = "SDL_HINT_AUDIO_DEVICE_STREAM_NAME")]
    public const string AUDIO_DEVICE_STREAM_NAME;

    [CCode (cname = "SDL_HINT_AUDIO_DEVICE_STREAM_ROLE")]
    public const string AUDIO_DEVICE_STREAM_ROLE;

    [CCode (cname = "SDL_HINT_AUDIO_DISK_INPUT_FILE")]
    public const string AUDIO_DISK_INPUT_FILE;

    [CCode (cname = "SDL_HINT_AUDIO_DISK_OUTPUT_FILE")]
    public const string AUDIO_DISK_OUTPUT_FILE;

    [CCode (cname = "SDL_HINT_AUDIO_DISK_TIMESCALE")]
    public const string AUDIO_DISK_TIMESCALE;

    [CCode (cname = "SDL_HINT_AUDIO_DRIVER")]
    public const string AUDIO_DRIVER;

    [CCode (cname = "SDL_HINT_AUDIO_DUMMY_TIMESCALE")]
    public const string AUDIO_DUMMY_TIMESCALE;

    [CCode (cname = "SDL_HINT_AUDIO_FORMAT")]
    public const string AUDIO_FORMAT;

    [CCode (cname = "SDL_HINT_AUDIO_FREQUENCY")]
    public const string AUDIO_FREQUENCY;

    [CCode (cname = "SDL_HINT_AUDIO_INCLUDE_MONITORS")]
    public const string AUDIO_INCLUDE_MONITORS;

    [CCode (cname = "SDL_HINT_AUTO_UPDATE_JOYSTICKS")]
    public const string AUTO_UPDATE_JOYSTICKS;

    [CCode (cname = "SDL_HINT_AUTO_UPDATE_SENSORS")]
    public const string AUTO_UPDATE_SENSORS;

    [CCode (cname = "SDL_HINT_BMP_SAVE_LEGACY_FORMAT")]
    public const string BMP_SAVE_LEGACY_FORMAT;

    [CCode (cname = "SDL_HINT_CAMERA_DRIVER")]
    public const string CAMERA_DRIVER;

    [CCode (cname = "SDL_HINT_CPU_FEATURE_MASK")]
    public const string CPU_FEATURE_MASK;

    [CCode (cname = "SDL_HINT_DISPLAY_USABLE_BOUNDS")]
    public const string DISPLAY_USABLE_BOUNDS;

    [CCode (cname = "SDL_HINT_EGL_LIBRARY")]
    public const string EGL_LIBRARY;

    [CCode (cname = "SDL_HINT_EMSCRIPTEN_ASYNCIFY")]
    public const string EMSCRIPTEN_ASYNCIFY;

    [CCode (cname = "SDL_HINT_EMSCRIPTEN_CANVAS_SELECTOR")]
    public const string EMSCRIPTEN_CANVAS_SELECTOR;

    [CCode (cname = "SDL_HINT_EMSCRIPTEN_KEYBOARD_ELEMENT")]
    public const string EMSCRIPTEN_KEYBOARD_ELEMENT;

    [CCode (cname = "SDL_HINT_ENABLE_SCREEN_KEYBOARD")]
    public const string ENABLE_SCREEN_KEYBOARD;

    [CCode (cname = "SDL_HINT_EVDEV_DEVICES")]
    public const string EVDEV_DEVICES;

    [CCode (cname = "SDL_HINT_EVENT_LOGGING")]
    public const string EVENT_LOGGING;

    [CCode (cname = "SDL_HINT_FILE_DIALOG_DRIVER")]
    public const string FILE_DIALOG_DRIVER;

    [CCode (cname = "SDL_HINT_FORCE_RAISEWINDOW")]
    public const string FORCE_RAISEWINDOW;

    [CCode (cname = "SDL_HINT_FRAMEBUFFER_ACCELERATION")]
    public const string FRAMEBUFFER_ACCELERATION;

    [CCode (cname = "SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES")]
    public const string GAMECONTROLLER_IGNORE_DEVICES;

    [CCode (cname = "SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT")]
    public const string GAMECONTROLLER_IGNORE_DEVICES_EXCEPT;

    [CCode (cname = "SDL_HINT_GAMECONTROLLER_SENSOR_FUSION")]
    public const string GAMECONTROLLER_SENSOR_FUSION;

    [CCode (cname = "SDL_HINT_GAMECONTROLLERCONFIG")]
    public const string GAMECONTROLLERCONFIG;

    [CCode (cname = "SDL_HINT_GAMECONTROLLERCONFIG_FILE")]
    public const string GAMECONTROLLERCONFIG_FILE;

    [CCode (cname = "SDL_HINT_GAMECONTROLLERTYPE")]
    public const string GAMECONTROLLERTYPE;

    [CCode (cname = "SDL_HINT_GDK_TEXTINPUT_DEFAULT_TEXT")]
    public const string GDK_TEXTINPUT_DEFAULT_TEXT;

    [CCode (cname = "SDL_HINT_GDK_TEXTINPUT_DESCRIPTION")]
    public const string GDK_TEXTINPUT_DESCRIPTION;

    [CCode (cname = "SDL_HINT_GDK_TEXTINPUT_MAX_LENGTH")]
    public const string GDK_TEXTINPUT_MAX_LENGTH;

    [CCode (cname = "SDL_HINT_GDK_TEXTINPUT_SCOPE")]
    public const string GDK_TEXTINPUT_SCOPE;

    [CCode (cname = "SDL_HINT_GDK_TEXTINPUT_TITLE")]
    public const string GDK_TEXTINPUT_TITLE;

    [CCode (cname = "SDL_HINT_GPU_DRIVER")]
    public const string GPU_DRIVER;

    [CCode (cname = "SDL_HINT_HIDAPI_ENUMERATE_ONLY_CONTROLLERS")]
    public const string HIDAPI_ENUMERATE_ONLY_CONTROLLERS;

    [CCode (cname = "SDL_HINT_HIDAPI_IGNORE_DEVICES")]
    public const string HIDAPI_IGNORE_DEVICES;

    [CCode (cname = "SDL_HINT_HIDAPI_LIBUSB")]
    public const string HIDAPI_LIBUSB;

    [CCode (cname = "SDL_HINT_HIDAPI_LIBUSB_WHITELIST")]
    public const string HIDAPI_LIBUSB_WHITELIST;

    [CCode (cname = "SDL_HINT_HIDAPI_UDEV")]
    public const string HIDAPI_UDEV;

    [CCode (cname = "SDL_HINT_IME_IMPLEMENTED_UI")]
    public const string IME_IMPLEMENTED_UI;

    [CCode (cname = "SDL_HINT_IOS_HIDE_HOME_INDICATOR")]
    public const string IOS_HIDE_HOME_INDICATOR;

    [CCode (cname = "SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS")]
    public const string JOYSTICK_ALLOW_BACKGROUND_EVENTS;

    [CCode (cname = "SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES")]
    public const string JOYSTICK_ARCADESTICK_DEVICES;

    [CCode (cname = "SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES_EXCLUDED")]
    public const string JOYSTICK_ARCADESTICK_DEVICES_EXCLUDED;

    [CCode (cname = "SDL_HINT_JOYSTICK_BLACKLIST_DEVICES")]
    public const string JOYSTICK_BLACKLIST_DEVICES;

    [CCode (cname = "SDL_HINT_JOYSTICK_BLACKLIST_DEVICES_EXCLUDED")]
    public const string JOYSTICK_BLACKLIST_DEVICES_EXCLUDED;

    [CCode (cname = "SDL_HINT_JOYSTICK_DEVICE")]
    public const string JOYSTICK_DEVICE;

    [CCode (cname = "SDL_HINT_JOYSTICK_DIRECTINPUT")]
    public const string JOYSTICK_DIRECTINPUT;

    [CCode (cname = "SDL_HINT_JOYSTICK_ENHANCED_REPORTS")]
    public const string JOYSTICK_ENHANCED_REPORTS;

    [CCode (cname = "SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES")]
    public const string JOYSTICK_FLIGHTSTICK_DEVICES;

    [CCode (cname = "SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES_EXCLUDED")]
    public const string JOYSTICK_FLIGHTSTICK_DEVICES_EXCLUDED;

    [CCode (cname = "SDL_HINT_JOYSTICK_GAMECUBE_DEVICES")]
    public const string JOYSTICK_GAMECUBE_DEVICES;

    [CCode (cname = "SDL_HINT_JOYSTICK_GAMECUBE_DEVICES_EXCLUDED")]
    public const string JOYSTICK_GAMECUBE_DEVICES_EXCLUDED;

    [CCode (cname = "SDL_HINT_JOYSTICK_GAMEINPUT")]
    public const string JOYSTICK_GAMEINPUT;

    [Version (since = "3.2.5")]
    [CCode (cname = "SDL_HINT_JOYSTICK_HAPTIC_AXES")]
    public const string SDL_HINT_JOYSTICK_HAPTIC_AXES;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI")]
    public const string JOYSTICK_HIDAPI;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_COMBINE_JOY_CONS")]
    public const string JOYSTICK_HIDAPI_COMBINE_JOY_CONS;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE")]
    public const string JOYSTICK_HIDAPI_GAMECUBE;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE_RUMBLE_BRAKE")]
    public const string JOYSTICK_HIDAPI_GAMECUBE_RUMBLE_BRAKE;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_JOY_CONS")]
    public const string JOYSTICK_HIDAPI_JOY_CONS;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_JOYCON_HOME_LED")]
    public const string JOYSTICK_HIDAPI_JOYCON_HOME_LED;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_LUNA")]
    public const string JOYSTICK_HIDAPI_LUNA;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_NINTENDO_CLASSIC")]
    public const string JOYSTICK_HIDAPI_NINTENDO_CLASSIC;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_PS3")]
    public const string JOYSTICK_HIDAPI_PS3;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_PS3_SIXAXIS_DRIVER")]
    public const string JOYSTICK_HIDAPI_PS3_SIXAXIS_DRIVER;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_PS4")]
    public const string JOYSTICK_HIDAPI_PS4;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_PS4_REPORT_INTERVAL")]
    public const string JOYSTICK_HIDAPI_PS4_REPORT_INTERVAL;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_PS5")]
    public const string JOYSTICK_HIDAPI_PS5;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_PS5_PLAYER_LED")]
    public const string JOYSTICK_HIDAPI_PS5_PLAYER_LED;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_SHIELD")]
    public const string JOYSTICK_HIDAPI_SHIELD;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_STADIA")]
    public const string JOYSTICK_HIDAPI_STADIA;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_STEAM")]
    public const string JOYSTICK_HIDAPI_STEAM;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_STEAM_HOME_LED")]
    public const string JOYSTICK_HIDAPI_STEAM_HOME_LED;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_STEAM_HORI")]
    public const string JOYSTICK_HIDAPI_STEAM_HORI;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_STEAMDECK")]
    public const string JOYSTICK_HIDAPI_STEAMDECK;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_SWITCH")]
    public const string JOYSTICK_HIDAPI_SWITCH;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_SWITCH_HOME_LED")]
    public const string JOYSTICK_HIDAPI_SWITCH_HOME_LED;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED")]
    public const string JOYSTICK_HIDAPI_SWITCH_PLAYER_LED;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS")]
    public const string JOYSTICK_HIDAPI_VERTICAL_JOY_CONS;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_WII")]
    public const string JOYSTICK_HIDAPI_WII;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_WII_PLAYER_LED")]
    public const string JOYSTICK_HIDAPI_WII_PLAYER_LED;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_XBOX")]
    public const string JOYSTICK_HIDAPI_XBOX;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_XBOX_360")]
    public const string JOYSTICK_HIDAPI_XBOX_360;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED")]
    public const string JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_WIRELESS")]
    public const string JOYSTICK_HIDAPI_XBOX_360_WIRELESS;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE")]
    public const string JOYSTICK_HIDAPI_XBOX_ONE;

    [CCode (cname = "SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED")]
    public const string JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED;

    [CCode (cname = "SDL_HINT_JOYSTICK_IOKIT")]
    public const string JOYSTICK_IOKIT;

    [CCode (cname = "SDL_HINT_JOYSTICK_LINUX_CLASSIC")]
    public const string JOYSTICK_LINUX_CLASSIC;

    [CCode (cname = "SDL_HINT_JOYSTICK_LINUX_DEADZONES")]
    public const string JOYSTICK_LINUX_DEADZONES;

    [CCode (cname = "SDL_HINT_JOYSTICK_LINUX_DIGITAL_HATS")]
    public const string JOYSTICK_LINUX_DIGITAL_HATS;

    [CCode (cname = "SDL_HINT_JOYSTICK_LINUX_HAT_DEADZONES")]
    public const string JOYSTICK_LINUX_HAT_DEADZONES;

    [CCode (cname = "SDL_HINT_JOYSTICK_MFI")]
    public const string JOYSTICK_MFI;

    [CCode (cname = "SDL_HINT_JOYSTICK_RAWINPUT")]
    public const string JOYSTICK_RAWINPUT;

    [CCode (cname = "SDL_HINT_JOYSTICK_RAWINPUT_CORRELATE_XINPUT")]
    public const string JOYSTICK_RAWINPUT_CORRELATE_XINPUT;

    [CCode (cname = "SDL_HINT_JOYSTICK_ROG_CHAKRAM")]
    public const string JOYSTICK_ROG_CHAKRAM;

    [CCode (cname = "SDL_HINT_JOYSTICK_THREAD")]
    public const string JOYSTICK_THREAD;

    [CCode (cname = "SDL_HINT_JOYSTICK_THROTTLE_DEVICES")]
    public const string JOYSTICK_THROTTLE_DEVICES;

    [CCode (cname = "SDL_HINT_JOYSTICK_THROTTLE_DEVICES_EXCLUDED")]
    public const string JOYSTICK_THROTTLE_DEVICES_EXCLUDED;

    [CCode (cname = "SDL_HINT_JOYSTICK_WGI")]
    public const string JOYSTICK_WGI;

    [CCode (cname = "SDL_HINT_JOYSTICK_WHEEL_DEVICES")]
    public const string JOYSTICK_WHEEL_DEVICES;

    [CCode (cname = "SDL_HINT_JOYSTICK_WHEEL_DEVICES_EXCLUDED")]
    public const string JOYSTICK_WHEEL_DEVICES_EXCLUDED;

    [CCode (cname = "SDL_HINT_JOYSTICK_ZERO_CENTERED_DEVICES")]
    public const string JOYSTICK_ZERO_CENTERED_DEVICES;

    [CCode (cname = "SDL_HINT_KEYCODE_OPTIONS")]
    public const string KEYCODE_OPTIONS;

    [CCode (cname = "SDL_HINT_KMSDRM_DEVICE_INDEX")]
    public const string KMSDRM_DEVICE_INDEX;

    [CCode (cname = "SDL_HINT_KMSDRM_REQUIRE_DRM_MASTER")]
    public const string KMSDRM_REQUIRE_DRM_MASTER;

    [CCode (cname = "SDL_HINT_LOGGING")]
    public const string LOGGING;

    [CCode (cname = "SDL_HINT_MAC_BACKGROUND_APP")]
    public const string MAC_BACKGROUND_APP;

    [CCode (cname = "SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK")]
    public const string MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK;

    [CCode (cname = "SDL_HINT_MAC_OPENGL_ASYNC_DISPATCH")]
    public const string MAC_OPENGL_ASYNC_DISPATCH;

    [CCode (cname = "SDL_HINT_MAC_OPTION_AS_ALT")]
    public const string MAC_OPTION_AS_ALT;

    [CCode (cname = "SDL_HINT_MAC_SCROLL_MOMENTUM")]
    public const string MAC_SCROLL_MOMENTUM;

    [CCode (cname = "SDL_HINT_MAIN_CALLBACK_RATE")]
    public const string MAIN_CALLBACK_RATE;

    [CCode (cname = "SDL_HINT_MOUSE_AUTO_CAPTURE")]
    public const string MOUSE_AUTO_CAPTURE;

    [CCode (cname = "SDL_HINT_MOUSE_DEFAULT_SYSTEM_CURSOR")]
    public const string MOUSE_DEFAULT_SYSTEM_CURSOR;

    [CCode (cname = "SDL_HINT_MOUSE_DOUBLE_CLICK_RADIUS")]
    public const string MOUSE_DOUBLE_CLICK_RADIUS;

    [CCode (cname = "SDL_HINT_MOUSE_DOUBLE_CLICK_TIME")]
    public const string MOUSE_DOUBLE_CLICK_TIME;

    [CCode (cname = "SDL_HINT_MOUSE_EMULATE_WARP_WITH_RELATIVE")]
    public const string MOUSE_EMULATE_WARP_WITH_RELATIVE;

    [CCode (cname = "SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH")]
    public const string MOUSE_FOCUS_CLICKTHROUGH;

    [CCode (cname = "SDL_HINT_MOUSE_NORMAL_SPEED_SCALE")]
    public const string MOUSE_NORMAL_SPEED_SCALE;

    [CCode (cname = "SDL_HINT_MOUSE_RELATIVE_CURSOR_VISIBLE")]
    public const string MOUSE_RELATIVE_CURSOR_VISIBLE;

    [CCode (cname = "SDL_HINT_MOUSE_RELATIVE_MODE_CENTER")]
    public const string MOUSE_RELATIVE_MODE_CENTER;

    [CCode (cname = "SDL_HINT_MOUSE_RELATIVE_SPEED_SCALE")]
    public const string MOUSE_RELATIVE_SPEED_SCALE;

    [CCode (cname = "SDL_HINT_MOUSE_RELATIVE_SYSTEM_SCALE")]
    public const string MOUSE_RELATIVE_SYSTEM_SCALE;

    [CCode (cname = "SDL_HINT_MOUSE_RELATIVE_WARP_MOTION")]
    public const string MOUSE_RELATIVE_WARP_MOTION;

    [CCode (cname = "SDL_HINT_MOUSE_TOUCH_EVENTS")]
    public const string MOUSE_TOUCH_EVENTS;

    [CCode (cname = "SDL_HINT_MUTE_CONSOLE_KEYBOARD")]
    public const string MUTE_CONSOLE_KEYBOARD;

    [CCode (cname = "SDL_HINT_NO_SIGNAL_HANDLERS")]
    public const string NO_SIGNAL_HANDLERS;

    [CCode (cname = "SDL_HINT_OPENGL_ES_DRIVER")]
    public const string OPENGL_ES_DRIVER;

    [CCode (cname = "SDL_HINT_OPENGL_LIBRARY")]
    public const string OPENGL_LIBRARY;

    [CCode (cname = "SDL_HINT_OPENVR_LIBRARY")]
    public const string OPENVR_LIBRARY;

    [CCode (cname = "SDL_HINT_ORIENTATIONS")]
    public const string ORIENTATIONS;

    [CCode (cname = "SDL_HINT_PEN_MOUSE_EVENTS")]
    public const string PEN_MOUSE_EVENTS;

    [CCode (cname = "SDL_HINT_PEN_TOUCH_EVENTS")]
    public const string PEN_TOUCH_EVENTS;

    [CCode (cname = "SDL_HINT_POLL_SENTINEL")]
    public const string POLL_SENTINEL;

    [CCode (cname = "SDL_HINT_PREFERRED_LOCALES")]
    public const string PREFERRED_LOCALES;

    [CCode (cname = "SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE")]
    public const string QUIT_ON_LAST_WINDOW_CLOSE;

    [CCode (cname = "SDL_HINT_RENDER_DIRECT3D11_DEBUG")]
    public const string RENDER_DIRECT3D11_DEBUG;

    [CCode (cname = "SDL_HINT_RENDER_DIRECT3D_THREADSAFE")]
    public const string RENDER_DIRECT3D_THREADSAFE;

    [CCode (cname = "SDL_HINT_RENDER_DRIVER")]
    public const string RENDER_DRIVER;

    [CCode (cname = "SDL_HINT_RENDER_GPU_DEBUG")]
    public const string RENDER_GPU_DEBUG;

    [CCode (cname = "SDL_HINT_RENDER_GPU_LOW_POWER")]
    public const string RENDER_GPU_LOW_POWER;

    [CCode (cname = "SDL_HINT_RENDER_LINE_METHOD")]
    public const string RENDER_LINE_METHOD;

    [CCode (cname = "SDL_HINT_RENDER_METAL_PREFER_LOW_POWER_DEVICE")]
    public const string RENDER_METAL_PREFER_LOW_POWER_DEVICE;

    [CCode (cname = "SDL_HINT_RENDER_VSYNC")]
    public const string RENDER_VSYNC;

    [CCode (cname = "SDL_HINT_RENDER_VULKAN_DEBUG")]
    public const string RENDER_VULKAN_DEBUG;

    [CCode (cname = "SDL_HINT_RETURN_KEY_HIDES_IME")]
    public const string RETURN_KEY_HIDES_IME;

    [CCode (cname = "SDL_HINT_ROG_GAMEPAD_MICE")]
    public const string ROG_GAMEPAD_MICE;

    [CCode (cname = "SDL_HINT_ROG_GAMEPAD_MICE_EXCLUDED")]
    public const string ROG_GAMEPAD_MICE_EXCLUDED;

    [CCode (cname = "SDL_HINT_RPI_VIDEO_LAYER")]
    public const string RPI_VIDEO_LAYER;

    [CCode (cname = "SDL_HINT_SCREENSAVER_INHIBIT_ACTIVITY_NAME")]
    public const string SCREENSAVER_INHIBIT_ACTIVITY_NAME;

    [CCode (cname = "SDL_HINT_SHUTDOWN_DBUS_ON_QUIT")]
    public const string SHUTDOWN_DBUS_ON_QUIT;

    [CCode (cname = "SDL_HINT_STORAGE_TITLE_DRIVER")]
    public const string STORAGE_TITLE_DRIVER;

    [CCode (cname = "SDL_HINT_STORAGE_USER_DRIVER")]
    public const string STORAGE_USER_DRIVER;

    [CCode (cname = "SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL")]
    public const string THREAD_FORCE_REALTIME_TIME_CRITICAL;

    [CCode (cname = "SDL_HINT_THREAD_PRIORITY_POLICY")]
    public const string THREAD_PRIORITY_POLICY;

    [CCode (cname = "SDL_HINT_TIMER_RESOLUTION")]
    public const string TIMER_RESOLUTION;

    [CCode (cname = "SDL_HINT_TOUCH_MOUSE_EVENTS")]
    public const string TOUCH_MOUSE_EVENTS;

    [CCode (cname = "SDL_HINT_TRACKPAD_IS_TOUCH_ONLY")]
    public const string TRACKPAD_IS_TOUCH_ONLY;

    [CCode (cname = "SDL_HINT_TV_REMOTE_AS_JOYSTICK")]
    public const string TV_REMOTE_AS_JOYSTICK;

    [CCode (cname = "SDL_HINT_VIDEO_ALLOW_SCREENSAVER")]
    public const string VIDEO_ALLOW_SCREENSAVER;

    [CCode (cname = "SDL_HINT_VIDEO_DISPLAY_PRIORITY")]
    public const string VIDEO_DISPLAY_PRIORITY;

    [CCode (cname = "SDL_HINT_VIDEO_DOUBLE_BUFFER")]
    public const string VIDEO_DOUBLE_BUFFER;

    [CCode (cname = "SDL_HINT_VIDEO_DRIVER")]
    public const string VIDEO_DRIVER;

    [CCode (cname = "SDL_HINT_VIDEO_DUMMY_SAVE_FRAMES")]
    public const string VIDEO_DUMMY_SAVE_FRAMES;

    [CCode (cname = "SDL_HINT_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK")]
    public const string VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK;

    [CCode (cname = "SDL_HINT_VIDEO_FORCE_EGL")]
    public const string VIDEO_FORCE_EGL;

    [CCode (cname = "SDL_HINT_VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY")]
    public const string VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY;

    [CCode (cname = "SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES")]
    public const string VIDEO_MAC_FULLSCREEN_SPACES;

    [CCode (cname = "SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS")]
    public const string VIDEO_MINIMIZE_ON_FOCUS_LOSS;

    [CCode (cname = "SDL_HINT_VIDEO_OFFSCREEN_SAVE_FRAMES")]
    public const string VIDEO_OFFSCREEN_SAVE_FRAMES;

    [CCode (cname = "SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS")]
    public const string VIDEO_SYNC_WINDOW_OPERATIONS;

    [CCode (cname = "SDL_HINT_VIDEO_WAYLAND_ALLOW_LIBDECOR")]
    public const string VIDEO_WAYLAND_ALLOW_LIBDECOR;

    [CCode (cname = "SDL_HINT_VIDEO_WAYLAND_MODE_EMULATION")]
    public const string VIDEO_WAYLAND_MODE_EMULATION;

    [CCode (cname = "SDL_HINT_VIDEO_WAYLAND_MODE_SCALING")]
    public const string VIDEO_WAYLAND_MODE_SCALING;

    [CCode (cname = "SDL_HINT_VIDEO_WAYLAND_PREFER_LIBDECOR")]
    public const string VIDEO_WAYLAND_PREFER_LIBDECOR;

    [CCode (cname = "SDL_HINT_VIDEO_WAYLAND_SCALE_TO_DISPLAY")]
    public const string VIDEO_WAYLAND_SCALE_TO_DISPLAY;

    [CCode (cname = "SDL_HINT_VIDEO_WIN_D3DCOMPILER")]
    public const string VIDEO_WIN_D3DCOMPILER;

    [CCode (cname = "SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR")]
    public const string VIDEO_X11_NET_WM_BYPASS_COMPOSITOR;

    [CCode (cname = "SDL_HINT_VIDEO_X11_NET_WM_PING")]
    public const string VIDEO_X11_NET_WM_PING;

    [CCode (cname = "SDL_HINT_VIDEO_X11_NET_WM_PING")]
    public const string VIDEO_X11_NODIRECTCOLOR;

    [CCode (cname = "SDL_HINT_VIDEO_X11_SCALING_FACTOR")]
    public const string VIDEO_X11_SCALING_FACTOR;

    [CCode (cname = "SDL_HINT_VIDEO_X11_VISUALID")]
    public const string VIDEO_X11_VISUALID;

    [CCode (cname = "SDL_HINT_VIDEO_X11_WINDOW_VISUALID")]
    public const string VIDEO_X11_WINDOW_VISUALID;

    [CCode (cname = "SDL_HINT_VIDEO_X11_XRANDR")]
    public const string VIDEO_X11_XRANDR;

    [CCode (cname = "SDL_HINT_VITA_ENABLE_BACK_TOUCH")]
    public const string VITA_ENABLE_BACK_TOUCH;

    [CCode (cname = "SDL_HINT_VITA_ENABLE_FRONT_TOUCH")]
    public const string VITA_ENABLE_FRONT_TOUCH;

    [CCode (cname = "SDL_HINT_VITA_MODULE_PATH")]
    public const string VITA_MODULE_PATH;

    [CCode (cname = "SDL_HINT_VITA_PVR_INIT")]
    public const string VITA_PVR_INIT;

    [CCode (cname = "SDL_HINT_VITA_PVR_OPENGL")]
    public const string VITA_PVR_OPENGL;

    [CCode (cname = "SDL_HINT_VITA_RESOLUTION")]
    public const string VITA_RESOLUTION;

    [CCode (cname = "SDL_HINT_VITA_TOUCH_MOUSE_DEVICE")]
    public const string VITA_TOUCH_MOUSE_DEVICE;

    [CCode (cname = "SDL_HINT_VULKAN_DISPLAY")]
    public const string VULKAN_DISPLAY;

    [CCode (cname = "SDL_HINT_VULKAN_LIBRARY")]
    public const string VULKAN_LIBRARY;

    [CCode (cname = "SDL_HINT_WAVE_CHUNK_LIMIT")]
    public const string WAVE_CHUNK_LIMIT;

    [CCode (cname = "SDL_HINT_WAVE_FACT_CHUNK")]
    public const string WAVE_FACT_CHUNK;

    [CCode (cname = "SDL_HINT_WAVE_RIFF_CHUNK_SIZE")]
    public const string WAVE_RIFF_CHUNK_SIZE;

    [CCode (cname = "SDL_HINT_WAVE_TRUNCATION")]
    public const string WAVE_TRUNCATION;

    [CCode (cname = "SDL_HINT_WINDOW_ACTIVATE_WHEN_RAISED")]
    public const string WINDOW_ACTIVATE_WHEN_RAISED;

    [CCode (cname = "SDL_HINT_WINDOW_ACTIVATE_WHEN_SHOWN")]
    public const string WINDOW_ACTIVATE_WHEN_SHOWN;

    [CCode (cname = "SDL_HINT_WINDOW_ALLOW_TOPMOST")]
    public const string WINDOW_ALLOW_TOPMOST;

    [CCode (cname = "SDL_HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN")]
    public const string WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN;

    [CCode (cname = "SDL_HINT_WINDOWS_CLOSE_ON_ALT_F4")]
    public const string WINDOWS_CLOSE_ON_ALT_F4;

    [CCode (cname = "SDL_HINT_WINDOWS_ENABLE_MENU_MNEMONICS")]
    public const string WINDOWS_ENABLE_MENU_MNEMONICS;

    [CCode (cname = "SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP")]
    public const string WINDOWS_ENABLE_MESSAGELOOP;

    [CCode (cname = "SDL_HINT_WINDOWS_ERASE_BACKGROUND_MODE")]
    public const string WINDOWS_ERASE_BACKGROUND_MODE;

    [CCode (cname = "SDL_HINT_WINDOWS_FORCE_SEMAPHORE_KERNEL")]
    public const string WINDOWS_FORCE_SEMAPHORE_KERNEL;

    [CCode (cname = "SDL_HINT_WINDOWS_GAMEINPUT")]
    public const string WINDOWS_GAMEINPUT;

    [CCode (cname = "SDL_HINT_WINDOWS_INTRESOURCE_ICON")]
    public const string WINDOWS_INTRESOURCE_ICON;

    [CCode (cname = "SDL_HINT_WINDOWS_INTRESOURCE_ICON_SMALL")]
    public const string WINDOWS_INTRESOURCE_ICON_SMALL;

    [CCode (cname = "SDL_HINT_WINDOWS_RAW_KEYBOARD")]
    public const string WINDOWS_RAW_KEYBOARD;

    [CCode (cname = "SDL_HINT_WINDOWS_USE_D3D9EX")]
    public const string WINDOWS_USE_D3D9EX;

    [CCode (cname = "SDL_HINT_X11_FORCE_OVERRIDE_REDIRECT")]
    public const string X11_FORCE_OVERRIDE_REDIRECT;

    [CCode (cname = "SDL_HINT_X11_WINDOW_TYPE")]
    public const string X11_WINDOW_TYPE;

    [CCode (cname = "SDL_HINT_X11_XCB_LIBRARY")]
    public const string X11_XCB_LIBRARY;

    [CCode (cname = "SDL_HINT_XINPUT_ENABLED")]
    public const string XINPUT_ENABLED;
} // SDL.Hints

///
/// Object Properties (SDL_properties.h)
///
[CCode (cheader_filename = "SDL3/SDL_properties.h")]
namespace SDL.Properties {
    [CCode (cname = "SDL_ClearProperty")]
    public bool clear_property (PropertiesID props, string name);

    [CCode (cname = "SDL_CopyProperties")]
    public bool copy_properties (PropertiesID src, PropertiesID dst);

    [CCode (cname = "SDL_CreateProperties")]
    public static PropertiesID create_properties ();

    [CCode (cname = "SDL_DestroyProperties")]
    public static bool destroy_properties (PropertiesID props);

    [CCode (cname = "SDL_EnumerateProperties")]
    public static bool enumerate_properties (PropertiesID props, EnumeratePropertiesCallback callback);

    [CCode (cname = "SDL_GetBooleanProperty")]
    public static bool get_boolean_property (PropertiesID props, string name, bool default_value);

    [CCode (cname = "SDL_GetFloatProperty")]
    public static float get_float_property (PropertiesID props, string name, float default_value);

    [CCode (cname = "SDL_GetNumberProperty")]
    public int64 get_number_property (PropertiesID props, string name, int64 default_value);

    [CCode (cname = "SDL_GetGlobalProperties")]
    public static PropertiesID get_global_properties ();

    [CCode (cname = "SDL_GetPointerProperty")]
    public static void * get_pointer_property (PropertiesID props, string name, void* default_value);

    [CCode (cname = "SDL_GetPropertyType")]
    public PropertyType get_property_type (PropertiesID props, string name);

    [CCode (cname = "SDL_GetStringProperty")]
    public unowned string ? get_string_property (PropertiesID props, string name, string? default_value);

    [CCode (cname = "SDL_HasProperty")]
    public bool has_property (PropertiesID props, string name);

    [CCode (cname = "SDL_LockProperties")]
    public bool lock_properties (PropertiesID props);

    [CCode (cname = "SDL_SetBooleanProperty")]
    public bool set_boolean_property (PropertiesID props, string name, bool value);

    [CCode (cname = "SDL_SetFloatProperty")]
    public bool set_float_property (PropertiesID props, string name, float value);

    [CCode (cname = "SDL_SetNumberProperty")]
    public bool set_number_property (PropertiesID props, string name, int64 value);

    [CCode (cname = "SDL_SetPointerProperty")]
    public bool set_pointer_property (PropertiesID props, string name, void* value);

    [CCode (cname = "SDL_SetPointerPropertyWithCleanup", has_target = true)]
    public bool set_pointer_property_with_cleanup (PropertiesID props, string name, void* value,
        CleanupPropertyCallback? cleanup);

    [CCode (cname = "SDL_SetStringProperty")]
    public bool set_string_property (PropertiesID props, string name, string? value);

    [CCode (cname = "SDL_UnlockProperties")]
    public void unlock_properties (PropertiesID props);

    [CCode (cname = "SDL_CleanupPropertyCallback", has_target = true, instance_pos = 0)]
    public delegate void CleanupPropertyCallback (void* value);

    [CCode (cname = "SDL_EnumeratePropertiesCallback", has_target = true, instance_pos = 0)]
    public delegate void EnumeratePropertiesCallback (PropertiesID props, string name);

    [SimpleType, CCode (cname = "SDL_PropertiesID", has_type_id = false)]
    public struct PropertiesID : uint32 {}

    [CCode (cname = "SDL_PropertyType", cprefix = "SDL_PROPERTY_TYPE_", has_type_id = false)]
    public enum PropertyType {
        INVALID,
        POINTER,
        STRING,
        NUMBER,
        FLOAT,
        BOOLEAN
    } // PropertyType
} // SDL.Properties

///
/// Error Handling (SDL_error.h)
///
[CCode (cheader_filename = "SDL3/SDL_error.h")]
namespace SDL.Error {
    [CCode (cname = "SDL_ClearError")]
    public static bool clear_error ();

    [CCode (cname = "SDL_GetError")]
    public static unowned string get_error ();

    [CCode (cname = "SDL_OutOfMemory")]
    public static bool out_of_memory ();

    [CCode (cname = "SDL_SetError")]
    public static bool set_error (string format, ...);

    [CCode (cname = "SDL_InvalidParamError")]
    public static bool invalid_param_error (string param);

    [CCode (cname = "SDL_Unsupported")]
    public static bool unsupported ();
} // SDL.Error

///
/// Log Handling (SDL_log.h)
///
[CCode (cheader_filename = "SDL3/SDL_log.h")]
namespace SDL.Log {
    [CCode (cname = "SDL_GetDefaultLogOutputFunction")]
    public static LogOutputFunction get_default_log_ouput_function ();

    [CCode (cname = "SDL_GetLogOutputFunction")]
    public static void get_log_output_function (LogOutputFunction callback);

    [CCode (cname = "SDL_GetLogPriority")]
    public static LogPriority get_log_priority (LogCategory category);

    [CCode (cname = "SDL_Log")]
    public static void log (string fmt, ...);

    [CCode (cname = "SDL_LogCritical")]
    public static void log_critical (LogCategory category, string fmt, ...);

    [CCode (cname = "SDL_LogDebug")]
    public static void log_debug (LogCategory category, string fmt, ...);

    [CCode (cname = "SDL_LogError")]
    public static void log_error (LogCategory category, string fmt, ...);

    [CCode (cname = "SDL_LogInfo")]
    public static void log_info (LogCategory category, string fmt, ...);

    [CCode (cname = "SDL_LogMessage")]
    public static void log_message (LogCategory category, LogPriority priority, string fmt, ...);

    [CCode (cname = "SDL_LogTrace")]
    public static void log_trace (LogCategory category, string fmt, ...);

    [CCode (cname = "SDL_LogVerbose")]
    public static void log_verbose (LogCategory category, string fmt, ...);

    [CCode (cname = "SDL_LogWarn")]
    public static void log_warn (LogCategory category, string fmt, ...);

    [CCode (cname = "SDL_ResetLogPriorities")]
    public static void reset_log_priorities ();

    [CCode (cname = "SDL_SetLogOutputFunction", has_target = true)]
    public static void set_log_ouput_function (LogOutputFunction callback);

    [CCode (cname = "SDL_SetLogPriorities")]
    public static void set_log_priorities (LogPriority priority);

    [CCode (cname = "SDL_SetLogPriority")]
    public static void set_log_priority (LogCategory category, LogPriority priority);

    [CCode (cname = "SDL_SetLogPriorityPrefix")]
    public static void set_log_priority_prefix (LogPriority priority, string? prefix);

    [CCode (cname = "SDL_LogOutputFunction", has_target = true, instance_pos = 0)]
    public delegate void LogOutputFunction (LogCategory category, LogPriority priority, string message);

    [CCode (cname = "SDL_LogCategory", cprefix = "SDL_LOG_CATEGORY_", has_type_id = false)]
    public enum LogCategory {
        APPLICATION,
        ERROR,
        ASSERT,
        SYSTEM,
        AUDIO,
        VIDEO,
        RENDER,
        INPUT,
        TEST,
        GPU,
        RESERVED2,
        RESERVED3,
        RESERVED4,
        RESERVED5,
        RESERVED6,
        RESERVED7,
        RESERVED8,
        RESERVED9,
        RESERVED10,
        /* Beyond this point is reserved for application use, e.g.
            enum {
            MYAPP_CATEGORY_AWESOME1 = SDL_LOG_CATEGORY_CUSTOM,
            MYAPP_CATEGORY_AWESOME2,
            MYAPP_CATEGORY_AWESOME3,
            ...
            }; */
        CUSTOM
    } // LogCategory

    [CCode (cname = "SDL_LogPriority", cprefix = "SDL_LOG_PRIORITY_", has_type_id = false)]
    public enum LogPriority {
        INVALID,
        TRACE,
        VERBOSE,
        DEBUG,
        INFO,
        WARN,
        ERROR,
        CRITICAL,
        COUNT
    } // LogPriority
} // SDL.Log

///
/// Assertions (SDL_assert.h)
///
[CCode (cheader_filename = "SDL3/SDL_assert.h")]
namespace SDL.Assert {
    [CCode (cname = "SDL_GetAssertionHandler")]
    public static AssertionHandler get_assertion_handler ();

    [CCode (cname = "SDL_GetAssertionReport")]
    public static unowned AssertData ? get_assertion_report ();

    [CCode (cname = "SDL_GetDefaultAssertionHandler")]
    public static unowned AssertionHandler get_default_assertion_handler ();

    [CCode (cname = "SDL_ReportAssertion")]
    public static AssertState report_assertion (AssertData data, string func, string file, int line);

    [CCode (cname = "SDL_SetAssertionHandler", has_target = true)]
    public static void set_assertion_handler (AssertionHandler? handler);

    [CCode (cname = "SDL_ResetAssertionReport")]
    public static void reset_assertion_report ();

    [CCode (cname = "SDL_AssertionHandler", has_target = true)]
    public delegate AssertState AssertionHandler (AssertData data);

    [CCode (cname = "SDL_AssertData", has_type_id = false)]
    public struct AssertData {
        public bool always_ignore;
        public uint trigger_count;
        public string condition;
        public string filename;
        public int linenum;
        public string function;
        public AssertData* next;
    } // AssertData

    [CCode (cname = "SDL_AssertState", cprefix = "SDL_ASSERTION_", has_type_id = false)]
    public enum AssertState {
        RETRY,
        BREAK,
        ABORT,
        IGNORE,
        ALWAYS_IGNORE
    } // AssertState

    [CCode (cname = "SDL_assert")]
    public static void assert (bool x);

    [CCode (cname = "SDL_assert_always")]
    public static void assert_always (bool x);

    [CCode (cname = "SDL_ASSERT_LEVEL")]
    public const int ASSERT_LEVEL;

    [CCode (cname = "SDL_assert_paranoid")]
    public static void assert_paranoid (bool x);

    [CCode (cname = "SDL_assert_release")]
    public static bool assert_release (bool x);
} // SDL.Assert

///
/// Querying SDL Version (SDL_version.h)
///
[CCode (cheader_filename = "SDL3/SDL_version.h")]
namespace SDL.Version {
    [CCode (cname = "SDL_GetRevision")]
    public static unowned string get_revision ();

    [CCode (cname = "SDL_GetVersion")]
    public static unowned int get_version ();

    [CCode (cname = "SDL_MAJOR_VERSION")]
    public const int MAJOR;

    [CCode (cname = "SDL_MINOR_VERSION")]
    public const int MINOR;

    [CCode (cname = "SDL_MICRO_VERSION")]
    public const int MICRO;

    [CCode (cname = "SDL_VERSION")]
    public const int VERSION;

    [CCode (cname = "SDL_VERSIONNUM_MAJOR")]
    public static int version_num_major (int version);

    [CCode (cname = "SDL_VERSIONNUM_MINOR")]
    public static int version_num_minor (int version);

    [CCode (cname = "SDL_VERSIONNUM_MICRO")]
    public static int version_num_micro (int version);

    [CCode (cname = "SDL_VERSIONNUM")]
    public static int version_num (int major, int minor, int micro);

    [CCode (cname = "SDL_VERSION_ATLEAST")]
    public static bool sdl_version_at_least (int major, int minor, int micro);
} // SDL.Version

///
/// Querying SDL Version (SDL_revision.h)
///
[CCode (cheader_filename = "SDL3/SDL_revision.h")]
namespace SDL.Revision {
    [CCode (cname = "SDL_REVISION")]
    public const string REVISION;
} // SDL.Revision

///
/// VIDEO
///

///
/// Display and Window Management (SDL_video.h)
///
[CCode (cheader_filename = "SDL3/SDL_video.h")]
namespace SDL.Video {
    [CCode (cname = "SDL_CreatePopupWindow")]
    public static Window ? create_popup_window (Window parent,
        int offset_x,
        int offset_y,
        int w,
        int h,
        WindowFlags flags);

    [CCode (cname = "SDL_CreateWindow")]
    public static Window ? create_window (string title, int w, int h, WindowFlags flags);

    [CCode (cname = "SDL_CreateWindowWithProperties")]
    public static Window ? create_window_with_properties (Properties.PropertiesID props);

    [CCode (cname = "SDL_DestroyWindow")]
    public static void destroy_window (Window window);

    [CCode (cname = "SDL_DestroyWindowSurface")]
    public static bool destroy_window_surface (Window window);

    [CCode (cname = "SDL_DisableScreenSaver")]
    public static bool disable_screen_saver ();

    [CCode (cname = "SDL_EGL_GetCurrentConfig")]
    public static EGLConfig ? egl_get_current_config ();

    [CCode (cname = "SDL_EGL_GetCurrentDisplay")]
    public static EGLDisplay ? egl_get_current_display ();

    [CCode (cname = "SDL_EGL_GetProcAddress")]
    public static StdInc.FunctionPointer egl_get_proc_address (string proc);

    [CCode (cname = "SDL_EGL_GetWindowSurface")]
    public static EGLSurface ? egl_get_window_surface (Window window);

    [CCode (cname = "SDL_EGL_SetAttributeCallbacks", has_target = true)]
    public delegate void egl_set_attribute_callbacks (EGLAttribArrayCallback? platform_attrib_callback,
        EGLIntArrayCallback? surface_attrib_callback,
        EGLIntArrayCallback? context_attrib_callback);

    [CCode (cname = "SDL_EnableScreenSaver")]
    public static bool enable_screen_saver ();

    [CCode (cname = "SDL_FlashWindow")]
    public static bool flash_window (Window window, FlashOperation operation);

    [CCode (cname = "SDL_GetClosestFullscreenDisplayMode")]
    public static bool get_closest_fullscreen_display_mode (DisplayID display_id,
        int w,
        int h,
        float refresh_rate,
        bool include_high_density_modes,
        out DisplayMode closest);

    [CCode (cname = "SDL_GetCurrentDisplayMode")]
    public static DisplayMode ? get_current_display_mode (DisplayID display_id);

    [CCode (cname = "SDL_GetCurrentDisplayOrientation")]
    public static DisplayOrientation get_current_display_orientation (DisplayID display_id);

    [CCode (cname = "SDL_GetCurrentVideoDriver")]
    public static unowned string ? get_current_video_driver ();

    [CCode (cname = "SDL_GetDesktopDisplayMode")]
    public static DisplayMode ? get_desktop_display_mode (DisplayID display_id);

    [CCode (cname = "SDL_GetDisplayBounds")]
    public static bool get_display_bounds (DisplayID display_id, out Rect.Rect rect);

    [CCode (cname = "SDL_GetDisplayContentScale")]
    public static float get_display_content_scale (DisplayID display_id);

    [CCode (cname = "SDL_GetDisplayForPoint")]
    public static DisplayID get_display_for_point (Rect.Point point);

    [CCode (cname = "SDL_GetDisplayForRect")]
    public static DisplayID get_display_for_rect (Rect.Rect rect);

    [CCode (cname = "SDL_GetDisplayForWindow")]
    public static DisplayID get_display_for_window (Window window);

    [CCode (cname = "SDL_GetDisplayName")]
    public static unowned string ? get_display_name (DisplayID display_id);

    [CCode (cname = "SDL_GetDisplayProperties")]
    public static Properties.PropertiesID get_display_properties (DisplayID display_id);

    [CCode (cname = "SDL_GetDisplays")]
    public static DisplayID[] ? get_displays ();

    [CCode (cname = "SDL_GetDisplayUsableBounds")]
    public static bool get_display_usable_bounds (DisplayID display_id, out Rect.Rect rect);

    [CCode (cname = "SDL_GetFullscreenDisplayModes")]
    public static DisplayMode[] ? get_fullscreen_display_modes (DisplayID display_id);

    [CCode (cname = "SDL_GetGrabbedWindow")]
    public static Window ? get_grabbed_window ();

    [CCode (cname = "SDL_GetNaturalDisplayOrientation")]
    public static DisplayOrientation get_natural_display_orientation (DisplayID display_id);

    [CCode (cname = "SDL_GetNumVideoDrivers")]
    public static int get_num_video_drivers ();

    [CCode (cname = "SDL_GetPrimaryDisplay")]
    public static DisplayID get_primary_display ();

    [CCode (cname = "SDL_GetSystemTheme")]
    public static SystemTheme get_sytem_theme ();

    [CCode (cname = "SDL_GetVideoDriver")]
    public static unowned string get_video_driver (int index);

    [CCode (cname = "SDL_GetWindowAspectRatio")]
    public static bool get_window_aspect_ratio (Window window, out float min_aspect, out float max_aspect);

    [CCode (cname = "SDL_GetWindowBordersSize")]
    public static bool get_window_borders_size (Window window,
        out int top,
        out int left,
        out int bottom,
        out int right);

    [CCode (cname = "SDL_GetWindowDisplayScale")]
    public static float get_window_display_scale (Window window);

    [CCode (cname = "SDL_GetWindowFlags")]
    public static WindowFlags get_window_flags (Window window);

    [CCode (cname = "SDL_GetWindowFromID")]
    public static Window ? get_window_from_id (WindowID id);

    [CCode (cname = "SDL_GetWindowFullscreenMode")]
    public static DisplayMode ? get_window_fullscreen_mode (Window window);

    [CCode (cname = "SDL_GetWindowICCProfile")]
    public static void * get_window_icc_profile (Window window, size_t size);

    [CCode (cname = "SDL_GetWindowID")]
    public static WindowID get_window_id (Window window);

    [CCode (cname = "SDL_GetWindowKeyboardGrab")]
    public static bool get_window_keyboard_grab (Window window);

    [CCode (cname = "SDL_GetWindowMaximumSize")]
    public static bool get_window_maximum_size (Window window, out int w, out int h);

    [CCode (cname = "SDL_GetWindowMinimumSize")]
    public static bool get_window_minimum_size (Window window, out int w, out int h);

    [CCode (cname = "SDL_GetWindowMouseGrab")]
    public static bool get_window_mouse_grab (Window window);

    [CCode (cname = "SDL_GetWindowMouseRect")]
    public static Rect.Rect ? get_window_mouse_rect (Window window);

    [CCode (cname = "SDL_GetWindowOpacity")]
    public static float get_window_opacity (Window window);

    [CCode (cname = "SDL_GetWindowParent")]
    public static Window ? get_window_parent (Window window);

    [CCode (cname = "SDL_GetWindowPixelDensity")]
    public static float get_window_pixel_density (Window window);

    [CCode (cname = "SDL_GetWindowPixelFormat")]
    public static Pixels.PixelFormat get_window_pixel_format (Window window);

    [CCode (cname = "SDL_GetWindowPosition")]
    public static bool get_window_position (Window window, out int x, out int y);

    [CCode (cname = "SDL_GetWindowProperties")]
    public static Properties.PropertiesID get_window_properties (Window window);

    [CCode (cname = "SDL_GetWindows")]
    public static unowned Window[] ? get_windows ();

    [CCode (cname = "SDL_GetWindowSafeArea")]
    public static bool get_window_safe_area (Window window, out Rect.Rect rect);

    [CCode (cname = "SDL_GetWindowSize")]
    public static bool get_window_size (Window window, out int w, out int h);

    [CCode (cname = "SDL_GetWindowSizeInPixels")]
    public static bool get_window_size_in_pixels (Window window, out int w, out int h);

    [CCode (cname = "SDL_GetWindowSurface")]
    public static Surface.Surface ? get_window_surface (Window window);

    [CCode (cname = "SDL_GetWindowSurfaceVSync")]
    public static bool get_window_surface_vsync (Window window, out int vsync);

    [CCode (cname = "SDL_GetWindowTitle")]
    public static unowned string get_window_title (Window window);

    [CCode (cname = "SDL_GL_CreateContext")]
    public static GLContext ? gl_create_context (Window window);

    [CCode (cname = "SDL_GL_DestroyContext")]
    public static bool gl_destroy_context (GLContext context);

    [CCode (cname = "SDL_GL_ExtensionSupported")]
    public static bool gl_extension_supported (string extension);

    [CCode (cname = "SDL_GL_GetAttribute")]
    public static bool gl_get_attribute (GLAttr attr, out int value);

    [CCode (cname = "SDL_GL_GetCurrentContext")]
    public static GLContext ? gl_get_current_context ();

    [CCode (cname = "SDL_GL_GetCurrentWindow")]
    public static Window ? gl_get_current_window ();

    [CCode (cname = "SDL_GL_GetProcAddress")]
    public static StdInc.FunctionPointer gl_get_proc_address (string proc);

    [CCode (cname = "SDL_GL_GetSwapInterval")]
    public static bool gl_get_swap_interval (out int interval);

    [CCode (cname = "SDL_GL_LoadLibrary")]
    public static bool gl_load_library (string path);

    [CCode (cname = "SDL_GL_MakeCurrent")]
    public static bool gl_make_curent (Window window, GLContext context);

    [CCode (cname = "SDL_GL_ResetAttributes")]
    public static void gl_reset_attribute ();

    [CCode (cname = "SDL_GL_SetAttribute")]
    public static bool gl_reset_attributes (GLAttr attr, int value);

    [CCode (cname = "SDL_GL_SetSwapInterval")]
    public static bool gl_set_swap_interval (int interval);

    [CCode (cname = "SDL_GL_SwapWindow")]
    public static bool gl_swap_window (Window window);

    [CCode (cname = "SDL_GL_UnloadLibrary")]
    public static void gl_unload_library ();

    [CCode (cname = "SDL_HideWindow")]
    public static bool hide_window (Window window);

    [CCode (cname = "SDL_MaximizeWindow")]
    public static bool maximize_window (Window window);

    [CCode (cname = "SDL_MinimizeWindow")]
    public static bool minimize_window (Window window);

    [CCode (cname = "SDL_RaiseWindow")]
    public static bool raise_window (Window window);

    [CCode (cname = "SDL_RestoreWindow")]
    public static bool restore_window (Window window);

    [CCode (cname = "SDL_ScreenSaverEnabled")]
    public static bool screen_saver_enabled ();

    [CCode (cname = "SDL_SetWindowAlwaysOnTop")]
    public static bool set_window_always_on_top (Window window, bool on_top);

    [CCode (cname = "SDL_SetWindowAspectRatio")]
    public static bool set_window_aspect_ratio (Window window, float min_aspect, float max_aspect);

    [CCode (cname = "SDL_SetWindowBordered")]
    public static bool set_window_bordered (Window window, bool bordered);

    [CCode (cname = "SDL_SetWindowFocusable")]
    bool set_window_focusable (Window window, bool focusable);

    [CCode (cname = "SDL_SetWindowFullscreen")]
    public static bool set_window_fullscreen (Window window, bool fullscreen);

    [CCode (cname = "SDL_SetWindowFullscreenMode")]
    public static bool set_window_fullscreen_mode (Window window, DisplayMode? mode);

    [CCode (cname = "SDL_SetWindowHitTest", has_target = true)]
    public static bool set_window_hit_test (Window window, HitTest? callback);

    [CCode (cname = "SDL_SetWindowIcon")]
    public static bool set_window_icon (Window window, Surface.Surface icon);

    [CCode (cname = "SDL_SetWindowKeyboardGrab")]
    public static bool set_window_kayboard_grab (Window window, bool grabbed);

    [CCode (cname = "SDL_SetWindowMaximumSize")]
    public static bool set_window_maximum_size (Window window, int max_w, int max_h);

    [CCode (cname = "SDL_SetWindowMinimumSize")]
    public static bool set_window_minimum_size (Window window, int min_w, int min_h);

    [CCode (cname = "SDL_SetWindowModal")]
    public static bool set_window_modla (Window window, bool modal);

    [CCode (cname = "SDL_SetWindowMouseGrab")]
    public static bool set_window_mouse_grab (Window window, bool grabbed);

    [CCode (cname = "SDL_SetWindowMouseRect")]
    public static bool set_window_mouse_rect (Window window, Rect.Rect? rect);

    [CCode (cname = "SDL_SetWindowOpacity")]
    public static bool set_window_opacity (Window window, float opacity);

    [CCode (cname = "SDL_SetWindowParent")]
    public static bool set_window_parent (Window window, Window? parent);

    [CCode (cname = "SDL_SetWindowPosition")]
    public static bool set_window_position (Window window, int x, int y);

    [CCode (cname = "SDL_SetWindowResizable")]
    public static bool set_window_resizable (Window window, bool resizable);

    [CCode (cname = "SDL_SetWindowShape")]
    public static bool set_window_shape (Window window, Surface.Surface? shape);

    [CCode (cname = "SDL_SetWindowSize")]
    public static bool set_window_size (Window window, int w, int h);

    [CCode (cname = "SDL_SetWindowSurfaceVSync")]
    public static bool set_window_surface_vsync (Window window, int vsync);

    [CCode (cname = "SDL_SetWindowTitle")]
    public static bool set_window_title (Window window, string title);

    [CCode (cname = "SDL_ShowWindow")]
    public static bool show_window (Window window);

    [CCode (cname = "SDL_ShowWindowSystemMenu")]
    public static bool show_window_system_menu (Window window, int x, int y);

    [CCode (cname = "SDL_SyncWindow")]
    public static bool sync_window (Window window);

    [CCode (cname = "SDL_UpdateWindowSurface")]
    public static bool update_window_surface (Window window);

    [CCode (cname = "SDL_UpdateWindowSurfaceRects")]
    public static bool update_window_surface_rects (Window window, Rect.Rect[] rects);

    [CCode (cname = "SDL_WindowHasSurface")]
    public static bool window_has_surface (Window window);

    [SimpleType, CCode (cname = "SDL_DisplayID", has_type_id = false)]
    public struct DisplayID : uint32 {}

    [CCode (cname = "SDL_DisplayModeData", has_type_id = false)]
    public struct DisplayModeData {}

    [CCode (cname = "SDL_EGLAttrib")]
    public struct EGLAttrib {}

    [CCode (cname = "SDL_EGLAttribArrayCallback", has_target = true)]
    public delegate EGLAttrib EGLAttribArrayCallback ();

    [CCode (cname = "SDL_EGLConfig", has_type_id = false)]
    public struct EGLConfig {}

    [CCode (cname = "SDL_EGLDisplay", has_type_id = false)]
    public struct EGLDisplay {}

    [SimpleType, CCode (cname = "SDL_EGLint", has_type_id = false)]
    public struct EGLint : int {}

    [CCode (cname = "SDL_EGLIntArrayCallback", has_target = true, instance_pos = 0)]
    public delegate EGLint[] EGLIntArrayCallback (EGLDisplay display, EGLConfig config);

    [CCode (cname = "SDL_EGLSurface", has_type_id = false)]
    public struct EGLSurface {}

    [Compact, CCode (cname = "SDL_GLContext", free_function = "", has_type_id = false)]
    public class GLContext {}

    [SimpleType, CCode (cname = "SDL_GLContextFlag", has_type_id = false)]
    public struct GLContextFlag : uint32 {}

    [CCode (cname = "int", cprefix = "SDL_GL_CONTEXT_", has_type_id = false)]
    public enum GLContextFlags {
        DEBUG_FLAG,
        FORWARD_COMPATIBLE_FLAG,
        ROBUST_ACCESS_FLAG,
        RESET_ISOLATION_FLAG
    } // GLContextFlags

    [SimpleType, CCode (cname = "SDL_GLContextReleaseFlag", has_type_id = false)]
    public struct GLContextReleaseFlag : uint32 {}

    [CCode (cname = "int", cprefix = "SDL_GL_CONTEXT_RELEASE_", has_type_id = false)]
    public enum GLContextReleaseFlags {
        BEHAVIOR_NONE,
        BEHAVIOR_FLUSH,
    } // GlContextReleaseFlags

    [SimpleType, CCode (cname = "SDL_GLContextResetNotification", has_type_id = false)]
    public struct GLContextResetNotification : uint32 {}

    [CCode (cname = "int", cprefix = "SDL_GL_CONTEXT_RESET_", has_type_id = false)]
    public enum GLContextResetNotifications {
        NO_NOTIFICATION,
        LOSE_CONTEXT,
    } // GLContextResetNotifications

    [SimpleType, CCode (cname = "SDL_GLProfile", has_type_id = false)]
    public struct GLProfile : uint32 {}

    [CCode (cname = "int", cprefix = "SDL_GL_CONTEXT_PROFILE_", has_type_id = false)]
    public enum GLProfiles {
        CORE,
        COMPATIBILITY,
        ES,
    } // GLProfiles

    [CCode (cname = "SDL_HitTest", has_target = true)]
    public delegate HitTestResult HitTest (EGLDisplay display, EGLConfig config);

    [Compact, CCode (cname = "SDL_Window", free_function = "", has_type_id = false)]
    public class Window {}

    [Flags, CCode (cname = "int", cprefix = "SDL_WINDOW_", has_type_id = false)]
    public enum WindowFlags {
        FULLSCREEN,
        OPENGL,
        OCCLUDED,
        HIDDEN,
        BORDERLESS,
        RESIZABLE,
        MINIMIZED,
        MAXIMIZED,
        MOUSE_GRABBED,
        INPUT_FOCUS,
        MOUSE_FOCUS,
        EXTERNAL,
        MODAL,
        HIGH_PIXEL_DENSITY,
        MOUSE_CAPTURE,
        MOUSE_RELATIVE_MODE,
        ALWAYS_ON_TOP,
        UTILITY,
        TOOLTIP,
        POPUP_MENU,
        KEYBOARD_GRABBED,
        VULKAN,
        METAL,
        TRANSPARENT,
        NOT_FOCUSABLE,
    } // WindowFlags

    [SimpleType, CCode (cname = "SDL_WindowID", has_type_id = false)]
    public struct WindowID : uint32 {}

    [CCode (cname = "SDL_DisplayMode", has_type_id = false)]
    public struct DisplayMode {
        public DisplayID display_id;
        public Pixels.PixelFormat format;
        public int w;
        public int h;
        public float pixel_density;
        public float refresh_rate;
        public int refresh_rate_numerator;
        public int refresh_rate_denominator;
        [CCode (cname = "internal")]
        public DisplayModeData internal_data;
    } // DisplayMode

    [CCode (cname = "SDL_DisplayOrientation", cprefix = "SDL_ORIENTATION_", has_type_id = false)]
    public enum DisplayOrientation {
        UNKNOWN,
        LANDSCAPE,
        LANDSCAPE_FLIPPED,
        PORTRAIT,
        PORTRAIT_FLIPPED,
    } // DisplayOrientation

    [CCode (cname = "SDL_FlashOperation", cprefix = "SDL_FLASH_", has_type_id = false)]
    public enum FlashOperation {
        CANCEL,
        BRIEFLY,
        UNTIL_FOCUSED,
    } // FlashOperation

    [CCode (cname = "SDL_GLAttr", cprefix = "SDL_GL_", has_type_id = false)]
    public enum GLAttr {
        RED_SIZE,
        GREEN_SIZE,
        BLUE_SIZE,
        ALPHA_SIZE,
        BUFFER_SIZE,
        DOUBLEBUFFER,
        DEPTH_SIZE,
        STENCIL_SIZE,
        ACCUM_RED_SIZE,
        ACCUM_GREEN_SIZE,
        ACCUM_BLUE_SIZE,
        ACCUM_ALPHA_SIZE,
        STEREO,
        MULTISAMPLEBUFFERS,
        MULTISAMPLESAMPLES,
        ACCELERATED_VISUAL,
        RETAINED_BACKING,
        CONTEXT_MAJOR_VERSION,
        CONTEXT_MINOR_VERSION,
        CONTEXT_FLAGS,
        CONTEXT_PROFILE_MASK,
        SHARE_WITH_CURRENT_CONTEXT,
        FRAMEBUFFER_SRGB_CAPABLE,
        CONTEXT_RELEASE_BEHAVIOR,
        CONTEXT_RESET_NOTIFICATION,
        CONTEXT_NO_ERROR,
        FLOATBUFFERS,
        EGL_PLATFORM,
    } // SDL_GLAttr

    [CCode (cname = "SDL_HitTestResult", cprefix = "SDL_HITTEST_", has_type_id = false)]
    public enum HitTestResult {
        NORMAL,
        DRAGGABLE,
        RESIZE_TOPLEFT,
        RESIZE_TOP,
        RESIZE_TOPRIGHT,
        RESIZE_RIGHT,
        RESIZE_BOTTOMRIGHT,
        RESIZE_BOTTOM,
        RESIZE_BOTTOMLEFT,
        RESIZE_LEFT,
    } // HitTestResult

    [CCode (cname = "SDL_SystemTheme", cprefix = "SDL_SYSTEM_THEME_", has_type_id = false)]
    public enum SystemTheme {
        UNKNOWN,
        LIGHT,
        DARK,
    } // SDL_SystemTheme;

    [CCode (cname = "SDL_WINDOWPOS_CENTERED")]
    public static uint32 window_pos_centered ();

    [CCode (cname = "SDL_WINDOWPOS_CENTERED_DISPLAY")]
    public static uint32 window_pos_centered_display (DisplayID display_id);

    [CCode (cname = "SDL_WINDOWPOS_CENTERED_MASK")]
    public const uint32 WINDOWPOS_CENTERED_MASK;

    [CCode (cname = "SDL_WINDOWPOS_ISCENTERED")]
    public static bool window_pos_is_centered ();

    [CCode (cname = "SDL_WINDOWPOS_ISUNDEFINED")]
    public static bool windows_pos_is_undefined ();

    [CCode (cname = "SDL_WINDOWPOS_UNDEFINED")]
    public static uint32 window_pos_undefined ();

    [CCode (cname = "SDL_WINDOWPOS_UNDEFINED_DISPLAY")]
    public static uint32 window_pos_undefined_display (DisplayID display_id);

    [CCode (cname = "SDL_WINDOWPOS_UNDEFINED_MASK")]
    public const uint32 WINDOWPOS_UNDEFINED_MASK;

    namespace SDLPropGlobalVideo {
        [CCode (cname = "SDL_PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER")]
        public const string WAYLAND_WL_DISPLAY_POINTER;
    } // SDLPropGlobalVideo

    namespace SDLPropWindowCreate {
        [CCode (cname = "SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN")]
        public const string ALWAYS_ON_TOP_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN:")]
        public const string BORDERLESS_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN")]
        public const string EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN")]
        public const string FOCUSABLE_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN")]
        public const string FULLSCREEN_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER")]
        public const string HEIGHT_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN")]
        public const string HIDDEN_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN")]
        public const string HIGH_PIXEL_DENSITY_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN")]
        public const string MAXIMIZED_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN")]
        public const string MENU_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN")]
        public const string METAL_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN")]
        public const string MINIMIZED_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN")]
        public const string MODAL_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN")]
        public const string MOUSE_GRABBED_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN")]
        public const string OPENGL_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_PARENT_POINTER")]
        public const string PARENT_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN")]
        public const string RESIZABLE_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_TITLE_STRING")]
        public const string TITLE_STRING;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN")]
        public const string TRANSPARENT_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN")]
        public const string TOOLTIP_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN")]
        public const string UTILITY_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN")]
        public const string VULKAN_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER")]
        public const string WIDTH_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_X_NUMBER")]
        public const string X_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_Y_NUMBER")]
        public const string Y_NUMBER;

        // macOS
        [CCode (cname = "SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER")]
        public const string COCOA_WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER")]
        public const string COCOA_VIEW_POINTER;

        // Wayland
        [CCode (cname = "SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN")]
        public const string WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN")]
        public const string WAYLAND_CREATE_EGL_WINDOW_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER")]
        public const string WAYLAND_WL_SURFACE_POINTER;

        // Windows
        [CCode (cname = "SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER")]
        public const string WIN32_HWND_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER")]
        public const string WIN32_PIXEL_FORMAT_HWND_POINTER;

        // X11
        [CCode (cname = "SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER")]
        public const string X11_WINDOW_NUMBER;
    } // SDLPropWindowCreate

    namespace SDLPropDisplay {
        [CCode (cname = "SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN")]
        public const string HDR_ENABLED_BOOLEAN;

        [CCode (cname = "SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER")]
        public const string KMSDRM_PANEL_ORIENTATION_NUMBER;
    } // SDLPropDisplay

    namespace SDLPropWindow {
        [CCode (cname = "SDL_PROP_WINDOW_SHAPE_POINTER")]
        public const string SHAPE_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN")]
        public const string HDR_ENABLED_BOOLEAN;

        [CCode (cname = "SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT")]
        public const string SDR_WHITE_LEVEL_FLOAT;

        [CCode (cname = "SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT")]
        public const string HDR_HEADROOM_FLOAT;

        // Android
        [CCode (cname = "SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER")]
        public const string ANDROID_WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER")]
        public const string ANDROID_SURFACE_POINTER;

        // iOS
        [CCode (cname = "SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER")]
        public const string UIKIT_WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER")]
        public const string UIKIT_METAL_VIEW_TAG_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER")]
        public const string UIKIT_OPENGL_FRAMEBUFFER_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER")]
        public const string UIKIT_OPENGL_RENDERBUFFER_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER")]
        public const string UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER;

        // KMS/DRM
        [CCode (cname = "SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER")]
        public const string KMSDRM_DEVICE_INDEX_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER")]
        public const string KMSDRM_DRM_FD_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER")]
        public const string KMSDRM_GBM_DEVICE_POINTER;

        // macOS
        [CCode (cname = "SDL_PROP_WINDOW_COCOA_WINDOW_POINTER")]
        public const string COCOA_WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER")]
        public const string COCOA_METAL_VIEW_TAG_NUMBER;

        // OpenVR
        [CCode (cname = "SDL_PROP_WINDOW_OPENVR_OVERLAY_ID")]
        public const string OPENVR_OVERLAY_ID;

        // Vivante
        [CCode (cname = "SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER")]
        public const string VIVANTE_DISPLAY_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER")]
        public const string VIVANTE_WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER")]
        public const string VIVANTE_SURFACE_POINTER;

        // Windows
        [CCode (cname = "SDL_PROP_WINDOW_WIN32_HWND_POINTER")]
        public const string WIN32_HWND_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WIN32_HDC_POINTER")]
        public const string WIN32_HDC_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER")]
        public const string WIN32_INSTANCE_POINTER;

        // Wayland
        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER")]
        public const string WAYLAND_DISPLAY_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER")]
        public const string WAYLAND_SURFACE_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_VIEWPORT_POINTER")]
        public const string WAYLAND_VIEWPORT_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER")]
        public const string WAYLAND_EGL_WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER")]
        public const string WAYLAND_XDG_SURFACE_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER")]
        public const string WAYLAND_XDG_TOPLEVEL_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING")]
        public const string WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING;

        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER")]
        public const string WAYLAND_XDG_POPUP_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER")]
        public const string WAYLAND_XDG_POSITIONER_POINTER;

        // X11
        [CCode (cname = "SDL_PROP_WINDOW_X11_DISPLAY_POINTER")]
        public const string X11_DISPLAY_POINTER;

        [CCode (cname = "SDL_PROP_WINDOW_X11_SCREEN_NUMBER")]
        public const string X11_SCREEN_NUMBER;

        [CCode (cname = "SDL_PROP_WINDOW_X11_WINDOW_NUMBER")]
        public const string X11_WINDOW_NUMBER;
    } // SDLPropWindow
} // SDL.Video

///
/// 2D Accelerated Rendering (SDL_render.h)
///
[CCode (cheader_filename = "SDL3/SDL_render.h")]
namespace SDL.Render {
    [CCode (cname = "SDL_AddVulkanRenderSemaphores")]
    public static bool add_vulkan_render_semaphores (Renderer renderer,
        uint32 wait_stage_mask,
        int64 wait_semaphore,
        int64 signal_semaphore);

    [CCode (cname = "SDL_ConvertEventToRenderCoordinates")]
    public static bool convert_event_to_render_coordinates (Renderer renderer, Events.Event event);

    [CCode (cname = "SDL_CreateRenderer")]
    public static Renderer ? create_renderer (Video.Window window, string? name);

    [CCode (cname = "SDL_CreateRendererWithProperties")]
    public static Renderer ? create_renderer_with_properties (Properties.PropertiesID props);

    [CCode (cname = "SDL_CreateSoftwareRenderer")]
    public static Renderer ? create_software_renderer (Surface.Surface surface);

    [CCode (cname = "SDL_CreateTexture")]
    public static Texture ? create_texture (Renderer renderer,
        Pixels.PixelFormat format,
        TextureAccess access,
        int w,
        int h);

    [CCode (cname = "SDL_CreateTextureFromSurface")]
    public static Texture ? create_texture_from_surface (Renderer renderer, Surface.Surface surface);

    [CCode (cname = "SDL_CreateTextureWithProperties")]
    public static Texture ? create_texture_with_properties (Renderer renderer, Properties.PropertiesID props);

    [CCode (cname = "SDL_CreateWindowAndRenderer")]
    public static bool create_window_and_renderer (string title,
        int width,
        int height,
        Video.WindowFlags window_flags,
        out Video.Window? window,
        out Renderer? renderer);

    [CCode (cname = "SDL_DestroyRenderer")]
    public static void destroy_renderer (Renderer renderer);

    [CCode (cname = "SDL_DestroyTexture")]
    public static void destroy_texture (Texture texture);

    [CCode (cname = "SDL_FlushRenderer")]
    public static bool flush_renderer (Renderer renderer);

    [CCode (cname = "SDL_GetCurrentRenderOutputSize")]
    public static bool get_current_render_output_size (Renderer renderer, out int w, out int h);

    [CCode (cname = "SDL_GetNumRenderDrivers")]
    public static int get_num_render_drivers ();

    [CCode (cname = "SDL_GetRenderClipRect")]
    public static bool get_render_clip_rect (Renderer renderer, out Rect.Rect rect);

    [CCode (cname = "SDL_GetRenderColorScale")]
    public static bool get_render_color_scale (Renderer renderer, out float scale);

    [CCode (cname = "SDL_GetRenderDrawBlendMode")]
    public static bool get_render_draw_blend_mode (Renderer renderer, out BlendModes.BlendMode blend_mode);

    [CCode (cname = "SDL_GetRenderDrawColor")]
    public static bool get_render_draw_color (Renderer renderer,
        out uint8 r,
        out uint8 g,
        out uint8 b,
        out uint8 a);

    [CCode (cname = "SDL_GetRenderDrawColorFloat")]
    public static bool get_render_draw_color_float (Renderer renderer,
        out float r,
        out float g,
        out float b,
        out float a);

    [CCode (cname = "SDL_GetRenderDriver")]
    public static unowned string ? get_render_driver (int index);

    [CCode (cname = "SDL_GetRenderer")]
    public static Renderer ? get_renderer (Video.Window window);

    [CCode (cname = "SDL_GetRendererFromTexture")]
    public static Renderer ? get_renderer_from_texture (Texture texture);

    [CCode (cname = "SDL_GetRendererName")]
    public static unowned string ? get_renderer_name (Renderer renderer);

    [CCode (cname = "SDL_GetRendererProperties")]
    public static Properties.PropertiesID get_renderer_properties (Renderer renderer);

    [CCode (cname = "SDL_GetRenderLogicalPresentation")]
    public static bool get_render_logical_presentation (Renderer renderer,
        out int w,
        out int h,
        out RendererLogicalPresentation mode);

    [CCode (cname = "SDL_GetRenderLogicalPresentationRect")]
    public static bool get_render_logical_presentation_rect (Renderer renderer, out Rect.FRect? rect);

    [CCode (cname = "SDL_GetRenderMetalCommandEncoder")]
    public static void * get_render_metal_command_encoder (Renderer renderer);

    [CCode (cname = "SDL_GetRenderMetalLayer")]
    public static void * get_render_metal_layer (Renderer renderer);

    [CCode (cname = "SDL_GetRenderOutputSize")]
    public static bool get_render_output_size (Renderer renderer, out int w, out int h);

    [CCode (cname = "SDL_GetRenderSafeArea")]
    public static bool get_render_safe_area (Renderer renderer, out Rect.Rect rect);

    [CCode (cname = "SDL_GetRenderScale")]
    public static bool get_render_scale (Renderer renderer, out float scale_x, out float scale_y);

    [CCode (cname = "SDL_GetRenderTarget")]
    public static Texture ? get_render_target (Renderer renderer);

    [CCode (cname = "SDL_GetRenderViewport")]
    public static bool get_render_viewport (Renderer renderer, out Rect.Rect rect);

    [CCode (cname = "SDL_GetRenderVSync")]
    public static bool get_render_vsync (Renderer renderer, out int vsync);

    [CCode (cname = "SDL_GetRenderWindow")]
    public static Video.Window ? get_render_window (Renderer renderer);

    [CCode (cname = "SDL_GetTextureAlphaMod")]
    public static bool get_texture_alpha_mod (Texture texture, out uint8 alpha);

    [CCode (cname = "SDL_GetTextureAlphaModFloat")]
    public static bool get_texture_alpha_mod_float (Texture texture, out float alpha);

    [CCode (cname = "SDL_GetTextureBlendMode")]
    public static bool get_texture_blend_mode (Texture texture, out BlendModes.BlendMode blend_mode);

    [CCode (cname = "SDL_GetTextureColorMod")]
    public static bool get_texture_color_mod (Texture texture, out uint8 r, out uint8 g, out uint8 b);

    [CCode (cname = "SDL_GetTextureColorMod")]
    public static bool get_texture_color_mod_float (Texture texture, out float r, out float g, out float b);

    [CCode (cname = "SDL_GetTextureProperties")]
    public static Properties.PropertiesID get_texture_properties (Texture texture);

    [CCode (cname = "SDL_GetTextureScaleMode")]
    public static bool get_texture_scale_mode (Texture* texture, out Surface.ScaleMode scale_mode);

    [CCode (cname = "SDL_GetTextureSize")]
    public static bool get_texture_size (Texture texture, out float w, out float h);

    [CCode (cname = "SDL_LockTexture")]
    public static bool lock_texture (Texture texture, Rect.Rect? rect, out void* pixels, out int pitch);

    [CCode (cname = "SDL_LockTextureToSurface")]
    public static bool lock_texture_to_surface (Texture texture, Rect.Rect? rect, out Surface.Surface surface);

    [CCode (cname = "SDL_RenderClear")]
    public static bool render_clear (Renderer renderer);

    [CCode (cname = "SDL_RenderClipEnabled")]
    public static bool render_clip_enabled (Renderer renderer);

    [CCode (cname = "SDL_RenderCoordinatesFromWindow")]
    public static bool render_coordinates_from_window (Renderer renderer,
        float window_x,
        float window_y,
        out float x,
        out float y);

    [CCode (cname = "SDL_RenderCoordinatesToWindow")]
    public static bool render_coordinates_to_window (Renderer renderer,
        float x,
        float y,
        out float window_x,
        out float window_y);

    [CCode (cname = "SDL_RenderDebugText")]
    public static bool render_debug_text (Renderer renderer, float x, float y, string str);

    [CCode (cname = "SDL_RenderDebugTextFormat")]
    public static bool render_debug_text_format (Renderer renderer, float x, float y, string fmt, ...);

    [CCode (cname = "SDL_RenderFillRect")]
    public static bool render_fill_rect (Renderer renderer, Rect.FRect rect);

    [CCode (cname = "SDL_RenderFillRects")]
    public static bool render_fill_rects (Renderer renderer, Rect.FRect[] rects);

    [CCode (cname = "SDL_RenderGeometry")]
    public static bool render_geometry (Renderer renderer, Texture? texture, Vertex[] vertices, int[]? indices);

    [CCode (cname = "SDL_RenderGeometryRaw")]
    public static bool render_geometry_raw (Renderer renderer,
        Texture? texture,
        [CCode (array_length = false)] float[] xy,
        int xy_stride,
        [CCode (array_length = false)] Pixels.FColor[] color,
        int color_stride,
        [CCode (array_length = false)] float[] uv,
        int uv_stride,
        int num_vertices,
        [CCode (array_length = false)] void* indices,
        int size_indices);

    [CCode (cname = "SDL_RenderLine")]
    public static bool render_line (Renderer renderer, float x1, float y1, float x2, float y2);

    [CCode (cname = "SDL_RenderLines")]
    public static bool render_lines (Renderer renderer, Rect.FPoint[] points);

    [CCode (cname = "SDL_RenderPoint")]
    public static bool render_point (Renderer renderer, float x, float y);

    [CCode (cname = "SDL_RenderPoints")]
    public static bool render_points (Renderer renderer, Rect.FPoint[] points);

    [CCode (cname = "SDL_RenderPresent")]
    public static bool render_present (Renderer renderer);

    [CCode (cname = "SDL_RenderReadPixels")]
    public static Surface.Surface ? render_read_pixels (Renderer renderer, Rect.Rect ? rect);

    [CCode (cname = "SDL_RenderRect")]
    public static bool render_rect (Renderer renderer, Rect.FRect rect);

    [CCode (cname = "SDL_RenderRects")]
    public static bool render_rects (Renderer renderer, Rect.FRect[] rects);

    [CCode (cname = "SDL_RenderTexture")]
    public static bool render_texture (Renderer renderer,
        Texture texture,
        Rect.FRect? src_rect,
        Rect.FRect? dst_rect);

    [CCode (cname = "SDL_RenderTexture9Grid")]
    public static bool render_texture_9grid (Renderer renderer,
        Texture texture,
        Rect.FRect? src_rect,
        float left_width,
        float right_width,
        float top_height,
        float bottom_height,
        float scale,
        Rect.FRect? dst_rect);

    [CCode (cname = "SDL_RenderTextureAffine")]
    public static bool render_texture_affine (Renderer renderer,
        Texture texture,
        Rect.FRect? src_rect,
        Rect.FPoint? origin,
        Rect.FPoint? right,
        Rect.FPoint? down);

    [CCode (cname = "SDL_RenderTextureRotated")]
    public static bool render_texture_rotated (Renderer renderer,
        Texture texture,
        Rect.FRect? src_rect,
        Rect.FRect? dst_rect,
        double angle,
        Rect.FPoint? center,
        Surface.FlipMode flip);

    [CCode (cname = "SDL_RenderTextureTiled")]
    public static bool render_texture_tiled (Renderer renderer,
        Texture texture,
        Rect.FRect? src_rect,
        float scale,
        Rect.FRect? dst_rect);

    [CCode (cname = "SDL_RenderViewportSet")]
    public static bool render_viewport_set (Renderer renderer);

    [CCode (cname = "SDL_SetRenderClipRect")]
    public static bool set_render_clip_rect (Renderer renderer, Rect.Rect? rect);

    [CCode (cname = "SDL_SetRenderColorScale")]
    public static bool set_render_color_scale (Renderer renderer, float scale);

    [CCode (cname = "SDL_SetRenderDrawBlendMode")]
    public static bool set_render_draw_blend_mode (Renderer renderer, BlendModes.BlendMode blend_mode);

    [CCode (cname = "SDL_SetRenderDrawColor")]
    public static bool set_render_draw_color (Renderer renderer, uint8 r, uint8 g, uint8 b, uint8 a);

    [CCode (cname = "SDL_SetRenderDrawColorFloat")]
    public static bool set_render_draw_color_float (Renderer renderer, float r, float g, float b, float a);

    [CCode (cname = "SDL_SetRenderLogicalPresentation")]
    public static bool set_render_logical_presentation (Renderer renderer,
        int w,
        int h,
        RendererLogicalPresentation mode);

    [CCode (cname = "SDL_SetRenderScale")]
    public static bool set_render_scale (Renderer renderer, float scale_x, float scale_y);

    [CCode (cname = "SDL_SetRenderTarget")]
    public static bool set_render_target (Renderer renderer, Texture? texture);

    [CCode (cname = "SDL_SetRenderViewport")]
    public static bool set_render_viewport (Renderer renderer, Rect.Rect? rect);

    [CCode (cname = "SDL_SetRenderVSync")]
    public static bool set_render_vsync (Renderer renderer, int vsync);

    [CCode (cname = "SDL_SetTextureAlphaMod")]
    public static bool set_texture_alpha_mod (Texture texture, uint8 alpha);

    [CCode (cname = "SDL_SetTextureAlphaMod")]
    public static bool set_texture_alpha_mod_float (Texture texture, float alpha);

    [CCode (cname = "SDL_SetTextureBlendMode")]
    public static bool set_texture_blend_mode (Texture texture, BlendModes.BlendMode blend_mode);

    [CCode (cname = "SDL_SetTextureColorMod")]
    public static bool set_texture_color_mod (Texture texture, uint8 r, uint8 g, uint8 b);

    [CCode (cname = "SDL_SetTextureColorModFloat")]
    public static bool set_texture_color_mod_float (Texture texture, float r, float g, float b);

    [CCode (cname = "SDL_SetTextureScaleMode")]
    public static bool set_texture_color_scale_mode (Texture texture, Surface.ScaleMode scale_mode);

    [CCode (cname = "SDL_UnlockTexture")]
    public static void unlock_texture (Texture texture);

    [CCode (cname = "SDL_UpdateNVTexture")]
    public static bool update_nv_texture (Texture texture,
        Rect.Rect? rect,
        uint8 y_plane,
        int y_pitch,
        uint8 uv_plane,
        int uv_pitch);

    [CCode (cname = "SDL_UpdateTexture")]
    public static bool update_texture (Texture texture, Rect.Rect? rect, void* pixels, int pitch);

    [CCode (cname = "SDL_UpdateYUVTexture")]
    public static bool update_yuv_texture (Texture texture,
        Rect.Rect? rect,
        uint8 y_plane,
        int y_pitch,
        uint8 u_plane,
        int u_pitch,
        uint8 v_plane,
        int v_pitch);

    [Compact, CCode (cname = "SDL_Renderer", free_function = "", has_type_id = false)]
    public class Renderer {}

    [Compact, CCode (cname = "SDL_Texture", free_function = "", has_type_id = false)]
    public class Texture {
        public Pixels.PixelFormat format;
        public int w;
        public int h;
        public int refcount;
    }

    [Compact, CCode (cname = "SDL_Vertex", free_function = "", ref_function = "", unref_function = "", has_type_id = false)]
    public class Vertex {
        public Rect.FPoint position;
        public Pixels.FColor color;
        public Rect.FPoint tex_coord;
    } // Vertex;

    [CCode (cname = "SDL_RendererLogicalPresentation", cprefix = "SDL_LOGICAL_PRESENTATION_", has_type_id = false)]
    public enum RendererLogicalPresentation {
        DISABLED,
        STRETCH,
        LETTERBOX,
        OVERSCAN,
        INTEGER_SCALE,
    } // RendererLogicalPresentation;

    [CCode (cname = "SDL_TextureAccess", cprefix = "SDL_TEXTUREACCESS_", has_type_id = false)]
    public enum TextureAccess {
        STATIC,
        STREAMING,
        TARGET,
    } // TextureAccess;

    [CCode (cname = "SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE")]
    public const int DEBUG_TEXT_FONT_CHARACTER_SIZE;

    [CCode (cname = "SDL_SOFTWARE_RENDERER")]
    public const string SOFTWARE_RENDERER;

    [CCode (cname = "SDL_RENDERER_VSYNC_DISABLED")]
    public const int RENDERER_VSYNC_DISABLED;

    [CCode (cname = "SDL_RENDERER_VSYNC_ADAPTIVE")]
    public const int RENDERER_VSYNC_ADAPTIVE;

    namespace SDLPropRendererCreate {
        [CCode (cname = "SDL_PROP_RENDERER_CREATE_NAME_STRING")]
        public const string NAME_STRING;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_WINDOW_POINTER")]
        public const string WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_SURFACE_POINTER")]
        public const string SURFACE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER")]
        public const string OUTPUT_COLORSPACE_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER")]
        public const string PRESENT_VSYNC_NUMBER;

        // Vulkan
        [CCode (cname = "SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER")]
        public const string VULKAN_INSTANCE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER")]
        public const string VULKAN_SURFACE_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER")]
        public const string VULKAN_PHYSICAL_DEVICE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER")]
        public const string VULKAN_DEVICE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER")]
        public const string VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER")]
        public const string VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER;
    } // SDLPropRendererCreate

    namespace SDLPropTextureCreate {
        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER")]
        public const string COLORSPACE_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER")]
        public const string FORMAT_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER")]
        public const string ACCESS_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER")]
        public const string WIDTH_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER")]
        public const string HEIGHT_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT")]
        public const string SDR_WHITE_POINT_FLOAT;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT")]
        public const string HDR_HEADROOM_FLOAT;

        // Direct3D 11
        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTE")]
        public const string D3D11_TEXTURE_POINTE;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER")]
        public const string D3D11_TEXTURE_U_POINTER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER")]
        public const string D3D11_TEXTURE_V_POINTER;

        // Direct3D 12
        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER")]
        public const string D3D12_TEXTURE_POINTER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER")]
        public const string D3D12_TEXTURE_U_POINTER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER")]
        public const string D3D12_TEXTURE_V_POINTER;

        // Metal
        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER")]
        public const string METAL_PIXELBUFFER_POINTER;

        // OpenGL
        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER")]
        public const string OPENGL_TEXTURE_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER")]
        public const string OPENGL_TEXTURE_UV_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER")]
        public const string OPENGL_TEXTURE_U_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER")]
        public const string OPENGL_TEXTURE_V_NUMBER;

        // OpenGL ES2
        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER")]
        public const string OPENGLES2_TEXTURE_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER")]
        public const string OPENGLES2_TEXTURE_UV_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER")]
        public const string OPENGLES2_TEXTURE_U_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER")]
        public const string OPENGLES2_TEXTURE_V_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER")]
        public const string VULKAN_TEXTURE_NUMBER;
    } // SDLPropTextureCreate

    namespace SDLPropRenderer {
        [CCode (cname = "SDL_PROP_RENDERER_NAME_STRING")]
        public const string NAME_STRING;

        [CCode (cname = "SDL_PROP_RENDERER_WINDOW_POINTER")]
        public const string WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_SURFACE_POINTER")]
        public const string SURFACE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_VSYNC_NUMBER")]
        public const string VSYNC_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER")]
        public const string MAX_TEXTURE_SIZE_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER")]
        public const string TEXTURE_FORMATS_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER")]
        public const string OUTPUT_COLORSPACE_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN")]
        public const string HDR_ENABLED_BOOLEAN;

        [CCode (cname = "SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT")]
        public const string SDR_WHITE_POINT_FLOAT;

        [CCode (cname = "SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT")]
        public const string HDR_HEADROOM_FLOAT;

        // Direct3D
        [CCode (cname = "SDL_PROP_RENDERER_D3D9_DEVICE_POINTER")]
        public const string D3D9_DEVICE_POINTER;

        // Direct3D 11
        [CCode (cname = "SDL_PROP_RENDERER_D3D11_DEVICE_POINTER")]
        public const string D3D11_DEVICE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER")]
        public const string D3D11_SWAPCHAIN_POINTER;

        // Direct3D 12
        [CCode (cname = "SDL_PROP_RENDERER_D3D12_DEVICE_POINTER")]
        public const string D3D12_DEVICE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER")]
        public const string D3D12_SWAPCHAIN_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER")]
        public const string D3D12_COMMAND_QUEUE_POINTER;

        // Vulkan
        [CCode (cname = "SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER")]
        public const string VULKAN_INSTANCE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER")]
        public const string VULKAN_SURFACE_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER")]
        public const string VULKAN_PHYSICAL_DEVICE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER")]
        public const string VULKAN_DEVICE_POINTER;

        [CCode (cname = "SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER")]
        public const string VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER")]
        public const string VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER;

        [CCode (cname = "SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER")]
        public const string VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER;

        // GPU
        [CCode (cname = "SDL_PROP_RENDERER_GPU_DEVICE_POINTER")]
        public const string GPU_DEVICE_POINTER;
    } // SDLPropRenderer

    namespace SDLPropTexture {
        [CCode (cname = "SDL_PROP_TEXTURE_COLORSPACE_NUMBER")]
        public const string COLORSPACE_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_FORMAT_NUMBER")]
        public const string FORMAT_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_ACCESS_NUMBER")]
        public const string ACCESS_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_WIDTH_NUMBER")]
        public const string WIDTH_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_HEIGHT_NUMBER")]
        public const string HEIGHT_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT")]
        public const string SDR_WHITE_POINT_FLOAT;

        [CCode (cname = "SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT")]
        public const string HDR_HEADROOM_FLOAT;

        // Direct3D 11
        [CCode (cname = "SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER")]
        public const string D3D11_TEXTURE_POINTER;

        [CCode (cname = "SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER")]
        public const string D3D11_TEXTURE_U_POINTER;

        [CCode (cname = "SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER")]
        public const string D3D11_TEXTURE_V_POINTER;

        // Direct3D 12
        [CCode (cname = "SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER")]
        public const string D3D12_TEXTURE_POINTER;

        [CCode (cname = "SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER")]
        public const string D3D12_TEXTURE_U_POINTER;

        [CCode (cname = "SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER")]
        public const string D3D12_TEXTURE_V_POINTER;

        // Vulkan
        [CCode (cname = "SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER")]
        public const string VULKAN_TEXTURE_NUMBER;

        // OpenGL
        [CCode (cname = "SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER")]
        public const string OPENGL_TEXTURE_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER")]
        public const string OPENGL_TEXTURE_UV_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER")]
        public const string OPENGL_TEXTURE_U_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER")]
        public const string OPENGL_TEXTURE_V_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER")]
        public const string OPENGL_TEXTURE_TARGET_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT")]
        public const string OPENGL_TEX_W_FLOAT;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT")]
        public const string OPENGL_TEX_H_FLOAT;

        // OpenGL ES2
        [CCode (cname = "SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER")]
        public const string OPENGLES2_TEXTURE_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER")]
        public const string OPENGLES2_TEXTURE_UV_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER")]
        public const string OPENGLES2_TEXTURE_U_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER")]
        public const string OPENGLES2_TEXTURE_V_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER")]
        public const string OPENGLES2_TEXTURE_TARGET_NUMBER;
    } // SDLPropTexture
} // SDL.Render

///
/// Pixel Formats and Conversion Routines (SDL_pixels.h)
///
namespace SDL.Pixels {
    [CCode (cname = "SDL_CreatePalette")]
    public static Palette ? create_palette (int ncolors);

    [CCode (cname = "SDL_DestroyPalette")]
    public static void destroy_palette (Palette palette);

    [CCode (cname = "SDL_GetMasksForPixelFormat")]
    public static bool get_masks_for_pixel_format (PixelFormat format,
        int bpp,
        out uint32 r_mask,
        out uint32 g_mask,
        out uint32 b_mask,
        out uint32 a_mask);

    [CCode (cname = "SDL_GetPixelFormatDetails")]
    public static PixelFormatDetails ? get_pixel_format_details (PixelFormat format);

    [CCode (cname = "SDL_GetPixelFormatForMasks")]
    public static PixelFormat get_pixel_format_for_masks (int bpp,
        uint32 r_mask,
        uint32 g_mask,
        uint32 b_mask,
        uint32 a_mask);

    [CCode (cname = "SDL_GetPixelFormatName")]
    public static unowned string get_pixel_format_name (PixelFormat format);

    [CCode (cname = "SDL_GetRGB")]
    public static void get_rgb (uint32 pixel,
        PixelFormatDetails format,
        Palette? palette,
        out uint8 r,
        out uint8 g,
        out uint8 b);

    [CCode (cname = "SDL_GetRGBA")]
    public static void get_rgba (uint32 pixel,
        PixelFormatDetails format,
        Palette? palette,
        out uint8 r,
        out uint8 g,
        out uint8 b,
        out uint8 a);

    [CCode (cname = "SDL_MapRGB")]
    public static uint32 map_rgb (PixelFormatDetails format, Palette? palette, uint8 r, uint8 g, uint8 b);

    [CCode (cname = "SDL_MapRGBA")]
    public static uint32 map_rgba (PixelFormatDetails format, Palette? palette, uint8 r, uint8 g, uint8 b, uint8 a);

    [CCode (cname = "SDL_MapSurfaceRGB")]
    public static uint32 map_surface_rgb (Surface.Surface surface, uint8 r, uint8 g, uint8 b);

    [CCode (cname = "SDL_MapSurfaceRGBA")]
    public static uint32 map_surface_rgba (Surface.Surface surface, uint8 r, uint8 g, uint8 b, uint8 a);

    [CCode (cname = "SDL_SetPaletteColors")]
    public static bool set_palette_colors (Palette palette,
        [CCode (array_length = false)] Color[] colors,
        int firstcolor,
        int ncolors);

    [SimpleType, CCode (cname = "SDL_Color", destroy_function = "", has_type_id = false)]
    public struct Color {
        public uint8 r;
        public uint8 g;
        public uint8 b;
        public uint8 a;
    } // Color;

    [SimpleType, CCode (cname = "SDL_FColor", destroy_function = "", has_type_id = false)]
    public struct FColor {
        public float r;
        public float g;
        public float b;
        public float a;
    } // FColor

    [Compact, CCode (cname = "SDL_Palette", free_function = "", has_type_id = false)]
    public class Palette {
        public int ncolors;
        public Color[] colors;
        public uint32 version;
        public int refcount;
    } // Palette

    [CCode (cname = "SDL_PixelFormatDetails", has_type_id = false)]
    public struct PixelFormatDetails {
        public PixelFormat format;
        public uint8 bits_per_pixel;
        public uint8 bytes_per_pixel;
        public uint8 padding[2];
        [CCode (cname = "Rmask")]
        public uint32 r_mask;
        [CCode (cname = "Gmask")]
        public uint32 g_mask;
        [CCode (cname = "Bmask")]
        public uint32 b_mask;
        [CCode (cname = "Amask")]
        public uint32 a_mask;
        [CCode (cname = "Rbits")]
        public uint8 r_bits;
        [CCode (cname = "Gbits")]
        public uint8 g_bits;
        [CCode (cname = "Bbits")]
        public uint8 b_bits;
        [CCode (cname = "Abits")]
        public uint8 a_bits;
        [CCode (cname = "Rshift")]
        public uint8 r_shift;
        [CCode (cname = "Gshift")]
        public uint8 g_shift;
        [CCode (cname = "Bshift")]
        public uint8 b_shift;
        [CCode (cname = "Ashift")]
        public uint8 a_shift;
    } // PixelFormatDetails

    [CCode (cname = "SDL_ArrayOrder", cprefix = "SDL_ARRAYORDER_", has_type_id = false)]
    public enum ArrayOrder {
        NONE,
        RGB,
        RGBA,
        ARGB,
        BGR,
        BGRA,
        ABGR,
    } // ArrayOrder

    [CCode (cname = "SDL_BitmapOrder", cprefix = "SDL_", has_type_id = false)]
    public enum BitmapOrder {
        BITMAPORDER_NONE,
        BITMAPORDER_4321,
        BITMAPORDER_1234,
    } // BitmapOrder

    [CCode (cname = "SDL_ChromaLocation", cprefix = "SDL_CHROMA_LOCATION_", has_type_id = false)]
    public enum ChromaLocation {
        NONE,
        LEFT,
        CENTER,
        TOPLEFT,
    } // ChromaLocation

    [CCode (cname = "SDL_ColorPrimaries", cprefix = "SDL_COLOR_PRIMARIES_", has_type_id = false)]
    public enum ColorPrimaries {
        UNKNOWN,
        BT709,
        UNSPECIFIED,
        BT470M,
        BT470BG,
        BT601,
        SMPTE240,
        GENERIC_FILM,
        BT2020,
        XYZ,
        SMPTE431,
        SMPTE432,
        EBU3213,
        CUSTOM,
    } // ColorPrimaries

    [CCode (cname = "SDL_ColorRange", cprefix = "SDL_COLOR_RANGE_", has_type_id = false)]
    public enum ColorRange {
        UNKNOWN,
        LIMITED,
        FULL,
    } // ColorRange

    [CCode (cname = "SDL_Colorspace", cprefix = "SDL_COLORSPACE_", has_type_id = false)]
    public enum ColorSpace {
        UNKNOWN,
        SRGB,
        SRGB_LINEAR,
        HDR10,
        JPEG,
        BT601_LIMITED,
        BT601_FULL,
        BT709_LIMITED,
        BT709_FULL,
        BT2020_LIMITED,
        BT2020_FULL,
        RGB_DEFAULT,
        YUV_DEFAULT,
    } // ColorSpace

    [CCode (cname = "SDL_ColorType", cprefix = "SDL_COLOR_TYPE_", has_type_id = false)]
    public enum ColorType {
        UNKNOWN,
        RGB,
        YCBCR,
    } // ColorType

    [CCode (cname = "SDL_MatrixCoefficients", cprefix = "SDL_MATRIX_COEFFICIENTS_", has_type_id = false)]
    public enum MatrixCoefficients {
        IDENTITY,
        BT709,
        UNSPECIFIED,
        FCC,
        BT470BG,
        BT601,
        SMPTE240,
        YCGCO,
        BT2020_NCL,
        BT2020_CL,
        SMPTE2085,
        CHROMA_DERIVED_NCL,
        CHROMA_DERIVED_CL,
        ICTCP,
        CUSTOM,
    } // MatrixCoefficients

    [CCode (cname = "SDL_PackedLayout", cprefix = "SDL_", has_type_id = false)]
    public enum PackedLayout {
        PACKEDLAYOUT_NONE,
        PACKEDLAYOUT_332,
        PACKEDLAYOUT_4444,
        PACKEDLAYOUT_1555,
        PACKEDLAYOUT_5551,
        PACKEDLAYOUT_565,
        PACKEDLAYOUT_8888,
        PACKEDLAYOUT_2101010,
        PACKEDLAYOUT_1010102,
    } // PackedLayout

    [CCode (cname = "SDL_PackedOrder", cprefix = "SDL_PACKEDORDER_", has_type_id = false)]
    public enum PackedOrder {
        NONE,
        XRGB,
        RGBX,
        ARGB,
        RGBA,
        XBGR,
        BGRX,
        ABGR,
        BGRA,
    } // PackedOrder

    [CCode (cname = "SDL_PixelFormat", cprefix = "SDL_PIXELFORMAT_", has_type_id = false)]
    public enum PixelFormat {
        UNKNOWN,
        INDEX1LSB,
        INDEX1MSB,
        INDEX2LSB,
        INDEX2MSB,
        INDEX4LSB,
        INDEX4MSB,
        INDEX8,
        RGB332,
        XRGB4444,
        XBGR4444,
        XRGB1555,
        XBGR1555,
        ARGB4444,
        RGBA4444,
        ABGR4444,
        BGRA4444,
        ARGB1555,
        RGBA5551,
        ABGR1555,
        BGRA5551,
        RGB565,
        BGR565,
        RGB24,
        BGR24,
        XRGB8888,
        RGBX8888,
        XBGR8888,
        BGRX8888,
        ARGB8888,
        RGBA8888,
        ABGR8888,
        BGRA8888,
        XRGB2101010,
        XBGR2101010,
        ARGB2101010,
        ABGR2101010,
        RGB48,
        BGR48,
        RGBA64,
        ARGB64,
        BGRA64,
        ABGR64,
        RGB48_FLOAT,
        BGR48_FLOAT,
        RGBA64_FLOAT,
        ARGB64_FLOAT,
        BGRA64_FLOAT,
        ABGR64_FLOAT,
        RGB96_FLOAT,
        BGR96_FLOAT,
        RGBA128_FLOAT,
        ARGB128_FLOAT,
        BGRA128_FLOAT,
        ABGR128_FLOAT,
        YV12,
        IYUV,
        YUY2,
        UYVY,
        YVYU,
        NV12,
        NV21,
        P010,
        EXTERNAL_OES,
        MJPG;

        [CCode (cname = "SDL_PIXELFORMAT_RGBA32")]
        public const PixelFormat RGBA32;

        [CCode (cname = "SDL_PIXELFORMAT_ARGB32")]
        public const PixelFormat ARGB32;

        [CCode (cname = "SDL_PIXELFORMAT_BGRA32")]
        public const PixelFormat BGRA32;

        [CCode (cname = "SDL_PIXELFORMAT_ABGR32")]
        public const PixelFormat ABGR32;

        [CCode (cname = "SDL_PIXELFORMAT_RGBX32")]
        public const PixelFormat RGBX32;

        [CCode (cname = "SDL_PIXELFORMAT_XRGB32")]
        public const PixelFormat XRGB32;

        [CCode (cname = "SDL_PIXELFORMAT_BGRX32")]
        public const PixelFormat BGRX32;

        [CCode (cname = "SDL_PIXELFORMAT_XBGR32")]
        public const PixelFormat XBGR32;
    } // PixelFormat

    [CCode (cname = "SDL_PixelType", cprefix = "SDL_PIXELTYPE_", has_type_id = false)]
    public enum PixelType {
        UNKNOWN,
        INDEX1,
        INDEX4,
        INDEX8,
        PACKED8,
        PACKED16,
        PACKED32,
        ARRAYU8,
        ARRAYU16,
        ARRAYU32,
        ARRAYF16,
        ARRAYF32,
        INDEX2,
    } // PixelType;

    [CCode (cname = "SDL_TransferCharacteristics", cprefix = "SDL_TRANSFER_CHARACTERISTICS_", has_type_id = false)]
    public enum TransferCharacteristics {
        UNKNOWN,
        BT709,
        UNSPECIFIED,
        GAMMA22,
        GAMMA28,
        BT601,
        SMPTE240,
        LINEAR,
        LOG100,
        LOG100_SQRT10,
        IEC61966,
        BT1361,
        SRGB,
        BT2020_10BIT,
        BT2020_12BIT,
        PQ,
        SMPTE428,
        HLG,
        CUSTOM,
    } // TransferCharacteristics;

    [CCode (cname = "SDL_ALPHA_OPAQUE")]
    public const uint8 ALPHA_OPAQUE;

    [CCode (cname = "SDL_ALPHA_OPAQUE_FLOAT")]
    public const float ALPHA_OPAQUE_FLOAT;

    [CCode (cname = "SDL_ALPHA_TRANSPARENT")]
    public const uint8 ALPHA_TRANSPARENT;

    [CCode (cname = "SDL_ALPHA_TRANSPARENT_FLOAT")]
    public const float ALPHA_TRANSPARENT_FLOAT;

    [CCode (cname = "SDL_BITSPERPIXEL")]
    public const uint8 BITSPERPIXEL;

    [CCode (cname = "SDL_BYTESPERPIXEL")]
    public static uint8 bytes_per_pixel (PixelFormat format);

    [CCode (cname = "SDL_COLORSPACECHROMA")]
    public static ChromaLocation color_space_chroma (ColorSpace cspace);

    [CCode (cname = "SDL_COLORSPACEMATRIX")]
    public static MatrixCoefficients color_space_matrix (ColorSpace cspace);

    [CCode (cname = "SDL_COLORSPACEPRIMARIES")]
    public static ColorPrimaries color_space_primaries (ColorSpace cspace);

    [CCode (cname = "SDL_COLORSPACERANGE")]
    public static ColorRange color_space_range (ColorSpace cspace);

    [CCode (cname = "SDL_COLORSPACETRANSFER")]
    public static TransferCharacteristics color_space_transfer (ColorSpace cspace);

    [CCode (cname = "SDL_COLORSPACETYPE")]
    public static ColorType colorsspace_type (ColorSpace cspace);

    [CCode (cname = "SDL_DEFINE_COLORSPACE")]
    public static ColorSpace define_color_space (ColorType type,
        ColorRange range,
        ColorPrimaries primaries,
        TransferCharacteristics transfer,
        MatrixCoefficients matrix,
        ChromaLocation chroma);

    [CCode (cname = "SDL_DEFINE_PIXELFORMAT")]
    public static PixelFormat define_pixelformat_bitmap_order (ColorType type,
        BitmapOrder order,
        PackedLayout layout,
        uint8 bits,
        uint8 bytes);

    [CCode (cname = "SDL_DEFINE_PIXELFORMAT")]
    public static PixelFormat define_pixelformat_packed_order (ColorType type,
        PackedOrder order,
        PackedLayout layout,
        uint8 bits,
        uint8 bytes);

    [CCode (cname = "SDL_DEFINE_PIXELFORMAT")]
    public static PixelFormat define_pixelformat_array_order (ColorType type,
        ArrayOrder order,
        PackedLayout layout,
        uint8 bits,
        uint8 bytes);

    [CCode (cname = "SDL_DEFINE_PIXELFOURCC")]
    public static uint32 define_pixel_fourcc (char a, char b, char c, char d);

    [CCode (cname = "SDL_ISCOLORSPACE_FULL_RANGE")]
    public static bool is_color_space_full_range (ColorSpace cspace);

    [CCode (cname = "SDL_ISCOLORSPACE_LIMITED_RANGE")]
    public static bool is_color_space_limited_range (ColorSpace cspace);

    [CCode (cname = "SDL_ISCOLORSPACE_MATRIX_BT2020_NCL")]
    public static bool is_color_space_matrix_bt2020_ncl (ColorSpace cspace);

    [CCode (cname = "SDL_ISCOLORSPACE_MATRIX_BT601")]
    public static bool is_color_space_matrix_bt601 (ColorSpace cspace);

    [CCode (cname = "SDL_ISCOLORSPACE_MATRIX_BT709")]
    public static bool is_color_space_matrix_bt709 (ColorSpace cspace);

    [CCode (cname = "SDL_ISPIXELFORMAT_10BIT")]
    public static bool is_pixelformat_10bit (PixelFormat format);

    [CCode (cname = "SDL_ISPIXELFORMAT_ALPHA")]
    public static bool is_pixelformat_alpha (PixelFormat format);

    [CCode (cname = "SDL_ISPIXELFORMAT_ARRAY")]
    public static bool is_pixelformat_array (PixelFormat format);

    [CCode (cname = "SDL_ISPIXELFORMAT_FLOAT")]
    public static bool is_pixelformat_float (PixelFormat format);

    [CCode (cname = "SDL_ISPIXELFORMAT_FOURCC")]
    public static bool is_pixelformat_fourcc (PixelFormat format);

    [CCode (cname = "SDL_ISPIXELFORMAT_INDEXED")]
    public static bool is_pixelformat_indexed (PixelFormat format);

    [CCode (cname = "SDL_ISPIXELFORMAT_PACKED")]
    public static bool is_pixelformat_packed (PixelFormat format);

    [CCode (cname = "SDL_PIXELFLAG")]
    public static uint32 pixel_flag (PixelFormat format);

    [CCode (cname = "SDL_PIXELLAYOUT")]
    public static PackedLayout pixel_layout (PixelFormat format);

    [CCode (cname = "SDL_PIXELORDER")]
    public static uint pixel_order (PixelFormat format);

    [CCode (cname = "PIXELTYPE")]
    public static PixelType pixel_type (PixelFormat format);
} // SDL.Pixels

///
/// Blend modes (SDL_blendmode.h)
///
[CCode (cheader_filename = "SDL3/SDL_blendmode.h")]
namespace SDL.BlendModes {
    [CCode (cname = "SDL_ComposeCustomBlendMode")]
    public static BlendMode compose_custom_blend_mode (BlendFactor src_color_factor,
        BlendFactor dst_color_factor,
        BlendOperation color_operation,
        BlendFactor src_alpha_factor,
        BlendFactor dst_alpha_factor,
        BlendOperation alpha_operation);

    [CCode (cname = "uint32", cprefix = "SDL_BLENDMODE_", has_type_id = false)]
    public enum BlendMode {
        NONE,
        BLEND,
        BLEND_PREMULTIPLIED,
        ADD,
        ADD_PREMULTIPLIED,
        MOD,
        MUL,
        INVALID,
    } // BlendMode

    [CCode (cname = "SDL_BlendFactor", cprefix = "SDL_BLENDFACTOR_", has_type_id = false)]
    public enum BlendFactor {
        ZERO,
        ONE,
        SRC_COLOR,
        ONE_MINUS_SRC_COLOR,
        SRC_ALPHA,
        ONE_MINUS_SRC_ALPHA,
        DST_COLOR,
        ONE_MINUS_DST_COLOR,
        DST_ALPHA,
        ONE_MINUS_DST_ALPHA,
    } // BlendFactor;

    [CCode (cname = "SDL_BlendOperation", cprefix = "SDL_BLENDOPERATION_", has_type_id = false)]
    public enum BlendOperation {
        ADD,
        SUBTRACT,
        REV_SUBTRACT,
        MINIMUM,
        MAXIMUM,
    } // BlendOperation;
} // SDL.BlendModes

///
/// Rectangle Functions (SDL_rect.h)
///
[CCode (cheader_filename = "SDL3/SDL_rect.h")]
namespace SDL.Rect {
    [CCode (cname = "SDL_GetRectAndLineIntersection")]
    public static bool get_rect_and_line_intersection (Rect rect, int x1, int y1, int x2, int y2);

    [CCode (cname = "SDL_GetRectAndLineIntersectionFloat")]
    public static bool get_rect_and_line_intersection_float (FRect rect, float x1, float y1, float x2, float y2);

    [CCode (cname = "SDL_GetRectEnclosingPoints")]
    public static bool get_rect_enclosing_points (Point[] points, Rect? clip, out Rect result);

    [CCode (cname = "SDL_GetRectEnclosingPointsFloat")]
    public static bool get_rect_enclosing_points_float (FPoint[] points, FRect? clip, out FRect result);

    [CCode (cname = "SDL_GetRectIntersection")]
    public static bool get_rect_intersection (Rect a, Rect b, out Rect? result);

    [CCode (cname = "SDL_GetRectIntersectionFloat")]
    public static bool get_rect_intersection_float (FRect a, FRect b, out FRect? result);

    [CCode (cname = "SDL_GetRectUnion")]
    public static bool get_rect_union (Rect a, Rect b, out Rect result);

    [CCode (cname = "SDL_GetRectUnionFloat")]
    public static bool get_rect_union_float (FRect a, FRect b, out FRect result);

    [CCode (cname = "SDL_HasRectIntersection")]
    public static bool has_rect_intersection (Rect a, Rect b);

    [CCode (cname = "SDL_HasRectIntersectionFloat")]
    public static bool has_rect_intersection_float (FRect a, FRect b);

    [CCode (cname = "SDL_PointInRect")]
    public static bool point_in_rect (Point p, Rect r);

    [CCode (cname = "SDL_PointInRectFloat")]
    public static bool point_in_rect_float (FPoint p, FRect r);

    [CCode (cname = "SDL_RectEmpty")]
    public static bool rect_empty (Rect? r);

    [CCode (cname = "SDL_RectEmptyFloat")]
    public static bool rect_empty_float (FRect? r);

    [CCode (cname = "SDL_RectsEqual")]
    public static bool rects_equal (Rect a, Rect b);

    [CCode (cname = "SDL_RectsEqualEpsilon")]
    public static bool rects_equal_epsilon (FRect a, FRect b, float epsilon);

    [CCode (cname = "SDL_RectsEqualFloat")]
    public static bool rects_equal_float (FRect a, FRect b);

    [CCode (cname = "SDL_RectToFRect")]
    public static void rect_to_frect (Rect rect, out FRect frect);

    [CCode (cname = "SDL_FPoint", has_type_id = false)]
    public struct FPoint {
        public float x;
        public float y;
    } // FPoint

    [CCode (cname = "SDL_FRect", has_type_id = false)]
    public struct FRect {
        public float x;
        public float y;
        public float w;
        public float h;
    } // FRect

    [CCode (cname = "SDL_Point", has_type_id = false)]
    public struct Point {
        public int x;
        public int y;
    } // Point

    [CCode (cname = "SDL_Rect", has_type_id = false)]
    public struct Rect {
        public int x;
        public int y;
        public int w;
        public int h;
    } // Rect
} // SDL.Rect

///
/// Surface Creation and Simple Drawing  (SDL_surface.h)
///
[CCode (cheader_filename = "SDL3/SDL_surface.h")]
namespace SDL.Surface {
    [CCode (cname = "SDL_AddSurfaceAlternateImage")]
    public static bool add_surface_alternate_image (Surface surface, Surface image);

    [CCode (cname = "SDL_BlitSurface")]
    public static bool blit_surface (Surface src, Rect.Rect? src_rect, Surface dst, Rect.Rect? dst_rect);

    [CCode (cname = "SDL_BlitSurface9Grid")]
    public static bool blit_surface_9grid (Surface src,
        Rect.Rect? src_rect,
        int left_width,
        int right_width,
        int top_height,
        int bottom_height,
        float scale,
        ScaleMode scale_mode,
        Surface dst,
        Rect.Rect? dst_rect);

    [CCode (cname = "SDL_BlitSurfaceScaled")]
    public static bool blit_surface_scaled (Surface src,
        Rect.Rect? src_rect,
        Surface dst,
        Rect.Rect? dst_rect,
        ScaleMode scale_mode);

    [CCode (cname = "SDL_BlitSurfaceTiled")]
    public static bool blit_surface_tiled (Surface src,
        Rect.Rect? src_rect,
        Surface dst,
        Rect.Rect? dst_rect);

    [CCode (cname = "SDL_BlitSurfaceTiledWithScale")]
    public static bool blit_surface_tiled_with_scale (Surface src,
        Rect.Rect? src_rect,
        float scale,
        ScaleMode scale_mode,
        Surface dst,
        Rect.Rect? dst_rect);

    [CCode (cname = "SDL_BlitSurfaceUnchecked")]
    public static bool blit_surface_unchecked (Surface src,
        Rect.Rect? src_rect,
        Surface dst,
        Rect.Rect? dst_rect);

    [CCode (cname = "SDL_BlitSurfaceUncheckedScaled")]
    public static bool blit_surface_unchecked_scaled (Surface src,
        Rect.Rect? src_rect,
        Surface dst,
        Rect.Rect? dst_rect,
        ScaleMode scale_mode);

    [CCode (cname = "SDL_ClearSurface")]
    public static bool clear_surface (Surface surface, float r, float g, float b, float a);

    [CCode (cname = "SDL_ConvertPixels")]
    public static bool convert_pixels (int width,
        int height,
        Pixels.PixelFormat src_format,
        void* src,
        int src_pitch,
        Pixels.PixelFormat dst_format,
        void* dst,
        int dst_pitch);

    [CCode (cname = "SDL_ConvertPixelsAndColorspace")]
    public static bool convert_pixels_and_color_space (int width,
        int height,
        Pixels.PixelFormat src_format,
        Pixels.ColorSpace src_color_space,
        Properties.PropertiesID src_properties,
        void* src,
        int src_pitch,
        Pixels.PixelFormat dst_format,
        Pixels.ColorSpace dst_color_space,
        Properties.PropertiesID dst_properties,
        void* dst,
        int dst_pitch);

    [CCode (cname = "SDL_ConvertSurface")]
    public static Surface ? convert_surface (Surface surface, Pixels.PixelFormat format);

    [CCode (cname = "SDL_ConvertSurfaceAndColorspace")]
    public static Surface ? convert_surface_and_color_space (Surface surface,
        Pixels.PixelFormat format,
        Pixels.Palette palette,
        Pixels.ColorSpace color_space,
        Properties.PropertiesID props);

    [CCode (cname = "SDL_CreateSurface")]
    public static Surface ? create_surface (int width, int height, Pixels.PixelFormat format);

    [CCode (cname = "SDL_CreateSurfaceFrom")]
    public static Surface ? create_surface_from (int width,
        int height,
        Pixels.PixelFormat format,
        void* pixels,
        int pitch);

    [CCode (cname = "SDL_CreateSurfacePalette")]
    public static Pixels.Palette ? create_surface_palette (Surface surface);

    [CCode (cname = "SDL_DestroySurface")]
    public static void destroy_surface (Surface surface);

    [CCode (cname = "SDL_DuplicateSurface")]
    public static Surface ? duplicate_surface (Surface surface);

    [CCode (cname = "SDL_FillSurfaceRect")]
    public static bool fill_surface_rect (Surface dst, Rect.Rect? rect, uint32 color);

    [CCode (cname = "SDL_FillSurfaceRects")]
    public static bool fill_surface_rects (Surface dst, Rect.Rect rects, uint32 color);

    [CCode (cname = "SDL_FlipSurface")]
    public static bool flip_surface (Surface surface, FlipMode flip);

    [CCode (cname = "SDL_GetSurfaceAlphaMod")]
    public static bool get_surface_alpha_mod (Surface surface, out uint8 alpha);

    [CCode (cname = "SDL_GetSurfaceBlendMode")]
    public static bool get_surface_blend_mode (Surface surface, BlendModes.BlendMode blend_mode);

    [CCode (cname = "SDL_GetSurfaceClipRect")]
    public static bool get_surface_clip_rect (Surface surface, Rect.Rect rect);

    [CCode (cname = "SDL_GetSurfaceColorKey")]
    public static bool get_surface_color_key (Surface surface, out uint32 key);

    [CCode (cname = "SDL_GetSurfaceColorMod")]
    public static bool get_surface_color_mod (Surface surface, out uint8 r, out uint8 g, out uint8 b);

    [CCode (cname = "SDL_GetSurfaceColorspace")]
    public static Pixels.ColorSpace get_surface_color_space (Surface surface);

    [CCode (cname = "SDL_GetSurfaceImages")]
    public static Surface[] ? get_surface_images (Surface surface);

    [CCode (cname = "SDL_GetSurfacePalette")]
    public static Pixels.Palette ? get_surface_palette (Surface surface);

    [CCode (cname = "SDL_GetSurfaceProperties")]
    public static Properties.PropertiesID get_surface_properties (Surface surface);

    [CCode (cname = "SDL_LoadBMP")]
    public static Surface ? load_bmp (string file);

    [CCode (cname = "SDL_LoadBMP_IO")]
    public static Surface ? load_bmp_io (IOStream.IOStream src, bool close_io);

    [CCode (cname = "SDL_LockSurface")]
    public static bool lock_surface (Surface surface);

    [CCode (cname = "SDL_MapSurfaceRGB")]
    public static uint32 map_surface_rgb (Surface surface, uint8 r, uint8 g, uint8 b);

    [CCode (cname = "SDL_MapSurfaceRGBA")]
    public static uint32 map_surface_rgba (Surface surface, uint8 r, uint8 g, uint8 b, uint8 a);

    [CCode (cname = "SDL_PremultiplyAlpha")]
    public static bool premultiply_alpha (int width,
        int height,
        Pixels.PixelFormat src_format,
        void* src,
        int src_pitch,
        Pixels.PixelFormat dst_format,
        void* dst,
        int dst_pitch,
        bool linear);

    [CCode (cname = "SDL_PremultiplySurfaceAlpha")]
    public static bool premultiply_surface_alpha (Surface surface, bool linear);

    [CCode (cname = "SDL_ReadSurfacePixel")]
    public static bool read_surface_pixel (Surface surface,
        int x,
        int y,
        out uint8 r,
        out uint8 g,
        out uint8 b,
        out uint8 a);

    [CCode (cname = "SDL_ReadSurfacePixelFloat")]
    public static bool read_surface_pixel_float (Surface surface,
        int x,
        int y,
        out float r,
        out float g,
        out float b,
        out float a);

    [CCode (cname = "SDL_RemoveSurfaceAlternateImages")]
    public static void remove_surface_alternate_images (Surface surface);

    [CCode (cname = "SDL_SaveBMP")]
    public static bool save_bmp (Surface surface, string file);

    [CCode (cname = "SDL_SaveBMP_IO")]
    public static bool save_bmp_io (Surface surface, IOStream.IOStream dst, bool close_io);

    [CCode (cname = "SDL_ScaleSurface")]
    public static Surface ? scale_surface (Surface surface, int width, int height, ScaleMode scale_mode);

    [CCode (cname = "SDL_SetSurfaceAlphaMod")]
    public static bool set_surface_alpha_mod (Surface surface, uint8 alpha);

    [CCode (cname = "SDL_SetSurfaceBlendMode")]
    public static bool set_surface_blend_mode (Surface surface, BlendModes.BlendMode blend_mode);

    [CCode (cname = "SDL_SetSurfaceClipRect")]
    public static bool set_surface_clip_rect (Surface surface, Rect.Rect rect);

    [CCode (cname = "SDL_SetSurfaceColorKey")]
    public static bool set_surface_color_key (Surface surface, bool enabled, uint32 key);

    [CCode (cname = "SDL_SetSurfaceColorMod")]
    public static bool set_surface_color_mod (Surface surface, uint8 r, uint8 g, uint8 b);

    [CCode (cname = "SDL_SetSurfaceColorspace")]
    public static bool set_surface_color_space (Surface surface, Pixels.ColorSpace color_space);

    [CCode (cname = "SDL_SetSurfacePalette")]
    public static bool set_surface_palette (Surface surface, Pixels.Palette palette);

    [CCode (cname = "SDL_SetSurfaceRLE")]
    public static bool set_surface_rle (Surface surface, bool enabled);

    [CCode (cname = "SDL_StretchSurface")]
    public static bool stretch_surface (Surface src,
        Rect.Rect src_rect,
        Surface dst,
        Rect.Rect dst_rect,
        ScaleMode scale_mode);

    [CCode (cname = "SDL_SurfaceHasAlternateImages")]
    public static bool surface_has_alternate_images (Surface surface);

    [CCode (cname = "SDL_SurfaceHasColorKey")]
    public static bool surface_has_color_key (Surface surface);

    [CCode (cname = "SDL_SurfaceHasRLE")]
    public static bool surface_has_rle (Surface surface);

    [CCode (cname = "SDL_UnlockSurface")]
    public static void unlock_surface (Surface surface);

    [CCode (cname = "SDL_WriteSurfacePixel")]
    public static bool write_surface_pixel (Surface surface, int x, int y, uint8 r, uint8 g, uint8 b, uint8 a);

    [CCode (cname = "SDL_WriteSurfacePixelFloat")]
    public static bool write_surface_pixel_float (Surface surface, int x, int y, float r, float g, float b, float a);

    [CCode (cname = "SDL_SurfaceFlags", cprefix = "SDL_SURFACE_", has_type_id = false)]
    public enum SurfaceFlags {
        PREALLOCATED,
        LOCK_NEEDED,
        LOCKED,
        SIMD_ALIGNED,
    }

    [Compact, CCode (cname = "SDL_Surface", free_function = "", has_type_id = false)]
    public class Surface {
        public SurfaceFlags flags;
        public Pixels.PixelFormat format;
        public int w;
        public int h;
        public int pitch;
        public void* pixels;
        public int refcount;
        public void* reserved;
    }

    [CCode (cname = "SDL_FlipMode", cprefix = "SDL_FLIP_", has_type_id = false)]
    public enum FlipMode {
        NONE,
        HORIZONTAL,
        VERTICAL,
    } // FlipMode;

    [CCode (cname = "SDL_ScaleMode", cprefix = "SDL_SCALEMODE_", has_type_id = false)]
    public enum ScaleMode {
        NEAREST,
        LINEAR,
    } // ScaleMode;

    [CCode (cname = "SDL_MUSTLOCK")]
    public static bool must_lock (Surface s);

    namespace SDLPropSurface {
        [CCode (cname = "SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT")]
        public const string SDR_WHITE_POINT_FLOAT;

        [CCode (cname = "SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT")]
        public const string HDR_HEADROOM_FLOAT;

        [CCode (cname = "SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING")]
        public const string TONEMAP_OPERATOR_STRING;

        [CCode (cname = "SDL_PROP_SURFACE_HOTSPOT_X_NUMBER")]
        public const string HOTSPOT_X_NUMBER;

        [CCode (cname = "SDL_PROP_SURFACE_HOTSPOT_Y_NUMBER")]
        public const string HOTSPOT_Y_NUMBER;
    } // SDLPropSurface
} // SDL.Surface

///
/// Clipboard Handling  (SDL_clipboard.h)
///
[CCode (cheader_filename = "SDL3/SDL_clipboard.h")]
namespace SDL.Clipboard {
    [CCode (cname = "SDL_ClearClipboardData")]
    public static bool clear_clipboard_data ();

    [CCode (cname = "SDL_GetClipboardData")]
    public static void * get_clipboard_data (string mime_type, out size_t size);

    [CCode (cname = "SDL_GetClipboardMimeTypes")]
    public static unowned string[] get_clipboard_mime_types ();

    [CCode (cname = "SDL_GetClipboardText")]
    public static unowned string get_clipboard_text ();

    [CCode (cname = "SDL_GetPrimarySelectionText")]
    public static unowned string get_primary_selection_text ();

    [CCode (cname = "SDL_HasClipboardData")]
    public static bool has_clipboard_data (string mime_type);

    [CCode (cname = "SDL_HasClipboardText")]
    public static bool has_clipboard_text ();

    [CCode (cname = "SDL_HasPrimarySelectionText")]
    public static bool has_primary_selection_text ();

    [CCode (cname = "SDL_SetClipboardData", has_target = true, instance_pos = 2)]
    public static bool set_clipboard_data (ClipboardDataCallback callback,
        ClipboardCleanupCallback cleanup,
        string[] mime_types);

    [CCode (cname = "SDL_SetClipboardText")]
    public static bool set_clipboard_text (string text);

    [CCode (cname = "SDL_SetPrimarySelectionText")]
    public static bool set_primary_selection_text (string text);

    [CCode (cname = "SDL_ClipboardCleanupCallback", has_target = true)]
    public delegate void ClipboardCleanupCallback ();

    [CCode (cname = "SDL_ClipboardDataCallback", has_target = true, instance_pos = 0)]
    public delegate void ClipboardDataCallback (string mime_type, size_t size);
} // SDL.Clipboard

///
/// Vulkan Support (SDL_vulkan.h)
///
[CCode (cheader_filename = "SDL3/SDL_vulkan.h")]
namespace SDL.Vulkan {
    [CCode (cname = "SDL_Vulkan_CreateSurface")]
    public static bool create_surface (Video.Window window,
        VkInstance instance,
        VkAllocationCallbacks? allocator,
        out VkSurfaceKHR surface);

    [CCode (cname = "SDL_Vulkan_CreateSurface")]
    public static void destroy_surface (VkInstance instance,
        VkSurfaceKHR surface,
        VkAllocationCallbacks? allocator);

    [CCode (cname = "SDL_Vulkan_GetInstanceExtensions")]
    public static unowned string[] get_instance_extensions ();

    [CCode (cname = "SDL_Vulkan_GetPresentationSupport")]
    public static bool get_presentation_support (VkInstance instance,
        VkPhysicalDevice physical_device,
        uint32 queue_family_index);

    [CCode (cname = "SDL_Vulkan_GetVkGetInstanceProcAddr")]
    public static StdInc.FunctionPointer ? get_vk_get_instance_proc_addr ();

    [CCode (cname = "SDL_Vulkan_LoadLibrary")]
    public static bool load_library (string path);

    [CCode (cname = "SDL_Vulkan_UnloadLibrary")]
    public static void unload_library ();

    [CCode (cname = "VkInstance", has_type_id = false)]
    public struct VkInstance {}

    [SimpleType, CCode (cname = "VkSurfaceKHR", has_type_id = false)]
    public struct VkSurfaceKHR : uint64 {}

    [CCode (cname = "VkPhysicalDevice", has_type_id = false)]
    public struct VkPhysicalDevice {}

    [CCode (cname = "VkAllocationCallbacks", has_type_id = false)]
    public struct VkAllocationCallbacks {}
} // SDL.Vulkan

///
/// Metal Support (SDL_metal.h)
///
[CCode (cheader_filename = "SDL3/SDL_metal.h")]
namespace SDL.Metal {
    [CCode (cname = "SDL_Metal_CreateView")]
    public static MetalView create_view (Video.Window window);

    [CCode (cname = "SDL_Metal_DestroyView")]
    public static void destroy_view (MetalView view);

    [CCode (cname = "SDL_Metal_GetLayer")]
    public static void * get_layer (MetalView view);

    [CCode (cname = "SDL_MetalView", destroy_function = "", has_type_id = false)]
    public struct MetalView {}
} // SDL.Metal

///
/// Camera Support (SDL_camera.h)
///
[CCode (cheader_filename = "SDL3/SDL_camera.h")]
namespace SDL.Camera {
    [CCode (cname = "SDL_AcquireCameraFrame")]
    public static Surface.Surface ? aquire_camera_frame (Camera camera, out uint64 timestamp_ns);

    [CCode (cname = "SDL_CloseCamera")]
    public static void close_camera (Camera camera);

    [CCode (cname = "SDL_GetCameraDriver")]
    public static unowned string get_camera_driver (int index);

    [CCode (cname = "SDL_GetCameraFormat")]
    public static bool get_camera_format (Camera camera, out CameraSpec spec);

    [CCode (cname = "SDL_GetCameraID")]
    public static CameraID get_camera_id (Camera camera);

    [CCode (cname = "SDL_GetCameraName")]
    public static unowned string get_camera_name (CameraID instance_id);

    [CCode (cname = "SDL_GetCameraPermissionState")]
    public static int get_camera_permission_state (Camera camera);

    [CCode (cname = "SDL_GetCameraPosition")]
    public static CameraPosition get_camera_position (CameraID instance_id);

    [CCode (cname = "SDL_GetCameraProperties")]
    public static Properties.PropertiesID get_camera_properties (Camera camera);

    [CCode (cname = "SDL_GetCameras")]
    public static CameraID[] ? get_cameras ();

    [CCode (cname = "SDL_GetCameraSupportedFormats")]
    public static CameraSpec[] ? get_camera_supported_formats (CameraID instance_id);

    [CCode (cname = "SDL_GetCurrentCameraDriver")]
    public static unowned string get_current_camera_driver ();

    [CCode (cname = "SDL_GetNumCameraDrivers")]
    public static int get_num_camera_dirvers ();

    [CCode (cname = "SDL_OpenCamera")]
    public static Camera open_camera (CameraID instance_id, CameraSpec? spec);

    [CCode (cname = "SDL_ReleaseCameraFrame")]
    public static void release_camera_frame (Camera camera, Surface.Surface frame);

    [Compact, CCode (cname = "SDL_Camera", free_function = "", has_type_id = false)]
    public class Camera {}

    [SimpleType, CCode (cname = "SDL_CameraID", has_type_id = false)]
    public struct CameraID : uint32 {}

    [CCode (cname = "SDL_CameraSpec", has_type_id = false)]
    public struct CameraSpec {
        public Pixels.PixelFormat format;
        [CCode (cname = "colorspace")] Pixels.ColorSpace color_space;
        public int width;
        public int height;
        public int framerate_numerator;
        public int framerate_denominator;
    } // CameraSpec

    [CCode (cname = "SDL_CameraPosition", cprefix = "SDL_CAMERA_POSITION_", has_type_id = false)]
    public enum CameraPosition {
        UNKNOWN,
        FRONT_FACING,
        BACK_FACING,
    } // CameraPosition
} // SDL.SDL3.Camera

///
/// INPUT EVENTS
///

///
/// Event Handling (SDL_events.h)
///
[CCode (cheader_filename = "SDL3/SDL_events.h")]
namespace SDL.Events {
    [CCode (cname = "SDL_AddEventWatch")]
    public static bool add_event_watch (EventFilter filter);

    [CCode (cname = "SDL_EventEnabled")]
    public static bool event_enabled (EventType type);

    [CCode (cname = "SDL_FilterEvents")]
    public static void filter_events (EventFilter filter);

    [CCode (cname = "SDL_FlushEvent")]
    public static void flush_event (EventType type);

    [CCode (cname = "SDL_GetEventFilter")]
    public static bool get_event_filter (out EventFilter filter);

    [CCode (cname = "SDL_GetWindowFromEvent")]
    public static Video.Window get_window_from_event (Event event);

    [CCode (cname = "SDL_HasEvent")]
    public static bool has_event (EventType type);

    [CCode (cname = "SDL_HasEvents")]
    public static bool has_events (EventType min_type, EventType max_type);

    [CCode (cname = "SDL_PeepEvents")]
    public static int peep_events (Event[] events, EventAction action, EventType min_type, EventType max_type);

    [CCode (cname = "SDL_PollEvent")]
    public static bool poll_event (out Event event);

    [CCode (cname = "SDL_PumpEvents")]
    public static void pump_events ();

    [CCode (cname = "SDL_PushEvent")]
    public static bool push_event (Event event);

    [CCode (cname = "SDL_RegisterEvents")]
    public static uint32 register_events (int num_events);

    [CCode (cname = "SDL_RemoveEventWatch")]
    public static void remove_event_watch (EventFilter filter);

    [CCode (cname = "SDL_SetEventEnabled")]
    public static void set_event_enabled (EventType type, bool enabled);

    [CCode (cname = "SDL_SetEventFilter")]
    public static void set_event_filter (EventFilter filter);

    [CCode (cname = "SDL_WaitEvent")]
    public static bool wait_event (out Event event);

    [CCode (cname = "SDL_WaitEventTimeout")]
    public static bool wait_event_timeout (out Event event, int32 timeout_ms);

    [CCode (cname = "SDL_EventFilter", has_target = true, delegate_target_pos = 0)]
    public delegate int EventFilter (ref Event event);

    [CCode (cname = "SDL_AudioDeviceEvent", has_type_id = false, has_type_id = false)]
    public struct AudioDeviceEvent {
        public EventType type;
        public uint32 reseved;
        public uint64 timestamp;
        public Audio.AudioDeviceID which;
        public bool recording;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
    } // AudioDeviceEvent

    [CCode (cname = "SDL_CameraDeviceEvent", has_type_id = false)]
    public struct CameraDeviceEvent {
        public EventType type;
        public uint32 reseved;
        public uint64 timestamp;
        public Camera.CameraID which;
    } // CameraDeviceEvent

    [CCode (cname = "SDL_ClipboardEvent", has_type_id = false)]
    public struct ClipboardEvent {
        public EventType type;
        public uint32 reseved;
        public uint64 timestamp;
        public bool owner;
        public int32 num_mime_types;
        public string[] mime_types;
    } // ClipboardEvent

    [CCode (cname = "SDL_CommonEvent", has_type_id = false)]
    public struct CommonEvent {
        public EventType type;
        public uint64 timestamp;
    } // CommonEvent

    [CCode (cname = "SDL_DisplayEvent", has_type_id = false)]
    public struct DisplayEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "displayID")]
        public Video.DisplayID display_id;
        public int32 data1;
        public int32 data2;
    } // DisplayEvent

    [CCode (cname = "SDL_DropEvent", has_type_id = false)]
    public struct DropEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public float x;
        public float y;
        public string source;
        public string data;
    } // DropEvent

    [CCode (cname = "SDL_GamepadAxisEvent", has_type_id = false)]
    public struct GamepadAxisEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public uint8 axis;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
        public int16 value;
        public int16 padding4;
    } // GamepadAxisEvent

    [CCode (cname = "SDL_GamepadButtonEvent", has_type_id = false)]
    public struct GamepadButtonEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public uint8 button;
        public bool down;
        public uint8 padding1;
        public uint8 padding2;
    } // GamepadButtonEvent

    [CCode (cname = "SDL_GamepadDeviceEvent", has_type_id = false)]
    public struct GamepadDeviceEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
    } // GamepadDeviceEvent

    [CCode (cname = "SDL_GamepadSensorEvent", has_type_id = false)]
    public struct GamepadSensorEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public int32 sensor;
        public float data[3];
        public uint64 sensor_timestamp;
    } // GamepadSensorEvent

    [CCode (cname = "SDL_GamepadTouchpadEvent", has_type_id = false)]
    public struct GamepadTouchpadEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public int32 touchpad;
        public int32 finger;
        public float x;
        public float y;
        public float pressure;
    } // GamepadTouchpadEvent

    [CCode (cname = "SDL_JoyAxisEvent", has_type_id = false)]
    public struct JoyAxisEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public uint8 axis;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
        public int16 value;
        public uint16 padding4;
    } // JoyAxisEvent

    [CCode (cname = "SDL_JoyBallEvent", has_type_id = false)]
    public struct JoyBallEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public uint8 ball;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
        public int16 xrel;
        public int16 yrel;
    } // JoyBallEvent

    [CCode (cname = "SDL_JoyBatteryEvent", has_type_id = false)]
    public struct JoyBatteryEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public Power.PowerState state;
        public int percent;
    } // JoyBatteryEvent

    [CCode (cname = "SDL_JoyButtonEvent", has_type_id = false)]
    public struct JoyButtonEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public uint8 button;
        public bool down;
        public uint8 padding1;
        public uint8 padding2;
    } // JoyButtonEvent

    [CCode (cname = "SDL_JoyDeviceEvent", has_type_id = false)]
    public struct JoyDeviceEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
    } // JoyDeviceEvent;

    [CCode (cname = "SDL_JoyHatEvent", has_type_id = false)]
    public struct JoyHatEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Joystick.JoystickID which;
        public uint8 hat;
        public uint8 value;
        public uint8 padding1;
        public uint8 padding2;
    } // JoyHatEvent

    [CCode (cname = "SDL_KeyboardDeviceEvent", has_type_id = false)]
    public struct KeyboardDeviceEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Keyboard.KeyboardID which;
    } // KeyboardDeviceEvent

    [CCode (cname = "SDL_KeyboardEvent", has_type_id = false)]
    public struct KeyboardEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Keyboard.KeyboardID which;
        public Keyboard.Scancode scancode;
        public Keyboard.Keycode key;
        public Keyboard.Keymod mod;
        public uint16 raw;
        public bool down;
        public bool repeat;
    } // KeyboardEvent

    [CCode (cname = "SDL_MouseButtonEvent", has_type_id = false)]
    public struct MouseButtonEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Mouse.MouseID which;
        public uint8 button;
        public bool down;
        public uint8 clicks;
        public uint8 padding;
        public float x;
        public float y;
    } // MouseButtonEvent

    [CCode (cname = "SDL_MouseDeviceEvent", has_type_id = false)]
    public struct MouseDeviceEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Mouse.MouseID which;
    } // MouseDeviceEvent

    [CCode (cname = "SDL_MouseMotionEvent", has_type_id = false)]
    public struct MouseMotionEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Mouse.MouseID which;
        public Mouse.MouseButtonFlags state;
        public float x;
        public float y;
        public float xrel;
        public float yrel;
    } // MouseMotionEvent

    [CCode (cname = "SDL_MouseWheelEvent", has_type_id = false)]
    public struct MouseWheelEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Mouse.MouseID which;
        public float x;
        public float y;
        public Mouse.MouseWheelDirection direction;
        public float mouse_x;
        public float mouse_y;
    } // MouseWheelEvent

    [CCode (cname = "SDL_PenAxisEvent", has_type_id = false)]
    public struct PenAxisEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Pen.PenID which;
        public Pen.PenInputFlags pen_state;
        public float x;
        public float y;
        public Pen.PenAxis axis;
        public float value;
    } // PenAxisEvent

    [CCode (cname = "SDL_PenButtonEvent", has_type_id = false)]
    public struct PenButtonEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Pen.PenID which;
        public Pen.PenInputFlags pen_state;
        public float x;
        public float y;
        public uint8 button;
        public bool down;
    } // PenButtonEvent

    [CCode (cname = "SDL_PenMotionEvent", has_type_id = false)]
    public struct PenMotionEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Pen.PenID which;
        public Pen.PenInputFlags pen_state;
        public float x;
        public float y;
    } // PenMotionEvent

    [CCode (cname = "SDL_PenProximityEvent", has_type_id = false)]
    public struct PenProximityEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Pen.PenID which;
    } // PenProximityEvent

    [CCode (cname = "SDL_PenTouchEvent", has_type_id = false)]
    public struct PenTouchEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public Pen.PenID which;
        public Pen.PenInputFlags pen_state;
        public float x;
        public float y;
        public bool eraser;
        public bool down;
    } // PenTouchEvent

    [CCode (cname = "SDL_QuitEvent", has_type_id = false)]
    public struct QuitEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
    } // QuitEvent

    [CCode (cname = "SDL_RenderEvent", has_type_id = false)]
    public struct RenderEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
    } // RenderEvent

    [CCode (cname = "SDL_SensorEvent", has_type_id = false)]
    public struct SensorEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        public Sensor.SensorID which;
        public float data[6];
        public uint64 sensor_timestamp;
    } // SensorEvent

    [CCode (cname = "SDL_TextEditingCandidatesEvent", has_type_id = false)]
    public struct TextEditingCandidatesEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public string[] candidates;
        public int32 num_candidates;
        public int32 selected_candidate;
        public bool horizontal;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
    } // TextEditingCandidatesEvent

    [CCode (cname = "SDL_TextEditingEvent", has_type_id = false)]
    public struct TextEditingEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public string text;
        public int32 start;
        public int32 length;
    } // TextEditingEvent

    [CCode (cname = "TextInputEvent", has_type_id = false)]
    public struct TextInputEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public string text;
    } // TextInputEvent

    [CCode (cname = "SDL_TouchFingerEvent", has_type_id = false)]
    public struct TouchFingerEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "touchID")]
        public Touch.TouchID touch_id;
        [CCode (cname = "fingerID")]
        public Touch.FingerID finger_id;
        public float x;
        public float y;
        public float dx;
        public float dy;
        public float pressure;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
    } // TouchFingerEvent

    [CCode (cname = "SDL_UserEvent", has_type_id = false)]
    public struct UserEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public uint32 code;
        public void* data1;
        public void* data2;
    } // UserEvent

    [CCode (cname = "SDL_WindowEvent", has_type_id = false)]
    public struct WindowEvent {
        public EventType type;
        public uint32 reserved;
        public uint64 timestamp;
        [CCode (cname = "windowID")]
        public Video.WindowID window_id;
        public int32 data1;
        public int32 data2;
    } // WindowEvent

    [CCode (cname = "SDL_Event", has_type_id = false, has_target = false, destroy_function = "")]
    public struct Event {
        public EventType type;
        public CommonEvent common;
        public DisplayEvent display;
        public WindowEvent window;
        public KeyboardDeviceEvent kdevice;
        public KeyboardEvent key;
        public TextEditingEvent edit;
        public TextEditingCandidatesEvent edit_candidates;
        public TextInputEvent text;
        public MouseDeviceEvent mdevice;
        public MouseMotionEvent motion;
        public MouseButtonEvent button;
        public MouseWheelEvent wheel;
        public JoyDeviceEvent jdevice;
        public JoyAxisEvent jaxis;
        public JoyBallEvent jball;
        public JoyHatEvent jhat;
        public JoyButtonEvent jbutton;
        public JoyBatteryEvent jbattery;
        public GamepadDeviceEvent gdevice;
        public GamepadAxisEvent gaxis;
        public GamepadButtonEvent gbutton;
        public GamepadTouchpadEvent gtouchpad;
        public GamepadSensorEvent gsensor;
        public AudioDeviceEvent adevice;
        public CameraDeviceEvent cdevice;
        public SensorEvent sensor;
        public QuitEvent quit;
        public UserEvent user;
        public TouchFingerEvent tfinger;
        public PenProximityEvent pproximity;
        public PenTouchEvent ptouch;
        public PenMotionEvent pmotion;
        public PenButtonEvent pbutton;
        public PenAxisEvent paxis;
        public DropEvent drop;
        public RenderEvent event;
        public ClipboardEvent clipboard;
        // Necesary for ABI compatibility
        public uint8 padding[128];
    } // Event

    [CCode (cname = "SDL_EventAction", cprefix = "SDL_", has_type_id = false)]
    public enum EventAction {
        ADDEVENT,
        PEEKEVENT,
        GETEVENT
    } // EventAction

    [CCode (cname = "SDL_EventType", cprefix = "SDL_EVENT_", has_type_id = false)]
    public enum EventType {
        // Application events
        FIRST,
        QUIT,

        // Application events on ios and android
        TERMINATING,
        LOW_MEMORY,
        WILL_ENTER_BACKGROUND,
        DID_ENTER_BACKGROUND,
        WILL_ENTER_FOREGROUND,
        DID_ENTER_FOREGROUND,
        LOCALE_CHANGED,
        SYSTEM_THEME_CHANGED,

        // Display events
        DISPLAY_ORIENTATION,
        DISPLAY_ADDED,
        DISPLAY_REMOVED,
        DISPLAY_MOVED,
        DISPLAY_DESKTOP_MODE_CHANGED,
        DISPLAY_CURRENT_MODE_CHANGED,
        DISPLAY_CONTENT_SCALE_CHANGED,

        // Window events
        WINDOW_SHOWN,
        WINDOW_HIDDEN,
        WINDOW_EXPOSED,
        WINDOW_MOVED,
        WINDOW_RESIZED,
        WINDOW_PIXEL_SIZE_CHANGED,
        WINDOW_METAL_VIEW_RESIZED,
        WINDOW_MINIMIZED,
        WINDOW_MAXIMIZED,
        WINDOW_RESTORED,
        WINDOW_MOUSE_ENTER,
        WINDOW_MOUSE_LEAVE,
        WINDOW_FOCUS_GAINED,
        WINDOW_FOCUS_LOST,
        WINDOW_CLOSE_REQUESTED,
        WINDOW_HIT_TEST,
        WINDOW_ICCPROF_CHANGED,
        WINDOW_DISPLAY_CHANGED,
        WINDOW_DISPLAY_SCALE_CHANGED,
        WINDOW_SAFE_AREA_CHANGED,
        WINDOW_OCCLUDED,
        WINDOW_ENTER_FULLSCREEN,
        WINDOW_LEAVE_FULLSCREEN,
        WINDOW_DESTROYED,
        WINDOW_HDR_STATE_CHANGED,

        // Keyboard Events
        KEY_DOWN,
        KEY_UP,
        TEXT_EDITING,
        TEXT_INPUT,
        KEYMAP_CHANGED,
        KEYBOARD_ADDED,
        KEYBOARD_REMOVED,
        TEXT_EDITING_CANDIDATES,

        // Mouse events
        MOUSE_MOTION,
        MOUSE_BUTTON_DOWN,
        MOUSE_BUTTON_UP,
        MOUSE_WHEEL,
        MOUSE_ADDED,
        MOUSE_REMOVED,

        // Joystick events
        JOYSTICK_AXIS_MOTION,
        JOYSTICK_HAT_MOTION,
        JOYSTICK_BALL_MOTION,
        JOYSTICK_BUTTON_UP,
        JOYSTICK_BUTTON_DOWN,
        JOYSTICK_REMOVED,
        JOYSTICK_ADDED,
        JOYSTICK_UPDATE_COMPLETE,
        JOYSTICK_BATTERY_UPDATED,

        // Gamepad events
        GAMEPAD_AXIS_MOTION,
        GAMEPAD_BUTTON_DOWN,
        GAMEPAD_BUTTON_UP,
        GAMEPAD_ADDED,
        GAMEPAD_REMOVED,
        GAMEPAD_REMAPPED,
        GAMEPAD_TOUCHPAD_DOWN,
        GAMEPAD_TOUCHPAD_MOTION,
        GAMEPAD_TOUCHPAD_UP,
        GAMEPAD_SENSOR_UPDATE,
        GAMEPAD_UPDATE_COMPLETE,
        GAMEPAD_STEAM_HANDLE_UPDATED,

        // Touch events
        FINGER_DOWN,
        FINGER_UP,
        FINGER_MOTION,
        FINGER_CANCELED,

        // Clipboard events
        CLIPBOARD_UPDATE,

        // Drag and drop events
        DROP_FILE,
        DROP_TEXT,
        DROP_BEGIN,
        DROP_COMPLETE,
        DROP_POSITION,

        // Audio hotplug events
        AUDIO_DEVICE_ADDED,
        AUDIO_DEVICE_REMOVED,
        AUDIO_DEVICE_FORMAT_CHANGED,

        // Sensor events
        SENSOR_UPDATE,

        // Presure sensitive events
        PEN_PROXIMITY_IN,
        PEN_PROXIMITY_OUT,
        PEN_DOWN,
        PEN_UP,
        PEN_BUTTON_DOWN,
        PEN_BUTTON_UP,
        PEN_MOTION,
        PEN_AXIS,

        // Camera hotplug events
        CAMERA_DEVICE_ADDED,
        CAMERA_DEVICE_REMOVED,
        CAMERA_DEVICE_APPROVED,
        CAMERA_DEVICE_DENIED,

        // Render events
        RENDER_TARGETS_RESET,
        RENDER_DEVICE_RESET,
        RENDER_DEVICE_LOST,

        // Reserved events for private platforms
        PRIVATE0,
        PRIVATE1,
        PRIVATE2,
        PRIVATE3,

        // Internal events
        POLL_SENTINEL,

        // EVENT_USER and EVENT_LAST are for your use
        USER,
        LAST,

        // This just makes sure the enum is the size of Uint32 on C
        ENUM_PADDING;

        // This implementes aliases from the enum
        [CCode (cname = "SDL_EVENT_WINDOW_FIRST")]
        public const EventType WINDOW_FIRST;

        [CCode (cname = "SDL_EVENT_WINDOW_LAST")]
        public const EventType WINDOW_LAST;

        [CCode (cname = "SDL_EVENT_DISPLAY_FIRST")]
        public const EventType DISPLAY_FIRST;

        [CCode (cname = "SDL_EVENT_DISPLAY_LAST")]
        public const EventType DISPLAY_LAST;
    } // EventType
} // SDL.Events

///
/// Keyboard Support (SDL_keyboard.h)
///
[CCode (cheader_filename = "SDL3/SDL_keyboard.h")]
namespace SDL.Keyboard {
    [CCode (cname = "SDL_ClearComposition")]
    public static bool clear_composition (Video.Window window);

    [CCode (cname = "SDL_GetKeyboardFocus")]
    public static Video.Window get_keyboard_focus ();

    [CCode (cname = "SDL_GetKeyboardNameForID")]
    public static unowned string get_keyboard_name_for_id (KeyboardID instance_id);

    [CCode (cname = "SDL_GetKeyboards")]
    public static KeyboardID[] get_keyboards ();

    [CCode (cname = "SDL_GetKeyboardState")]
    public static bool[] get_keyboard_state ();

    [CCode (cname = "SDL_GetKeyFromName")]
    public static Keycode get_key_from_name (string name);

    [CCode (cname = "SDL_GetKeyFromScancode")]
    public static Keycode get_key_from_scancode (Keyboard.Scancode scancode, Keyboard.Keymod mod_state, bool key_event);

    [CCode (cname = "SDL_GetKeyName")]
    public static unowned string get_key_name (Keyboard.Keycode key);

    [CCode (cname = "SDL_GetModState")]
    public static Keymod get_mod_state ();

    [CCode (cname = "SDL_GetScancodeFromKey")]
    public static Scancode get_scancode_from_key (Keyboard.Keycode key, Keyboard.Keymod mod_state);

    [CCode (cname = "SDL_GetScancodeFromName")]
    public static Scancode get_scancode_from_name (string name);

    [CCode (cname = "SDL_GetScancodeName")]
    public static unowned string get_scancode_name (Keyboard.Scancode scancode);

    [CCode (cname = "SDL_GetTextInputArea")]
    public static bool get_text_input_area (Video.Window window, out Rect.Rect? rect, out int cursor);

    [CCode (cname = "SDL_HasKeyboard")]
    public static bool has_keyboard ();

    [CCode (cname = "SDL_HasScreenKeyboardSupport")]
    public static bool has_screen_keyboard_support ();

    [CCode (cname = "SDL_ResetKeyboard")]
    public static void reset_keyboard ();

    [CCode (cname = "SDL_ScreenKeyboardShown")]
    public static bool screen_keyboard_shown (Video.Window window);

    [CCode (cname = "SDL_SetModState")]
    public static void set_mod_state (Keyboard.Keymod mod_state);

    [CCode (cname = "SDL_SetScancodeName")]
    public static bool set_scancode_name (Keyboard.Scancode scancode, string name);

    [CCode (cname = "SDL_SetTextInputArea")]
    public static bool set_text_input_area (Video.Window window, Rect.Rect? rect, int cursor);

    [CCode (cname = "SDL_StartTextInput")]
    public static bool start_text_input (Video.Window window);

    [CCode (cname = "SDL_StartTextInputWithProperties")]
    public static bool start_text_input_with_properties (Video.Window window, Properties.PropertiesID props);

    [CCode (cname = "SDL_StopTextInput")]
    public static bool stop_text_input (Video.Window window);

    [CCode (cname = "SDL_TextInputActive")]
    public static bool text_input_active (Video.Window window);

    [SimpleType, CCode (cname = "SDL_KeyboardID", has_type_id = false)]
    public struct KeyboardID : uint32 {}

    [CCode (cname = "SDL_Capitalization", cprefix = "SDL_CAPITALIZE_", has_type_id = false)]
    public enum Capitalization {
        NONE,
        SENTENCES,
        WORDS,
        LETTERS,
    } // Capitalization

    [CCode (cname = "SDL_TextInputType", cprefix = "SDL_TEXTINPUT_TYPE_", has_type_id = false)]
    public enum TextInputType {
        TEXT,
        TEXT_NAME,
        TEXT_EMAIL,
        TEXT_USERNAME,
        TEXT_PASSWORD_HIDDEN,
        TEXT_PASSWORD_VISIBLE,
        NUMBER,
        NUMBER_PASSWORD_HIDDEN,
        NUMBER_PASSWORD_VISIBLE,
    } // TextInputType

    namespace SDLPropTextinput {
        [CCode (cname = "SDL_PROP_TEXTINPUT_TYPE_NUMBER")]
        public const string TYPE_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTINPUT_CAPITALIZATION_NUMBER")]
        public const string CAPITALIZATION_NUMBER;

        [CCode (cname = "SDL_PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN")]
        public const string AUTOCORRECT_BOOLEAN;

        [CCode (cname = "SDL_PROP_TEXTINPUT_MULTILINE_BOOLEAN")]
        public const string MULTILINE_BOOLEAN;

        // Android
        [CCode (cname = "SDL_PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER")]
        public const string ANDROID_INPUTTYPE_NUMBER;
    } // SDLPropTextinput

    ///
    /// Keyboard Keycodes (SDL_keycode.h)
    ///
    [CCode (cheader_filename = "SDL3/SDL_keycode.h", cname = "SDLK_EXTENDED_MASK")]
    public const uint32 SDLK_EXTENDED_MASK;

    [CCode (cheader_filename = "SDL3/SDL_keycode.h", cname = "SDLK_SCANCODE_MASK")]
    public const uint32 SDLK_SCANCODE_MASK;

    [CCode (cheader_filename = "SDL3/SDL_keycode.h", cname = "SDL_SCANCODE_TO_KEYCODE")]
    public static uint32 scancode_to_keycode (uint32 x);

    [CCode (cheader_filename = "SDL3/SDL_keycode.h", cname = "uint32", cprefix = "SDLK_", has_type_id = false)]
    public enum Keycode {
        UNKNOWN,
        RETURN,
        ESCAPE,
        BACKSPACE,
        TAB,
        SPACE,
        EXCLAIM,
        DBLAPOSTROPHE,
        HASH,
        DOLLAR,
        PERCENT,
        AMPERSAND,
        APOSTROPHE,
        LEFTPAREN,
        RIGHTPAREN,
        ASTERISK,
        PLUS,
        COMMA,
        MINUS,
        PERIOD,
        SLASH,
        [CCode (cname = "SDLK_0")]
        ZERO,
        [CCode (cname = "SDLK_1")]
        ONE,
        [CCode (cname = "SDLK_2")]
        TWO,
        [CCode (cname = "SDLK_3")]
        THREE,
        [CCode (cname = "SDLK_4")]
        FOUR,
        [CCode (cname = "SDLK_5")]
        FIVE,
        [CCode (cname = "SDLK_6")]
        SIX,
        [CCode (cname = "SDLK_7")]
        SEVEN,
        [CCode (cname = "SDLK_8")]
        EIGHT,
        [CCode (cname = "SDLK_9")]
        COLON,
        SEMICOLON,
        LESS,
        EQUALS,
        GREATER,
        QUESTION,
        AT,
        LEFTBRACKET,
        BACKSLASH,
        RIGHTBRACKET,
        CARET,
        UNDERSCORE,
        GRAVE,
        A,
        B,
        C,
        D,
        E,
        F,
        G,
        H,
        I,
        J,
        K,
        L,
        M,
        N,
        O,
        P,
        Q,
        R,
        S,
        T,
        U,
        V,
        W,
        X,
        Y,
        Z,
        LEFTBRACE,
        PIPE,
        RIGHTBRACE,
        TILDE,
        DELETE,
        PLUSMINUS,
        CAPSLOCK,
        F1,
        F2,
        F3,
        F4,
        F5,
        F6,
        F7,
        F8,
        F9,
        F10,
        F11,
        F12,
        PRINTSCREEN,
        SCROLLLOCK,
        PAUSE,
        INSERT,
        HOME,
        PAGEUP,
        END,
        PAGEDOWN,
        RIGHT,
        LEFT,
        DOWN,
        UP,
        NUMLOCKCLEAR,
        KP_DIVIDE,
        KP_MULTIPLY,
        KP_MINUS,
        KP_PLUS,
        KP_ENTER,
        KP_1,
        KP_2,
        KP_3,
        KP_4,
        KP_5,
        KP_6,
        KP_7,
        KP_8,
        KP_9,
        KP_0,
        KP_PERIOD,
        APPLICATION,
        POWER,
        KP_EQUALS,
        F13,
        F14,
        F15,
        F16,
        F17,
        F18,
        F19,
        F20,
        F21,
        F22,
        F23,
        F24,
        EXECUTE,
        HELP,
        MENU,
        SELECT,
        STOP,
        AGAIN,
        UNDO,
        CUT,
        COPY,
        PASTE,
        FIND,
        MUTE,
        VOLUMEUP,
        VOLUMEDOWN,
        KP_COMMA,
        KP_EQUALSAS400,
        ALTERASE,
        SYSREQ,
        CANCEL,
        CLEAR,
        PRIOR,
        RETURN2,
        SEPARATOR,
        OUT,
        OPER,
        CLEARAGAIN,
        CRSEL,
        EXSEL,
        KP_00,
        KP_000,
        THOUSANDSSEPARATOR,
        DECIMALSEPARATOR,
        CURRENCYUNIT,
        CURRENCYSUBUNIT,
        KP_LEFTPAREN,
        KP_RIGHTPAREN,
        KP_LEFTBRACE,
        KP_RIGHTBRACE,
        KP_TAB,
        KP_BACKSPACE,
        KP_A,
        KP_B,
        KP_C,
        KP_D,
        KP_E,
        KP_F,
        KP_XOR,
        KP_POWER,
        KP_PERCENT,
        KP_LESS,
        KP_GREATER,
        KP_AMPERSAND,
        KP_DBLAMPERSAND,
        KP_VERTICALBAR,
        KP_DBLVERTICALBAR,
        KP_COLON,
        KP_HASH,
        KP_SPACE,
        KP_AT,
        KP_EXCLAM,
        KP_MEMSTORE,
        KP_MEMRECALL,
        KP_MEMCLEAR,
        KP_MEMADD,
        KP_MEMSUBTRACT,
        KP_MEMMULTIPLY,
        KP_MEMDIVIDE,
        KP_PLUSMINUS,
        KP_CLEAR,
        KP_CLEARENTRY,
        KP_BINARY,
        KP_OCTAL,
        KP_DECIMAL,
        KP_HEXADECIMAL,
        LCTRL,
        LSHIFT,
        LALT,
        LGUI,
        RCTRL,
        RSHIFT,
        RALT,
        RGUI,
        MODE,
        SLEEP,
        WAKE,
        CHANNEL_INCREMENT,
        CHANNEL_DECREMENT,
        MEDIA_PLAY,
        MEDIA_PAUSE,
        MEDIA_RECORD,
        MEDIA_FAST_FORWARD,
        MEDIA_REWIND,
        MEDIA_NEXT_TRACK,
        MEDIA_PREVIOUS_TRACK,
        MEDIA_STOP,
        MEDIA_EJECT,
        MEDIA_PLAY_PAUSE,
        MEDIA_SELECT,
        AC_NEW,
        AC_OPEN,
        AC_CLOSE,
        AC_EXIT,
        AC_SAVE,
        AC_PRINT,
        AC_PROPERTIES,
        AC_SEARCH,
        AC_HOME,
        AC_BACK,
        AC_FORWARD,
        AC_STOP,
        AC_REFRESH,
        AC_BOOKMARKS,
        SOFTLEFT,
        SOFTRIGHT,
        CALL,
        ENDCALL,
        LEFT_TAB,
        LEVEL5_SHIFT,
        MULTI_KEY_COMPOSE,
        LMETA,
        RMETA,
        LHYPER,
        RHYPER,
    } // Keycode

    [CCode (cheader_filename = "SDL3/SDL_keycode.h", cname = "uint16", cprefix = "SDL_KMOD_", has_type_id = false)]
    public enum Keymod {
        NONE,
        LSHIFT,
        RSHIFT,
        LEVEL5,
        LCTRL,
        RCTRL,
        LALT,
        RALT,
        LGUI,
        RGUI,
        NUM,
        CAPS,
        MODE,
        SCROLL,
        CTRL,
        SHIFT,
        ALT,
        GUI,
    } // Keymod

    ///
    /// Keyboard Scancodes (SDL_scancode.h)
    ///
    [CCode (cheader_filename = "SDL3/SDL_scancode.h", cname = "SDL_Scancode", cprefix = "SDL_SCANCODE_", has_type_id = false)]
    public enum Scancode {
        A,
        B,
        C,
        D,
        E,
        F,
        G,
        H,
        I,
        J,
        K,
        L,
        M,
        N,
        O,
        P,
        Q,
        R,
        S,
        T,
        U,
        V,
        W,
        X,
        Y,
        Z,
        [CCode (cname = "SDL_SCANCODE_1")]
        ONE,
        [CCode (cname = "SDL_SCANCODE_2")]
        TWO,
        [CCode (cname = "SDL_SCANCODE_3")]
        THREE,
        [CCode (cname = "SDL_SCANCODE_4")]
        FOUR,
        [CCode (cname = "SDL_SCANCODE_5")]
        FIVE,
        [CCode (cname = "SDL_SCANCODE_6")]
        SIX,
        [CCode (cname = "SDL_SCANCODE_7")]
        SEVEN,
        [CCode (cname = "SDL_SCANCODE_8")]
        EIGHT,
        [CCode (cname = "SDL_SCANCODE_9")]
        NINE,
        [CCode (cname = "SDL_SCANCODE_0")]
        ZERO,
        RETURN,
        ESCAPE,
        BACKSPACE,
        TAB,
        SPACE,
        MINUS,
        EQUALS,
        LEFTBRACKET,
        RIGHTBRACKET,
        BACKSLASH,
        NONUSHASH,
        SEMICOLON,
        APOSTROPHE,
        GRAVE,
        COMMA,
        PERIOD,
        SLASH,
        CAPSLOCK,
        F1,
        F2,
        F3,
        F4,
        F5,
        F6,
        F7,
        F8,
        F9,
        F10,
        F11,
        F12,
        PRINTSCREEN,
        SCROLLLOCK,
        PAUSE,
        INSERT,
        HOME,
        PAGEUP,
        DELETE,
        END,
        PAGEDOWN,
        RIGHT,
        LEFT,
        DOWN,
        UP,
        NUMLOCKCLEAR,
        KP_DIVIDE,
        KP_MULTIPLY,
        KP_MINUS,
        KP_PLUS,
        KP_ENTER,
        KP_1,
        KP_2,
        KP_3,
        KP_4,
        KP_5,
        KP_6,
        KP_7,
        KP_8,
        KP_9,
        KP_0,
        KP_PERIOD,
        NONUSBACKSLASH,
        APPLICATION,
        POWER,
        KP_EQUALS,
        F13,
        F14,
        F15,
        F16,
        F17,
        F18,
        F19,
        F20,
        F21,
        F22,
        F23,
        F24,
        EXECUTE,
        HELP,
        MENU,
        SELECT,
        STOP,
        AGAIN,
        UNDO,
        CUT,
        COPY,
        PASTE,
        FIND,
        MUTE,
        VOLUMEUP,
        VOLUMEDOWN,
        KP_COMMA,
        KP_EQUALSAS400,
        INTERNATIONAL1,
        INTERNATIONAL2,
        INTERNATIONAL3,
        INTERNATIONAL4,
        INTERNATIONAL5,
        INTERNATIONAL6,
        INTERNATIONAL7,
        INTERNATIONAL8,
        INTERNATIONAL9,
        LANG1,
        LANG2,
        LANG3,
        LANG4,
        LANG5,
        LANG6,
        LANG7,
        LANG8,
        LANG9,
        ALTERASE,
        SYSREQ,
        CANCEL,
        CLEAR,
        PRIOR,
        RETURN2,
        SEPARATOR,
        OUT,
        OPER,
        CLEARAGAIN,
        CRSEL,
        EXSEL,
        KP_00,
        KP_000,
        THOUSANDSSEPARATOR,
        DECIMALSEPARATOR,
        CURRENCYUNIT,
        CURRENCYSUBUNIT,
        KP_LEFTPAREN,
        KP_RIGHTPAREN,
        KP_LEFTBRACE,
        KP_RIGHTBRACE,
        KP_TAB,
        KP_BACKSPACE,
        KP_A,
        KP_B,
        KP_C,
        KP_D,
        KP_E,
        KP_F,
        KP_XOR,
        KP_POWER,
        KP_PERCENT,
        KP_LESS,
        KP_GREATER,
        KP_AMPERSAND,
        KP_DBLAMPERSAND,
        KP_VERTICALBAR,
        KP_DBLVERTICALBAR,
        KP_COLON,
        KP_HASH,
        KP_SPACE,
        KP_AT,
        KP_EXCLAM,
        KP_MEMSTORE,
        KP_MEMRECALL,
        KP_MEMCLEAR,
        KP_MEMADD,
        KP_MEMSUBTRACT,
        KP_MEMMULTIPLY,
        KP_MEMDIVIDE,
        KP_PLUSMINUS,
        KP_CLEAR,
        KP_CLEARENTRY,
        KP_BINARY,
        KP_OCTAL,
        KP_DECIMAL,
        KP_HEXADECIMAL,
        LCTRL,
        LSHIFT,
        LALT,
        LGUI,
        RCTRL,
        RSHIFT,
        RALT,
        RGUI,
        MODE,
        SLEEP,
        WAKE,
        CHANNEL_INCREMENT,
        CHANNEL_DECREMENT,
        MEDIA_PLAY,
        MEDIA_PAUSE,
        MEDIA_RECORD,
        MEDIA_FAST_FORWARD,
        MEDIA_REWIND,
        MEDIA_NEXT_TRACK,
        MEDIA_PREVIOUS_TRACK,
        MEDIA_STOP,
        MEDIA_EJECT,
        MEDIA_PLAY_PAUSE,
        MEDIA_SELECT,
        AC_NEW,
        AC_OPEN,
        AC_CLOSE,
        AC_EXIT,
        AC_SAVE,
        AC_PRINT,
        AC_PROPERTIES,
        AC_SEARCH,
        AC_HOME,
        AC_BACK,
        AC_FORWARD,
        AC_STOP,
        AC_REFRESH,
        AC_BOOKMARKS,
        SOFTLEFT,
        SOFTRIGHT,
        CALL,
        ENDCALL,
        RESERVED,
        COUNT,
    } // Scancode
} // SDL.Keyboard

///
/// Mouse Support (SDL_mouse.h)
///
[CCode (cheader_filename = "SDL3/SDL_mouse.h")]
namespace SDL.Mouse {
    [CCode (cname = "SDL_CaptureMouse")]
    public static bool capture_mouse (bool enabled);

    [CCode (cname = "SDL_CreateColorCursor")]
    public static Cursor ? create_color_cursor (Surface.Surface ssurface, int hot_x, int hot_y);

    [CCode (cname = "SDL_CreateCursor")]
    public static Cursor ? create_cursor ([CCode (array_length = false)] uint8[] data,
        [CCode (array_length = false)] uint8[] mask,
        int w,
        int h,
        int hot_x,
        int hot_y);

    [CCode (cname = "SDL_CreateSystemCursor")]
    public static Cursor ? create_system_cursor (SystemCursor id);

    [CCode (cname = "SDL_CursorVisible")]
    public static bool cursor_visible ();

    [CCode (cname = "SDL_DestroyCursor")]
    public static void destroy_cursor (Cursor cursor);

    [CCode (cname = "SDL_GetCursor")]
    public static Cursor ? get_cursor ();

    [CCode (cname = "SDL_GetDefaultCursor")]
    public static Cursor ? get_default_cursor ();

    [CCode (cname = "SDL_GetGlobalMouseState")]
    public static MouseButtonFlags get_global_mouse_button_state (out float x, out float y);

    [CCode (cname = "SDL_GetMice")]
    public static MouseID[] get_mice ();

    [CCode (cname = "SDL_GetMouseFocus")]
    public static Video.Window get_mouse_focus ();

    [CCode (cname = "SDL_GetMouseNameForID")]
    public static unowned string ? get_mouse_name_for_id (MouseID instance_id);

    [CCode (cname = "SDL_GetMouseState")]
    public static MouseButtonFlags get_mouse_state (out float x, out float y);

    [CCode (cname = "SDL_GetRelativeMouseState")]
    public static MouseButtonFlags get_relative_mouse_state (out float x, out float y);

    [CCode (cname = "SDL_GetWindowMouseGrab")]
    public static bool get_window_mouse_grab (Video.Window window);

    [CCode (cname = "SDL_GetWindowMouseRect")]
    public static Rect.Rect ? get_window_mouse_rect (Video.Window window);

    [CCode (cname = "SDL_GetWindowRelativeMouseMode")]
    public static bool get_window_relative_mouse_mode (Video.Window window);

    [CCode (cname = "SDL_HasMouse")]
    public static bool has_mouse ();

    [CCode (cname = "SDL_HideCursor")]
    public static bool hide_cursor ();

    [CCode (cname = "SDL_SetCursor")]
    public static bool set_cursor (Cursor cursor);

    [CCode (cname = "SDL_SetWindowMouseGrab")]
    public static bool set_window_mouse_grab (Video.Window window, bool grabbed);

    [CCode (cname = "SDL_SetWindowMouseRect")]
    public static bool set_window_mouse_rect (Video.Window window, Rect.Rect rect);

    [CCode (cname = "SDL_SetWindowRelativeMouseMode")]
    public static bool set_window_relative_mouse_mode (Video.Window window, bool enabled);

    [CCode (cname = "SDL_ShowCursor")]
    public static bool show_cursor ();

    [CCode (cname = "SDL_WarpMouseGlobal")]
    public static bool warp_mouse_gobal (float x, float y);

    [CCode (cname = "SDL_WarpMouseInWindow")]
    public static void warp_mouse_in_window (Video.Window window, float x, float y);

    [Compact, CCode (cname = "SDL_Cursor", free_function = "", has_type_id = false)]
    public class Cursor {}

    [Flags, CCode (cname = "SDL_MouseButtonFlags", cprefix = "SDL_BUTTON_", has_type_id = false)]
    public enum MouseButtonFlags {
        LEFT,
        MIDDLE,
        RIGHT,
        X1,
        X2,
    } // MouseButtonFlags

    [SimpleType, CCode (cname = "SDL_MouseID", has_type_id = false)]
    public struct MouseID : uint32 {}

    [CCode (cname = "SDL_MouseWheelDirection", cprefix = "SDL_MOUSEWHEEL_", has_type_id = false)]
    public enum MouseWheelDirection {
        NORMAL,
        FLIPPED,
    } // MouseWheelDirection

    [CCode (cname = "SDL_SystemCursor", cprefix = "SDL_SYSTEM_CURSOR_", has_type_id = false)]
    public enum SystemCursor {
        DEFAULT,
        TEXT,
        WAIT,
        CROSSHAIR,
        PROGRESS,
        NWSE_RESIZE,
        NESW_RESIZE,
        EW_RESIZE,
        NS_RESIZE,
        MOVE,
        NOT_ALLOWED,
        POINTER,
        NW_RESIZE,
        N_RESIZE,
        NE_RESIZE,
        E_RESIZE,
        SE_RESIZE,
        S_RESIZE,
        SW_RESIZE,
        W_RESIZE,
        COUNT,
    } // SystemCursor
} // SDL.Mouse

///
/// Joystick Support (SDL_joystick.h)
///
[CCode (cheader_filename = "SDL3/SDL_joystick.h")]
namespace SDL.Joystick {
    [CCode (cname = "SDL_AttachVirtualJoystick")]
    public static JoystickID attach_virtual_joystick (VirtualJoystickDesc desc);

    [CCode (cname = "SDL_CloseJoystick")]
    public static void close_joystick (Joystick joystick);

    [CCode (cname = "SDL_DetachVirtualJoystick")]
    public static bool detach_virtual_joystick (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickAxis")]
    public static int16 get_joystick_axis (Joystick joystick, int axis);

    [CCode (cname = "SDL_GetJoystickAxisInitialState")]
    public static bool get_joystick_axis_initial_state (Joystick joystick, int axis, out int16 state);

    [CCode (cname = "SDL_GetJoystickBall")]
    public static bool get_joystick_ball (Joystick joystick, int ball, out int dx, out int dy);

    [CCode (cname = "SDL_GetJoystickButton")]
    public static bool get_joystick_button (Joystick joystick, int button);

    [CCode (cname = "SDL_GetJoystickConnectionState")]
    public static JoystickConnectionState get_joystick_connection_state (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickFirmwareVersion")]
    public static uint16 get_joystick_firmware_version (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickFromID")]
    public static Joystick ? get_joystick_from_id (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickFromPlayerIndex")]
    public static Joystick ? get_joystick_from_player_index (int player_index);

    [CCode (cname = "SDL_GetJoystickGUID")]
    public static Guid.Guid get_joystick_guid (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickGUIDForID")]
    public static Guid.Guid get_joystick_guid_for_id (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickGUIDInfo")]
    public static void get_joystick_guid_info (Guid.Guid guid,
        out uint16 vendor,
        out uint16 product,
        out uint16 version,
        out uint16 crc16);

    [CCode (cname = "SDL_GetJoystickHat")]
    public static JoystickHat get_joystick_hat (Joystick joystick, int hat);

    [CCode (cname = "Uint8", cprefix = "SDL_HAT_", has_type_id = false)]
    public enum JoystickHat {
        CENTERED,
        UP,
        RIGHT,
        DOWN,
        LEFT,
        RIGHTUP,
        RIGHTDOWN,
        LEFTUP,
        LEFTDOWN,
    } // JoystickHat

    [CCode (cname = "SDL_GetJoystickID")]
    public static JoystickID get_joystick_id (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickName")]
    public static unowned string get_joystick_name (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickNameForID")]
    public static unowned string get_joystick_name_for_id (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickPath")]
    public static unowned string get_joystick_path (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickPathForID")]
    public static unowned string get_joystick_path_for_id (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickPlayerIndex")]
    public static int get_joystick_player_index (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickPlayerIndexForID")]
    public static int get_joystick_player_for_id (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickPowerInfo")]
    public static Power.PowerState get_joystick_power_info (Joystick joystick, out int percent);

    [CCode (cname = "SDL_GetJoystickProduct")]
    public static uint16 get_joystick_product (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickProductForID")]
    public static uint16 get_joystick_product_for_id (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickProductVersion")]
    public static uint16 get_joystick_product_version (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickProductVersionForID")]
    public static uint16 get_joystick_product_version_for_id (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickProperties")]
    public static Properties.PropertiesID get_joystick_properties (Joystick joystick);

    [CCode (cname = "SDL_GetJoysticks")]
    public static JoystickID[] get_joysticks ();

    [CCode (cname = "SDL_GetJoystickSerial")]
    public static unowned string get_joystick_serial (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickType")]
    public static JoystickType get_joystick_type (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickTypeForID")]
    public static JoystickType get_joystick_type_for_id (JoystickID instance_id);

    [CCode (cname = "SDL_GetJoystickVendor")]
    public static uint16 get_joystick_vendor (Joystick joystick);

    [CCode (cname = "SDL_GetJoystickVendorForID")]
    public static uint16 get_joystick_vendor_for_id (Joystick joystick);

    [CCode (cname = "SDL_GetNumJoystickAxes")]
    public static int get_num_joystick_axes (Joystick joystick);

    [CCode (cname = "SDL_GetNumJoystickBalls")]
    public static int get_num_joystick_balls (Joystick joystick);

    [CCode (cname = "SDL_GetNumJoystickButtons")]
    public static int get_num_joystick_buttons (Joystick joystick);

    [CCode (cname = "SDL_GetNumJoystickHats")]
    public static int get_num_joystick_hats (Joystick joystick);

    [CCode (cname = "SDL_HasJoystick")]
    public static bool has_joystick ();

    [CCode (cname = "SDL_IsJoystickVirtual")]
    public static bool is_joystick_virtual (JoystickID instance_id);

    [CCode (cname = "SDL_JoystickConnected")]
    public static bool joystick_connected (Joystick joystick);

    [CCode (cname = "SDL_JoystickEventsEnabled")]
    public static bool joystick_events_enabled ();

    [CCode (cname = "SDL_LockJoysticks")]
    public static void lock_joysticks ();

    [CCode (cname = "SDL_OpenJoystick")]
    public static Joystick ? open_joystick (JoystickID instance_id);

    [CCode (cname = "SDL_RumbleJoystick")]
    public static bool rumble_joystick (Joystick joystick,
        uint16 low_frequency_rumble,
        uint16 high_frequency_rumble,
        uint32 duration_ms);

    [CCode (cname = "SDL_RumbleJoystickTriggers")]
    public static bool rumble_joystick_triggers (Joystick joystick,
        uint16 left_rumble,
        uint16 right_rumble,
        uint32 duration_ms);

    [CCode (cname = "SDL_SendJoystickEffect")]
    public static bool send_joystick_effect (Joystick joystick, void* data, int size);

    [CCode (cname = "SDL_SendJoystickVirtualSensorData")]
    public static bool send_joystick_virtual_sensor_data (Joystick joystick,
        Sensor.SensorType type,
        uint64 sensor_timestamp,
        float[] data);

    [CCode (cname = "SDL_SetJoystickEventsEnabled")]
    public static void set_joystick_events_enabled (bool enabled);

    [CCode (cname = "SDL_SetJoystickLED")]
    public static bool set_joystick_led (Joystick joystick, uint8 red, uint8 green, uint8 blue);

    [CCode (cname = "SDL_SetJoystickPlayerIndex")]
    public static bool set_joystick_player_index (Joystick joystick, int player_index);

    [CCode (cname = "SDL_SetJoystickVirtualAxis")]
    public static bool set_joystick_virtual_axis (Joystick joystick, int axis, int16 value);

    [CCode (cname = "SDL_SetJoystickVirtualBall")]
    public static bool set_joystick_virtual_ball (Joystick joystick, int ball, int16 xrel, int16 yrel);

    [CCode (cname = "SDL_SetJoystickVirtualButton")]
    public static bool set_joystick_virtual_button (Joystick joystick, int button, bool down);

    [CCode (cname = "SDL_SetJoystickVirtualHat")]
    public static bool set_joystick_virtual_hat (Joystick joystick, int hat, JoystickHat value);

    [CCode (cname = "SDL_SetJoystickVirtualTouchpad")]
    public static bool set_joystick_virtual_touchpad (Joystick joystick,
        int touchpad,
        int finger,
        bool down,
        float x,
        float y,
        float pressure);

    [CCode (cname = "SDL_UnlockJoysticks")]
    public static void unlock_joystick ();

    [CCode (cname = "SDL_UpdateJoysticks")]
    public static void update_joystick ();

    [Compact, CCode (cname = "SDL_Joystick", free_function = "", has_type_id = false)]
    public class Joystick {}

    [SimpleType, CCode (cname = "SDL_JoystickID", has_type_id = false)]
    public struct JoystickID : uint32 {}

    [CCode (cname = "SDL_VirtualJoystickDesc", has_type_id = false)]
    public struct VirtualJoystickDesc {
        public uint32 version;
        public uint16 type;
        public uint16 padding;
        public uint16 vendor_id;
        public uint16 product_id;
        public uint16 naxes;
        public uint16 nbuttons;
        public uint16 nballs;
        public uint16 nhats;
        public uint16 ntouchpads;
        public uint16 nsensors;
        public uint16 padding2[2];
        public uint32 button_mask;
        public uint32 axis_mask;
        public string name;
        public VirtualJoystickTouchpadDesc touchpads;
        public VirtualJoystickSensorDesc sensors;
        public void* userdata;

        [CCode (cname = "Update", has_target = true, instance_pos = 0)]
        public void update ();

        [CCode (cname = "SetPlayerIndex", has_target = true, instance_pos = 0)]
        public void set_player_index (int player_index);

        [CCode (cname = "Rumble", has_target = true, instance_pos = 0)]
        public bool rumble (uint16 low_frequency_rumble, uint16 high_frequency_rumble);

        [CCode (cname = "RumbleTriggers", has_target = true, instance_pos = 0)]
        public bool rumble_triggers (uint16 left_rumble, uint16 right_rumble);

        [CCode (cname = "SetLED", has_target = true, instance_pos = 0)]
        public bool set_led (uint8 red, uint8 green, uint8 blue);

        [CCode (cname = "SendEffect", has_target = true, instance_pos = 0)]
        public bool send_effect (void* data, int size);

        [CCode (cname = "SetSensorsEnabled", has_target = true, instance_pos = 0)]
        public bool set_sensors_enabled (bool enabled);

        [CCode (cname = "Cleanup", has_target = true)]
        public void cleanup ();
    } // VirtualJoystickDesc

    [CCode (cname = "SDL_VirtualJoystickSensorDesc", has_type_id = false)]
    public struct VirtualJoystickSensorDesc {
        public Sensor.SensorType type;
        public float rate;
    } // VirtualJoystickSensorDesc

    [CCode (cname = "SDL_VirtualJoystickTouchpadDesc", has_type_id = false)]
    public struct VirtualJoystickTouchpadDesc {
        public uint16 nfingers;
        public uint16 padding[3];
    } // VirtualJoystickTouchpadDesc

    [CCode (cname = "SDL_JoystickConnectionState", cprefix = "SDL_JOYSTICK_CONNECTION_", has_type_id = false)]
    public enum JoystickConnectionState {
        INVALID,
        UNKNOWN,
        WIRED,
        WIRELESS,
    } // JoystickConnectionState

    [CCode (cname = "SDL_JoystickType", cprefix = "SDL_JOYSTICK_TYPE_", has_type_id = false)]
    public enum JoystickType {
        UNKNOWN,
        GAMEPAD,
        WHEEL,
        ARCADE_STICK,
        FLIGHT_STICK,
        DANCE_PAD,
        GUITAR,
        DRUM_KIT,
        ARCADE_PAD,
        THROTTLE,
        COUNT,
    } // JoystickType

    [CCode (cname = "SDL_JOYSTICK_AXIS_MAX")]
    public const int32 JOYSTICK_AXIS_MAX;

    [CCode (cname = "SDL_JOYSTICK_AXIS_MIN")]
    public const int32 JOYSTICK_AXIS_MIN;

    namespace SDLPropJoystick {
        [CCode (cname = "SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN")]
        public const string CAP_MONO_LED_BOOLEAN;

        [CCode (cname = "SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN")]
        public const string CAP_RGB_LED_BOOLEAN;

        [CCode (cname = "SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN")]
        public const string CAP_PLAYER_LED_BOOLEAN;

        [CCode (cname = "SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN")]
        public const string CAP_RUMBLE_BOOLEAN;

        [CCode (cname = "SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN")]
        public const string CAP_TRIGGER_RUMBLE_BOOLEAN;
    } // SDLPropJoystick
} // SDL.Joystick

///
/// Gamepad Support (SDL_gamepad.h)
///
[CCode (cheader_filename = "SDL3/SDL_gamepad.h")]
namespace SDL.Gamepad {
    [CCode (cname = "SDL_AddGamepadMapping")]
    public static int add_gamepad_mapping (string mapping);

    [CCode (cname = "SDL_AddGamepadMappingsFromFile")]
    public static int add_gamepad_mappings_from_file (string file);

    [CCode (cname = "SDL_AddGamepadMappingsFromIO")]
    public static int add_gamepad_mapping_from_io (IOStream.IOStream src, bool close_io);

    [CCode (cname = "SDL_CloseGamepad")]
    public static void close_gamepad (Gamepad gamepad);

    [CCode (cname = "SDL_GamepadConnected")]
    public static bool gamepad_connected (Gamepad gamepad);

    [CCode (cname = "SDL_GamepadEventsEnabled")]
    public static bool gamepad_events_enabled ();

    [CCode (cname = "SDL_GamepadHasAxis")]
    public static bool gamepad_has_axis (Gamepad gamepad, GamepadAxis axis);

    [CCode (cname = "SDL_GamepadHasButton")]
    public static bool gamepad_has_button (Gamepad gamepad, GamepadButton button);

    [CCode (cname = "SDL_GamepadHasSensor")]
    public static bool gamepad_has_sensor (Gamepad gamepad, Sensor.SensorType type);

    [CCode (cname = "SDL_GamepadSensorEnabled")]
    public static bool gamepad_sensor_enabled (Gamepad gamepad, Sensor.SensorType type);

    [CCode (cname = "SDL_GetGamepadAppleSFSymbolsNameForAxis")]
    public static unowned string get_gamepad_apple_sfs_symbol_name_for_axis (Gamepad gamepad, GamepadAxis axis);

    [CCode (cname = "SDL_GetGamepadAppleSFSymbolsNameForButton")]
    public static unowned string get_gamepad_apple_sfs_symbol_name_for_button (Gamepad gamepad, GamepadButton button);

    [CCode (cname = "SDL_GetGamepadAxis")]
    public static int16 get_gamepad_axis (Gamepad gamepad, GamepadAxis axis);

    [CCode (cname = "SDL_GetGamepadAxisFromString")]
    public static GamepadAxis get_gamepad_axis_from_string (string str);

    [CCode (cname = "SDL_GetGamepadBindings")]
    public static GamepadBinding[] ? get_gamepad_bindings (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadButton")]
    public static bool get_gamepad_button (Gamepad gamepad, GamepadButton button);

    [CCode (cname = "SDL_GetGamepadButtonFromString")]
    public static GamepadButton get_gamepad_button_from_string (string str);

    [CCode (cname = "SDL_GetGamepadButtonLabel")]
    public static GamepadButtonLabel get_gamepad_button_label (Gamepad gamepad, GamepadButton button);

    [CCode (cname = "SDL_GetGamepadButtonLabelForType")]
    public static GamepadButtonLabel get_gamepad_button_label_for_type (GamepadType type, GamepadButton button);

    [CCode (cname = "SDL_GetGamepadConnectionState")]
    public static Joystick.JoystickConnectionState get_gamepad_connection_state (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadFirmwareVersion")]
    public static uint16 get_gamepad_firmware_version (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadFromID")]
    public static Gamepad ? get_gamepad_from_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadFromPlayerIndex")]
    public static Gamepad ? get_gamepad_from_player_index (int player_index);

    [CCode (cname = "SDL_GetGamepadGUIDForID")]
    public static Guid.Guid get_gamepad_guid_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadID")]
    public static Joystick.JoystickID get_gamepad_id (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadJoystick")]
    public static Joystick.Joystick ? get_gamepad_joystick (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadMapping")]
    public static unowned string ? get_gamepad_mapping (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadMappingForGUID")]
    public static unowned string ? get_gamepad_mapping_for_guid (Guid.Guid guid);

    [CCode (cname = "SDL_GetGamepadMappingForID")]
    public static unowned string ? get_gamepad_mapping_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadMappings")]
    public static unowned string[] ? get_gamepad_mappings ();

    [CCode (cname = "SDL_GetGamepadName")]
    public static unowned string ? get_gamepad_name (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadNameForID")]
    public static unowned string ? get_gamepad_name_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadPath")]
    public static unowned string ? get_gamepad_path (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadPathForID")]
    public static unowned string ? get_gamepad_path_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadPlayerIndex")]
    public static int get_gamepad_player_index (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadPlayerIndexForID")]
    public static int get_gamepad_player_index_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadPowerInfo")]
    public static Power.PowerState get_gamepad_power_info (Gamepad gamepad, out int percent);

    [CCode (cname = "SDL_GetGamepadProduct")]
    public static uint16 get_gamepad_product (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadProductForID")]
    public static uint16 get_gamepad_product_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadProductVersion")]
    public static uint16 get_gamepad_product_version (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadProductVersionForID")]
    public static uint16 get_gamepad_product_version_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadProperties")]
    public static Properties.PropertiesID get_gamepad_properties (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepads")]
    public static Joystick.JoystickID[] get_gamepads ();

    [CCode (cname = "SDL_GetGamepadSensorData")]
    public static bool get_gamepad_sensor_data (Gamepad gamepad, Sensor.SensorType type, out float[] data);

    [CCode (cname = "SDL_GetGamepadSensorDataRate")]
    public static float get_gamepad_sensor_data_rate (Gamepad gamepad, Sensor.SensorType type);

    [CCode (cname = "SDL_GetGamepadSerial")]
    public static unowned string get_gamepad_serial (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadSteamHandle")]
    public static uint64 get_gamepad_steam_handle (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadStringForAxis")]
    public static unowned string ? get_gamepad_string_for_axis (GamepadAxis axis);

    [CCode (cname = "SDL_GetGamepadStringForButton")]
    public static unowned string ? get_gamepad_string_for_button (GamepadButton button);

    [CCode (cname = "SDL_GetGamepadStringForType")]
    public static unowned string ? get_gamepad_string_for_type (GamepadType type);

    [CCode (cname = "SDL_GetGamepadTouchpadFinger")]
    public static bool get_gamepad_touchpad_finger (Gamepad gamepad,
        int touchpad,
        int finger,
        out bool down,
        out float x,
        out float y,
        out float pressure);

    [CCode (cname = "SDL_GetGamepadType")]
    public static GamepadType get_gamepad_type (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadTypeForID")]
    public static GamepadType get_gamepad_type_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetGamepadTypeFromString")]
    public static GamepadType get_gamepad_type_from_string (string str);

    [CCode (cname = "SDL_GetGamepadVendor")]
    public static uint16 get_gamepad_vendor (Gamepad gamepad);

    [CCode (cname = "SDL_GetGamepadVendorForID")]
    public static uint16 get_gamepad_vendor_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_GetNumGamepadTouchpadFingers")]
    public static int get_num_gamepad_touchpad_fingers (Gamepad gamepad, int touchpad);

    [CCode (cname = "SDL_GetNumGamepadTouchpads")]
    public static int get_num_gamepad_touchpads (Gamepad gamepad);

    [CCode (cname = "SDL_GetRealGamepadType")]
    public static GamepadType get_real_gamepad_type (Gamepad gamepad);

    [CCode (cname = "SDL_GetRealGamepadTypeForID")]
    public static GamepadType get_real_gamepad_type_for_id (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_HasGamepad")]
    public static bool has_gamepad ();

    [CCode (cname = "SDL_IsGamepad")]
    public static bool is_gamepad (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_OpenGamepad")]
    public static Gamepad ? open_gamepad (Joystick.JoystickID instance_id);

    [CCode (cname = "SDL_ReloadGamepadMappings")]
    public static bool reload_gamepad_mappings ();

    [CCode (cname = "SDL_RumbleGamepad")]
    public static bool rumble_gamepad (Gamepad gamepad,
        uint16 low_frequency_rumble,
        uint16 high_frequency_rumble,
        uint32 duration_ms);

    [CCode (cname = "SDL_RumbleGamepadTriggers")]
    public static bool rumble_gamepad_triggers (Gamepad gamepad,
        uint16 left_rumble,
        uint16 right_rumble,
        uint32 duration_ms);

    [CCode (cname = "SDL_SendGamepadEffect")]
    public static bool send_gamepad_effect (Gamepad gamepad, void* data, int size);

    [CCode (cname = "SDL_SetGamepadEventsEnabled")]
    public static void set_gamepad_events_enabled (bool enabled);

    [CCode (cname = "SDL_SetGamepadLED")]
    public static bool set_gamepad_led (Gamepad gamepad, uint8 red, uint8 green, uint8 blue);

    [CCode (cname = "SDL_SetGamepadMapping")]
    public static bool set_gamepad_mapping (Joystick.JoystickID instance_id, string mapping);

    [CCode (cname = "SDL_SetGamepadPlayerIndex")]
    public static bool set_gamepad_player_index (Gamepad gamepad, int player_index);

    [CCode (cname = "SDL_SetGamepadSensorEnabled")]
    public static bool set_gamepad_sensor_enabled (Gamepad gamepad, Sensor.SensorType type, bool enabled);

    [CCode (cname = "SDL_UpdateGamepads")]
    public static void update_gamepads ();

    [Compact, CCode (cname = "SDL_Gamepad", free_function = "", has_type_id = false)]
    public class Gamepad {}

    [CCode (cname = "SDL_GamepadBinding", has_type_id = false)]
    public struct GamepadBinding {
        public GamepadBindingType input_type;

        [CCode (cname = "input.button")]
        public int input_button;
        [CCode (cname = "input.axis.axis")]
        public int input_axis;
        [CCode (cname = "inputaxis.axis_min")]
        public int input_axis_min;
        [CCode (cname = "input.axis.axis_max")]
        public int input_axis_max;
        [CCode (cname = "input.hat.hat")]
        public int input_hat;
        [CCode (cname = "input.hat.hat_mask")]
        public int input_hat_mask;

        public GamepadBindingType output_type;

        [CCode (cname = "output.button")]
        public GamepadButton output_button;
        [CCode (cname = "output.axis.axis")]
        public GamepadAxis output_axis;
        [CCode (cname = "output.axis.axis_min")]
        public GamepadAxis output_axis_min;
        [CCode (cname = "output.axis.axis_max")]
        public GamepadAxis output_axis_max;
    } // GamepadBinding;

    [CCode (cname = "SDL_GamepadAxis", cprefix = "SDL_GAMEPAD_AXIS_", has_type_id = false)]
    public enum GamepadAxis {
        INVALID,
        LEFTX,
        LEFTY,
        RIGHTX,
        RIGHTY,
        LEFT_TRIGGER,
        RIGHT_TRIGGER,
        COUNT,
    } // GamepadAxis

    [CCode (cname = "SDL_GamepadBindingType", cprefix = "SDL_GAMEPAD_BINDTYPE_", has_type_id = false)]
    public enum GamepadBindingType {
        NONE,
        BUTTON,
        AXIS,
        HAT,
    } // GamepadBindingType

    [CCode (cname = "SDL_GamepadButton", cprefix = "SDL_GAMEPAD_BUTTON_", has_type_id = false)]
    public enum GamepadButton {
        INVALID,
        SOUTH,
        EAST,
        WEST,
        NORTH,
        BACK,
        GUIDE,
        START,
        LEFT_STICK,
        RIGHT_STICK,
        LEFT_SHOULDER,
        RIGHT_SHOULDER,
        DPAD_UP,
        DPAD_DOWN,
        DPAD_LEFT,
        DPAD_RIGHT,
        MISC1,
        RIGHT_PADDLE1,
        LEFT_PADDLE1,
        RIGHT_PADDLE2,
        LEFT_PADDLE2,
        TOUCHPAD,
        MISC2,
        MISC3,
        MISC4,
        MISC5,
        MISC6,
        COUNT,
    } // GamepadButton

    [CCode (cname = "SDL_GamepadButtonLabel", cprefix = "SDL_GAMEPAD_BUTTON_LABEL_", has_type_id = false)]
    public enum GamepadButtonLabel {
        UNKNOWN,
        A,
        B,
        X,
        Y,
        CROSS,
        CIRCLE,
        SQUARE,
        TRIANGLE,
    } // GamepadButtonLabel

    [CCode (cname = "SDL_GamepadType", cprefix = "SDL_GAMEPAD_TYPE_", has_type_id = false)]
    public enum GamepadType {
        UNKNOWN,
        STANDARD,
        XBOX360,
        XBOXONE,
        PS3,
        PS4,
        PS5,
        NINTENDO_SWITCH_PRO,
        NINTENDO_SWITCH_JOYCON_LEFT,
        NINTENDO_SWITCH_JOYCON_RIGHT,
        NINTENDO_SWITCH_JOYCON_PAIR,
        COUNT,
    } // GamepadType

    namespace SDLPropGamepad {
        [CCode (cname = "SDL_PROP_GAMEPAD_CAP_MONO_LED_BOOLEAN")]
        public const string CAP_MONO_LED_BOOLEAN;

        [CCode (cname = "SDL_PROP_GAMEPAD_CAP_RGB_LED_BOOLEAN")]
        public const string CAP_RGB_LED_BOOLEAN;

        [CCode (cname = "SDL_PROP_GAMEPAD_CAP_PLAYER_LED_BOOLEAN")]
        public const string CAP_PLAYER_LED_BOOLEAN;

        [CCode (cname = "SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN")]
        public const string CAP_RUMBLE_BOOLEAN;

        [CCode (cname = "SDL_PROP_GAMEPAD_CAP_TRIGGER_RUMBLE_BOOLEAN")]
        public const string CAP_TRIGGER_RUMBLE_BOOLEAN;
    } // SDLPropGamepad
} // SDL.Gamepad

///
/// Touch Support (SDL_touch.h)
///
[CCode (cheader_filename = "SDL3/SDL_touch.h")]
namespace SDL.Touch {
    [CCode (cname = "SDL_GetTouchDeviceName")]
    public static unowned string get_touch_device_name (TouchID touch_id);

    [CCode (cname = "SDL_GetTouchDevices")]
    public static TouchID[] ? get_touch_devices ();

    [CCode (cname = "SDL_GetTouchDeviceType")]
    public static TouchDeviceType get_touch_device_type (TouchID touch_id);

    [CCode (cname = "SDL_GetTouchFingers")]
    public static Finger[] get_touch_fingers (TouchID touch_id);

    [SimpleType, CCode (cname = "SDL_FingerID", has_type_id = false)]
    public struct FingerID : uint64 {}

    [SimpleType, CCode (cname = "SDL_TouchID", has_type_id = false)]
    public struct TouchID : uint64 {}

    [CCode (cname = "SDL_Finger", has_type_id = false)]
    public struct Finger {
        public FingerID id;
        public float x;
        public float y;
        public float pressure;
    } // Finger

    [CCode (cname = "SDL_TouchDeviceType", cprefix = "SDL_TOUCH_DEVICE_", has_type_id = false)]
    public enum TouchDeviceType {
        INVALID,
        DIRECT,
        INDIRECT_ABSOLUTE,
        INDIRECT_RELATIVE,
    } // TouchDeviceType

    [CCode (cname = "SDL_MOUSE_TOUCHID")]
    public const uint64 MOUSE_TOUCHID;

    [CCode (cname = "SDL_TOUCH_MOUSEID")]
    public const uint32 TOUCH_MOUSEID;
} // SDL.Touch

///
/// Pen Support (SDL_pen.h)
///
[CCode (cheader_filename = "SDL3/SDL_pen.h")]
namespace SDL.Pen {
    [SimpleType, CCode (cname = "SDL_PenID", has_type_id = false)]
    public struct PenID : uint32 {}

    [Flags, CCode (cname = "SDL_PenInputFlags", cprefix = "SDL_PEN_INPUT_", has_type_id = false)]
    public enum PenInputFlags {
        DOWN,
        BUTTON_1,
        BUTTON_2,
        BUTTON_3,
        BUTTON_4,
        BUTTON_5,
        ERASER_TIP,
    } // PenInputFlags

    [CCode (cname = "SDL_PenAxis", cprefix = "SDL_PEN_AXIS_", has_type_id = false)]
    public enum PenAxis {
        PRESSURE,
        XTILT,
        YTILT,
        DISTANCE,
        ROTATION,
        SLIDER,
        TANGENTIAL_PRESSURE,
        COUNT,
    } // PenAxis

    [CCode (cname = "SDL_PEN_MOUSEID")]
    public const uint32 PEN_MOUSEID;

    [CCode (cname = "SDL_PEN_TOUCHID")]
    public const uint64 PEN_TOUCHID;
} // SDL.Pen

///
/// Sensors (SDL_sensor.h)
///
[CCode (cheader_filename = "SDL3/SDL_sensor.h")]
namespace SDL.Sensor {
    [CCode (cname = "SDL_CloseSensor")]
    public static void close_sensor (Sensor sensor);

    [CCode (cname = "SDL_GetSensorData")]
    public static bool get_sensor_data (Sensor sensor, out float[] data);

    [CCode (cname = "SDL_GetSensorFromID")]
    public static Sensor ? get_sensor_from_id (SensorID instance_id);

    [CCode (cname = "SDL_GetSensorID")]
    public static SensorID get_sensor_id (Sensor sensor);

    [CCode (cname = "SDL_GetSensorName")]
    public static unowned string ? get_sensor_name (Sensor sensor);

    [CCode (cname = "SDL_GetSensorNameForID")]
    public static unowned string ? get_sensor_name_for_id (SensorID instance_id);

    [CCode (cname = "SDL_GetSensorNonPortableType")]
    public static int get_sensor_non_portable_type (Sensor sensor);

    [CCode (cname = "SDL_GetSensorNonPortableTypeForID")]
    public static int get_sensor_non_portable_type_for_id (SensorID instance_id);

    [CCode (cname = "SDL_GetSensorProperties")]
    public static Properties.PropertiesID get_sensor_properties (Sensor sensor);

    [CCode (cname = "SDL_GetSensors")]
    public static SensorID[] get_sensors ();

    [CCode (cname = "SDL_GetSensorType")]
    public static SensorType get_sensor_type (Sensor sensor);

    [CCode (cname = "SDL_GetSensorTypeForID")]
    public static SensorType get_sensor_type_for_id (SensorID instance_id);

    [CCode (cname = "SDL_OpenSensor")]
    public static Sensor ? open_sensor (SensorID instance_id);

    [CCode (cname = "SDL_UpdateSensors")]
    public static void update_sensors ();

    [CCode (cname = "SDL_Sensor", has_type_id = false)]
    public struct Sensor {}

    [SimpleType, CCode (cname = "SDL_SensorID", has_type_id = false)]
    public struct SensorID : uint32 {}

    [CCode (cname = "SDL_SensorID", cprefix = "SDL_SENSOR_", has_type_id = false)]
    public enum SensorType {
        INVALID,
        UNKNOWN,
        ACCEL,
        GYRO,
        ACCEL_L,
        GYRO_L,
        ACCEL_R,
        GYRO_R,
    } // SensorType

    [CCode (cname = "SDL_STANDARD_GRAVITY")]
    public const float STANDARD_GRAVITY;
} // SDL.Sensor

///
/// HIDAPI (SDL_hidapi.h)
///
[CCode (cheader_filename = "SDL3/SDL_hidapi.h")]
namespace SDL.HidApi {
    [CCode (cname = "SDL_hid_ble_scan")]
    public static void hid_ble_scan (bool active);

    [CCode (cname = "SDL_hid_close")]
    public static int hid_close (HidDevice dev);

    [CCode (cname = "SDL_hid_device_change_count")]
    public static uint32 hid_device_change_count ();

    [CCode (cname = "SDL_hid_enumerate")]
    public static HidDeviceInfo[] ? hid_enumerate (ushort vendor_id, ushort product_id);

    [CCode (cname = "SDL_hid_exit")]
    public static int hid_exit ();

    [CCode (cname = "SDL_hid_free_enumeration")]
    public static void hid_free_enumeration (HidDeviceInfo[] devs);

    [CCode (cname = "SDL_hid_get_device_info")]
    public static HidDeviceInfo ? hid_get_device_info (HidDevice dev);

    [CCode (cname = "SDL_hid_get_feature_report")]
    public static int hid_get_feature_report (HidDevice dev,
        [CCode (array_length = false)] out char[] data,
        size_t length);

    [CCode (cname = "SDL_hid_get_indexed_string")]
    public static int hid_get_indexed_string (HidDevice dev,
        int string_index,
        [CCode (array_length = false)] out char[] buffer,
        size_t maxlen);

    [CCode (cname = "SDL_hid_get_input_report")]
    public static int hid_get_input_report (HidDevice dev,
        [CCode (array_length = false)] out char[] data,
        size_t length);

    [CCode (cname = "SDL_hid_get_manufacturer_string")]
    public static int hid_get_manufacturer_string (HidDevice dev,
        [CCode (array_length = false)] out char[] data,
        size_t maxlen);

    [CCode (cname = "SDL_hid_get_product_string")]
    public static int hid_get_product_string (HidDevice dev,
        [CCode (array_length = false)] out char[] data,
        size_t maxlen);

    [CCode (cname = "SDL_hid_get_report_descriptor")]
    public static int hid_get_report_descriptor (HidDevice dev,
        [CCode (array_length = false)] out string buf,
        size_t buf_size);

    [CCode (cname = "SDL_hid_get_serial_number_string")]
    public static int hid_get_serial_number_string (HidDevice dev,
        [CCode (array_length = false)] out char[] data,
        size_t maxlen);

    [CCode (cname = "SDL_hid_init")]
    public static int hid_init ();

    [CCode (cname = "SDL_hid_open")]
    public static HidDevice ? hid_open (ushort vendor_id, ushort product_id, string? serial_number);

    [CCode (cname = "SDL_hid_open_path")]
    public static HidDevice ? hid_open_path (string path);

    [CCode (cname = "SDL_hid_read")]
    public static int hid_read (HidDevice dev,
        [CCode (array_length = false)] out char[] data,
        size_t length);

    [CCode (cname = "SDL_hid_read_timeout")]
    public static int hid_read_timeout (HidDevice dev,
        [CCode (array_length = false)] out char[] data,
        size_t length,
        int milliseconds);

    [CCode (cname = "SDL_hid_send_feature_report")]
    public static int hid_send_feature_report (HidDevice dev, char[] data);

    [CCode (cname = "SDL_hid_set_nonblocking")]
    public static int hid_set_nonblocking (HidDevice dev, int nonblock);

    [CCode (cname = "SDL_hid_write")]
    public static int hid_write (HidDevice dev, char[] data);

    [CCode (cname = "SDL_hid_device", has_type_id = false)]
    public struct HidDevice {}

    [CCode (cname = "SDL_hid_device_info", has_type_id = false)]
    public struct HidDeviceInfo {
        public string path;
        public ushort vendor_id;
        public ushort product_id;
        public string serial_number;
        public ushort release_number;
        public string manufacturer_string;
        public string product_string;
        public ushort usage_page;
        public ushort usage;
        public int interface_number;
        public int interface_class;
        public int interface_subclass;
        public int interface_protocol;
        public HidBusType bus_type;
        public HidDeviceInfo* next;
    } // HidDeviceInfo;

    [CCode (cname = "SDL_hid_bus_type", cprefix = "SDL_HID_API_BUS_", has_type_id = false)]
    public enum HidBusType {
        UNKNOWN,
        USB,
        BLUETOOTH,
        I2C,
        SPI,
    } // HidBusType
} // SDL.HidApi

///
/// Force Feedback ("Haptic")
///

///
/// Force Feedback Support (SDL_haptic.h)
///
[CCode (cheader_filename = "SDL3/SDL_timer.h")]
namespace SDL.Haptic {
    [CCode (cname = "SDL_CloseHaptic")]
    public static void close_haptic (Haptic haptic);

    [CCode (cname = "SDL_CreateHapticEffect")]
    public static int create_haptic_effect (Haptic haptic, HapticEffect effect);

    [CCode (cname = "SDL_DestroyHapticEffect")]
    public static void destroy_haptic_effect (Haptic haptic, int effect);

    [CCode (cname = "SDL_GetHapticEffectStatus")]
    public static bool get_haptic_effect_status (Haptic haptic, int effect);

    [CCode (cname = "SDL_GetHapticFeatures")]
    public static uint32 get_haptic_features (Haptic haptic);

    [CCode (cname = "SDL_GetHapticFromID")]
    public static Haptic ? get_haptic_from_id (HapticID instance_id);

    [CCode (cname = "SDL_GetHapticName")]
    public static unowned string ? get_haptic_name (Haptic haptic);

    [CCode (cname = "SDL_GetHapticNameForID")]
    public static unowned string ? get_haptic_name_for_id (HapticID instance_id);

    [CCode (cname = "SDL_GetHaptics")]
    public static HapticID[] get_haptics ();

    [CCode (cname = "SDL_GetMaxHapticEffects")]
    public static int get_max_haptic_effects (Haptic haptic);

    [CCode (cname = "SDL_GetMaxHapticEffectsPlaying")]
    public static int get_max_haptic_effects_playing (Haptic haptic);

    [CCode (cname = "SDL_GetNumHapticAxes")]
    public static int get_num_haptic_axes (Haptic haptic);

    [CCode (cname = "SDL_HapticEffectSupported")]
    public static bool haptic_effect_supported (Haptic haptic, HapticEffect effect);

    [CCode (cname = "SDL_HapticRumbleSupported")]
    public static bool haptic_rumble_supported (Haptic haptic);

    [CCode (cname = "SDL_InitHapticRumble")]
    public static bool init_haptic_rumble (Haptic haptic);

    [CCode (cname = "SDL_IsJoystickHaptic")]
    public static bool is_joystick_haptic (Joystick.Joystick joystick);

    [CCode (cname = "SDL_IsMouseHaptic")]
    public static bool is_mouse_haptic ();

    [CCode (cname = "SDL_OpenHaptic")]
    public static Haptic ? open_haptic (HapticID instance_id);

    [CCode (cname = "SDL_OpenHapticFromJoystick")]
    public static Haptic ? open_haptic_from_joystick (Joystick.Joystick joystick);

    [CCode (cname = "SDL_OpenHapticFromMouse")]
    public static Haptic ? open_haptic_from_mouse ();

    [CCode (cname = "SDL_PauseHaptic")]
    public static bool pause_haptic (Haptic haptic);

    [CCode (cname = "SDL_PlayHapticRumble")]
    public static bool play_haptic_rumble (Haptic haptic, float strength, uint32 length);

    [CCode (cname = "SDL_ResumeHaptic")]
    public static bool resume_haptic (Haptic haptic);

    [CCode (cname = "SDL_RunHapticEffect")]
    public static bool run_haptic_effect (Haptic haptic, int effect, uint32 iterations);

    [CCode (cname = "SDL_SetHapticAutocenter")]
    public static bool set_haptic_auto_center (Haptic haptic, int autocenter);

    [CCode (cname = "SDL_SetHapticGain")]
    public static bool set_haptic_gain (Haptic haptic, int gain);

    [CCode (cname = "SDL_StopHapticEffect")]
    public static bool stop_haptic_effect (Haptic haptic, int effect);

    [CCode (cname = "SDL_StopHapticEffects")]
    public static bool stop_haptic_effects (Haptic haptic);

    [CCode (cname = "SDL_StopHapticRumble")]
    public static bool stop_haptic_rumble (Haptic haptic);

    [CCode (cname = "SDL_UpdateHapticEffect")]
    public static bool update_haptic_effect (Haptic haptic, int effect, HapticEffect data);

    [CCode (cname = "SDL_Haptic", has_type_id = false)]
    public struct Haptic {}

    [SimpleType, CCode (cname = "SDL_HapticID", has_type_id = false)]
    public struct HapticID : uint32 {}

    [CCode (cname = "SDL_HapticCondition", has_type_id = false)]
    public struct HapticCondition {
        public HapticType type;
        public HapticDirection direction;
        public uint32 length;
        public uint16 delay;
        public uint16 button;
        public uint16 interval;
        public uint16 right_sat[3];
        public uint16 left_sat[3];
        public int16 right_coeff[3];
        public int16 left_coeff[3];
        public uint16 deadband[3];
        public int16 center[3];
    } // HapticCondition

    [CCode (cname = "SDL_HapticConstant", has_type_id = false)]
    public struct HapticConstant {
        public HapticType type;
        public HapticDirection direction;
        public uint32 length;
        public uint16 delay;
        public uint16 button;
        public uint16 interval;
        public int16 level;
        public uint16 attack_length;
        public uint16 attack_level;
        public uint16 fade_length;
        public uint16 fade_level;
    } // HapticConstant

    [CCode (cname = "SDL_HapticCustom", has_type_id = false)]
    public struct HapticCustom {
        public HapticType type;
        public HapticDirection direction;
        public uint32 length;
        public uint16 delay;
        public uint16 button;
        public uint16 interval;
        public uint8 channels;
        public uint16 period;
        public uint16 samples;
        public uint16* data;
        public uint16 attack_length;
        public uint16 attack_level;
        public uint16 fade_length;
        public uint16 fade_level;
    } // HapticCustom

    [CCode (cname = "SDL_HapticLeftRight", has_type_id = false)]
    public struct HapticLeftRight {
        public HapticType type;
        public uint32 length;
        public uint16 large_magnitude;
        public uint16 small_magnitude;
    } // HapticLeftRight

    [CCode (cname = "SDL_HapticPeriodic", has_type_id = false)]
    public struct HapticPeriodic {
        public HapticType type;
        public HapticDirection direction;
        public uint32 length;
        public uint16 delay;
        public uint16 button;
        public uint16 interval;
        public uint16 period;
        public int16 magnitude;
        public int16 offset;
        public uint16 phase;
        public uint16 attack_length;
        public uint16 attack_level;
        public uint16 fade_length;
        public uint16 fade_level;
    } // HapticPeriodic

    [CCode (cname = "SDL_HapticRamp", has_type_id = false)]
    public struct HapticRamp {
        public HapticType type;
        public HapticDirection direction;
        public uint32 length;
        public uint16 delay;
        public uint16 button;
        public uint16 interval;
        public int16 start;
        public int16 end;
        public uint16 attack_length;
        public uint16 attack_level;
        public uint16 fade_length;
        public uint16 fade_level;
    } // HapticRamp

    [CCode (cname = "uint16", cprefix = "SDL_HAPTIC_", has_type_id = false)]
    public enum HapticType {
        SPRING,
        DAMPER,
        INERTIA,
        FRICTION,
        CONSTANT,
        CUSTOM,
        LEFTRIGHT,
        SINE,
        SQUARE,
        TRIANGLE,
        SAWTOOTHUP,
        SAWTOOTHDOWN,
        RAMP,
        RESERVED1,
        RESERVED2,
        RESERVED3,
    } // HapticType

    [CCode (cname = "SDL_HapticDirection", has_type_id = false)]
    public struct HapticDirection {
        public HapticDirectionType type;
        public int32 dir[3];
    } // HapticDirection

    [CCode (cname = "uint8", cprefix = "SDL_HAPTIC_", has_type_id = false)]
    public enum HapticDirectionType {
        POLAR,
        CARTESIAN,
        SPHERICAL,
    }

    [Compact, CCode (cname = "SDL_HapticEffect", free_function = "", has_type_id = false)]
    public class HapticEffect {
        public HapticType type;
        public HapticConstant constant;
        public HapticPeriodic periodic;
        public HapticCondition condition;
        public HapticRamp ramp;
        public HapticLeftRight leftright;
        public HapticCustom custom;
    } // HapticEffect

    [CCode (cname = "SDL_HAPTIC_AUTOCENTER")]
    public const uint32 HAPTIC_AUTOCENTER;

    [CCode (cname = "SDL_HAPTIC_GAIN")]
    public const uint32 HAPTIC_GAIN;

    [CCode (cname = "SDL_HAPTIC_DAMPER")]
    public const uint32 HAPTIC_DAMPER;

    [CCode (cname = "SDL_HAPTIC_FRICTION")]
    public const uint32 HAPTIC_FRICTION;

    [CCode (cname = "SDL_HAPTIC_INERTIA")]
    public const uint32 HAPTIC_INERTIA;

    [CCode (cname = "SDL_HAPTIC_INFINITY")]
    public const uint32 HAPTIC_INFINITY;

    [CCode (cname = "SDL_HAPTIC_PAUSE")]
    public const uint32 HAPTIC_PAUSE;

    [CCode (cname = "SDL_HAPTIC_STATUS")]
    public const uint32 HAPTIC_STATUS;

    [CCode (cname = "SDL_HAPTIC_STEERING_AXIS")]
    public const int HAPTIC_STEERING_AXIS;
} // SDL.Haptic

///
/// Audio
///

///
/// Audio Playback, Recording, and Mixing (SDL_audio.h)
///
[CCode (cheader_filename = "SDL3/SDL_audio.h")]
namespace SDL.Audio {
    [CCode (cname = "SDL_AudioDevicePaused")]
    public static bool audio_device_paused (AudioDeviceID devid);

    [CCode (cname = "SDL_AudioStreamDevicePaused")]
    public static bool audio_stream_device_paused (AudioStream stream);

    [CCode (cname = "SDL_BindAudioStream")]
    public static bool bind_audio_stream (AudioDeviceID devid, AudioStream stream);

    [CCode (cname = "SDL_BindAudioStreams")]
    public static bool bind_audio_streams (AudioDeviceID devid, AudioStream[] streams);

    [CCode (cname = "SDL_ClearAudioStream")]
    public static bool clear_audio_stream (AudioStream stream);

    [CCode (cname = "SDL_CloseAudioDevice")]
    public static void close_audio_device (AudioDeviceID devid);

    [CCode (cname = "SDL_ConvertAudioSamples")]
    public static bool convert_audio_samples (AudioSpec src_spec,
        uint8[] src_data,
        AudioSpec dst_spec,
        out uint8[] dst_data);

    [CCode (cname = "SDL_CreateAudioStream")]
    public static AudioStream ? create_audio_stream (AudioSpec src_spec, AudioSpec? dst_spec);

    [CCode (cname = "SDL_DestroyAudioStream")]
    public static void destroy_audio_stream (AudioStream stream);

    [CCode (cname = "SDL_FlushAudioStream")]
    public static bool flush_audio_stream (AudioStream stream);

    [CCode (cname = "SDL_GetAudioDeviceChannelMap")]
    public static int[] ? get_audio_device_channel_map (AudioDeviceID devid);

    [CCode (cname = "SDL_GetAudioDeviceFormat")]
    public static bool get_audio_device_format (AudioDeviceID devid, out AudioSpec spec, out int sample_frames);

    [CCode (cname = "SDL_GetAudioDeviceGain")]
    public static float get_audio_device_gain (AudioDeviceID devid);

    [CCode (cname = "SDL_GetAudioDeviceName")]
    public static unowned string ? get_audio_device_name (AudioDeviceID devid);

    [CCode (cname = "SDL_GetAudioDriver")]
    public static unowned string ? get_audio_driver (int index);

    [CCode (cname = "SDL_GetAudioFormatName")]
    public static unowned string get_audio_format_name (AudioFormat format);

    [CCode (cname = "SDL_GetAudioPlaybackDevices")]
    public static AudioDeviceID[] ? get_audio_playback_devices ();

    [CCode (cname = "SDL_GetAudioRecordingDevices")]
    public static AudioDeviceID[] ? get_audio_recording_devices ();

    [CCode (cname = "SDL_GetAudioStreamAvailable")]
    public static int get_audio_stream_available (AudioStream stream);

    [CCode (cname = "SDL_GetAudioStreamData")]
    public static int get_audio_stream_data (AudioStream stream, out void* buf, int len);

    [CCode (cname = "SDL_GetAudioStreamDevice")]
    public static AudioDeviceID get_audio_stream_device (AudioStream stream);

    [CCode (cname = "SDL_GetAudioStreamFormat")]
    public static bool get_audio_stream_format (AudioStream stream, out AudioSpec src_spec, out AudioSpec dst_spec);

    [CCode (cname = "SDL_GetAudioStreamFrequencyRatio")]
    public static float get_audio_stream_frecuency_ratio (AudioStream stream);

    [CCode (cname = "SDL_GetAudioStreamGain")]
    public static float get_audio_stream_gain (AudioStream stream);

    [CCode (cname = "SDL_GetAudioStreamInputChannelMap")]
    public static int[] get_audio_stream_input_channel_map (AudioStream stream);

    [CCode (cname = "SDL_GetAudioStreamOutputChannelMap")]
    public static int[] get_audio_stream_output_channel_map (AudioStream stream);

    [CCode (cname = "SDL_GetAudioStreamProperties")]
    public static Properties.PropertiesID get_audio_stream_properties (AudioStream stream);

    [CCode (cname = "SDL_GetAudioStreamQueued")]
    public static int get_audio_stream_queued (AudioStream stream);

    [CCode (cname = "SDL_GetCurrentAudioDriver")]
    public static unowned string get_current_audio_dirver ();

    [CCode (cname = "SDL_GetNumAudioDrivers")]
    public static int get_num_audio_drivers ();

    [CCode (cname = "SDL_GetSilenceValueForFormat")]
    public static int get_silence_value_for_format (AudioFormat format);

    [CCode (cname = "SDL_IsAudioDevicePhysical")]
    public static bool is_audio_device_physical (AudioDeviceID devid);

    [CCode (cname = "SDL_IsAudioDevicePlayback")]
    public static bool is_audio_device_playback (AudioDeviceID devid);

    [CCode (cname = "SDL_LoadWAV")]
    public static bool load_wav (string path, out AudioSpec spec, out uint8[] audio_buf);

    [CCode (cname = "SDL_LoadWAV_IO")]
    public static bool load_wav_io (IOStream.IOStream src,
        bool close_io,
        AudioSpec spec,
        out uint8[] audio_buf);

    [CCode (cname = "SDL_LockAudioStream")]
    public static bool lock_audio_stream (AudioStream stream);

    [CCode (cname = "SDL_MixAudio")]
    public static bool mix_audio ([CCode (array_length = false)] out uint8[] dst,
        [CCode (array_length = false)] uint8[] src,
        AudioFormat format,
        uint32 len,
        float volume);

    [CCode (cname = "SDL_OpenAudioDevice")]
    public static AudioDeviceID open_audio_device (AudioDeviceID devid, AudioSpec? spec);

    [CCode (cname = "SDL_OpenAudioDeviceStream", has_target = true)]
    public static AudioStream ? open_audio_device_stream (AudioDeviceID devid,
        AudioSpec? spec,
        AudioStreamCallback? callback);

    [CCode (cname = "SDL_PauseAudioDevice")]
    public static bool pause_audio_device (AudioDeviceID devid);

    [CCode (cname = "SDL_PauseAudioStreamDevice")]
    public static bool pause_audio_stream_device (AudioStream stream);

    [CCode (cname = "SDL_PutAudioStreamData")]
    public static bool put_audio_stream_data (AudioStream stream, void* buf, int len);

    [CCode (cname = "SDL_ResumeAudioDevice")]
    public static bool resume_audio_device (AudioDeviceID devid);

    [CCode (cname = "SDL_ResumeAudioStreamDevice")]
    public static bool resume_audio_stream_device (AudioStream stream);

    [CCode (cname = "SDL_SetAudioDeviceGain")]
    public static bool set_audio_device_gain (AudioDeviceID devid, float gain);

    [CCode (cname = "SDL_SetAudioPostmixCallback", has_target = true)]
    public static bool set_audio_postmix_callback (AudioDeviceID devid, AudioPostmixCallback callback);

    [CCode (cname = "SDL_SetAudioStreamFormat")]
    public static bool set_audio_stream_format (AudioStream stream, AudioSpec? src_spec, AudioSpec? dst_spec);

    [CCode (cname = "SDL_SetAudioStreamFrequencyRatio")]
    public static bool set_audio_stream_frecuency_ratio (AudioStream stream, float ratio);

    [CCode (cname = "SDL_SetAudioStreamGain")]
    public static bool set_audio_stream_gain (AudioStream stream, float gain);

    [CCode (cname = "SDL_SetAudioStreamGetCallback", has_target = true)]
    public static bool set_audio_stream_get_callback (AudioStream stream, AudioStreamCallback callback);

    [CCode (cname = "SDL_SetAudioStreamInputChannelMap")]
    public static bool set_audio_stream_input_channel_map (AudioStream stream, int? chmap, int count);

    [CCode (cname = "SDL_SetAudioStreamOutputChannelMap")]
    public static bool set_audio_stream_output_channel_map (AudioStream stream, int? chmap, int count);

    [CCode (cname = "SDL_SetAudioStreamPutCallback", has_target = true)]
    public static bool set_audio_stream_output_out_callback (AudioStream stream, AudioStreamCallback callback);

    [CCode (cname = "SDL_UnbindAudioStream")]
    public static void unbind_audio_stream (AudioStream? stream);

    [CCode (cname = "SDL_UnbindAudioStreams")]
    public static void unbind_audio_streams (AudioStream[] streams);

    [CCode (cname = "SDL_UnlockAudioStream")]
    public static bool unlock_audio_streams (AudioStream stream);

    [SimpleType, CCode (cname = "SDL_AudioDeviceID", has_type_id = false)]
    public struct AudioDeviceID : uint32 {}

    [CCode (cname = "SDL_AudioPostmixCallback", has_target = true, instance_pos = 0)]
    public delegate void AudioPostmixCallback (AudioSpec spec,
        [CCode (array_length = false)] ref float[] buffer,
        int buflen);

    [Compact, CCode (cname = "SDL_AudioStream", free_function = "", has_type_id = false)]
    public class AudioStream {}

    [CCode (cname = "SDL_AudioStreamCallback", has_target = true, instance_pos = 0)]
    public delegate void AudioStreamCallback (AudioStream stream, int additional_amount, int total_amount);

    [CCode (cname = "SDL_AudioSpec", has_type_id = false)]
    public struct AudioSpec {
        public AudioFormat format;
        public int channels;
        public int freq;
    } // AudioSpec

    [CCode (cname = "SDL_AudioFormat", cprefix = "SDL_AUDIO_", has_type_id = false)]
    public enum AudioFormat {
        UNKNOWN,
        U8,
        S8,
        S16LE,
        S16BE,
        S32LE,
        S32BE,
        F32LE,
        F32BE,
        S16,
        S32,
        F32,
    } // AudioFormat

    [CCode (cname = "SDL_AUDIO_BITSIZE")]
    public static int audio_bit_size (AudioFormat x);

    [CCode (cname = "SDL_AUDIO_BYTESIZE ")]
    public static int audio_byte_size (AudioFormat x);

    [CCode (cname = "SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK")]
    public const AudioDeviceID AUDIO_DEVICE_DEFAULT_PLAYBACK;

    [CCode (cname = "SDL_AUDIO_DEVICE_DEFAULT_RECORDING")]
    public const AudioDeviceID AUDIO_DEVICE_DEFAULT_RECORDING;

    [CCode (cname = "SDL_AUDIO_FRAMESIZE")]
    public static int audio_frame_size (AudioSpec x);

    [CCode (cname = "SDL_AUDIO_ISBIGENDIAN")]
    public static int audio_is_big_endian (AudioFormat x);

    [CCode (cname = "SDL_AUDIO_ISFLOAT")]
    public static int audio_is_float (AudioFormat x);

    [CCode (cname = "SDL_AUDIO_ISINT")]
    public static int audio_is_int (AudioFormat x);

    [CCode (cname = "SDL_AUDIO_ISLITTLEENDIAN")]
    public static int audio_is_little_endian (AudioFormat x);

    [CCode (cname = "SDL_AUDIO_ISSIGNED")]
    public static int audio_is_signed (AudioFormat x);

    [CCode (cname = "SDL_AUDIO_ISUNSIGNED")]
    public static int audio_is_unsigned (AudioFormat x);
} // SDL.Audio

///
/// GPU
///

///
/// 3D Rendering and GPU Compute (SDL_gpu.h)
///
[CCode (cheader_filename = "SDL3/SDL_gpu.h")]
namespace SDL.Gpu {
    [CCode (cname = "SDL_AcquireGPUCommandBuffer")]
    public static GPUCommandBuffer ? acquire_gpu_command_buffer (GPUDevice device);

    [CCode (cname = "SDL_AcquireGPUSwapchainTexture")]
    public static bool acquire_gpu_swapchain_texture (GPUCommandBuffer command_buffer,
        Video.Window window,
        GPUTexture swapchain_texture,
        out uint32 swapchain_texture_width,
        out uint32 swapchain_texture_height);

    [CCode (cname = "SDL_BeginGPUComputePass")]
    public static GPUComputePass begin_gpu_compute_pass (GPUCommandBuffer command_buffer,
        GPUStorageTextureReadWriteBinding[] storage_texture_bindings,
        GPUStorageBufferReadWriteBinding[] storage_buffer_bindings);

    [CCode (cname = "SDL_BeginGPUCopyPass")]
    public static GPUCopyPass begin_gpu_copy_pass (GPUCommandBuffer command_buffer);

    [CCode (cname = "SDL_BeginGPURenderPass")]
    public static GPURenderPass begin_gpu_render_pass (GPUCommandBuffer command_buffer,
        GPUColorTargetInfo[] color_target_infos,
        GPUDepthStencilTargetInfo? depth_stencil_target_info);

    [CCode (cname = "SDL_BindGPUComputePipeline")]
    public static void bind_gpu_compute_pipeline (GPUComputePass compute_pass, GPUComputePipeline compute_pipeline);

    [CCode (cname = "SDL_BindGPUComputeSamplers")]
    public static void bind_gpu_compute_samplers (GPUComputePass compute_pass,
        uint32 first_slot,
        GPUTextureSamplerBinding[] texture_sampler_bindings);

    [CCode (cname = "SDL_BindGPUComputeStorageBuffers")]
    public static void bind_gpu_compute_storage_buffers (GPUComputePass compute_pass,
        uint32 first_slot,
        GPUBuffer[] storage_buffers);

    [CCode (cname = "SDL_BindGPUComputeStorageTextures")]
    public static void bind_gpu_compute_storage_textures (GPUComputePass compute_pass,
        uint32 first_slot,
        GPUTexture[] storage_textures);

    [CCode (cname = "SDL_BindGPUFragmentSamplers")]
    public static void bind_gpu_fragment_samplers (GPURenderPass render_pass,
        uint32 first_slot,
        GPUTextureSamplerBinding[] texture_sampler_bindings);

    [CCode (cname = "SDL_BindGPUFragmentStorageBuffers")]
    public static void bind_gpu_fragment_storage_buffers (GPURenderPass render_pass,
        uint32 first_slot,
        GPUBuffer[] storage_buffers);

    [CCode (cname = "SDL_BindGPUFragmentStorageTextures")]
    public static void bind_gpu_fragment_storage_textures (GPURenderPass render_pass,
        uint32 first_slot,
        GPUTexture[] storage_textures);

    [CCode (cname = "SDL_BindGPUGraphicsPipeline")]
    public static void bind_gpu_graphics_pipeline (GPURenderPass render_pass, GPUGraphicsPipeline graphics_pipeline);

    [CCode (cname = "SDL_BindGPUIndexBuffer")]
    public static void bind_gpu_index_buffer (GPURenderPass render_pass,
        GPUBufferBinding binding,
        GPUIndexElementSize index_element_size);

    [CCode (cname = "SDL_BindGPUVertexBuffers")]
    public static void bind_gpu_vertex_buffers (GPURenderPass render_pass,
        uint32 first_slot,
        GPUBufferBinding[] bindings);

    [CCode (cname = "SDL_BindGPUVertexSamplers")]
    public static void bind_gpu_vertex_samplers (GPURenderPass render_pass,
        uint32 first_slot,
        GPUTextureSamplerBinding[] texture_sampler_bindings);

    [CCode (cname = "SDL_BindGPUVertexStorageBuffers")]
    public static void bind_gpu_vertex_storage_buffers (GPURenderPass render_pass,
        uint32 first_slot,
        GPUBuffer[] storage_buffers);

    [CCode (cname = "SDL_BindGPUVertexStorageTextures")]
    public static void bind_gpu_vertex_storage_textures (GPURenderPass render_pass,
        uint32 first_slot,
        GPUTexture[] storage_textures);

    [CCode (cname = "SDL_BlitGPUTexture")]
    public static void blit_gpu_texture (GPUCommandBuffer command_buffer, GPUBlitInfo info);

    [CCode (cname = "SDL_CalculateGPUTextureFormatSize")]
    public static int32 calculate_gpu_texture_format_size (GPUTextureFormat format,
        uint32 width,
        uint32 height,
        uint32 depth_or_layer_count);

    [CCode (cname = "SDL_CancelGPUCommandBuffer")]
    public static bool cancel_gpu_command_buffer (GPUCommandBuffer command_buffer);

    [CCode (cname = "SDL_ClaimWindowForGPUDevice")]
    public static bool claim_window_for_gpu_device (GPUDevice device, Video.Window window);

    [CCode (cname = "SDL_CopyGPUBufferToBuffer")]
    public static void copy_gpu_buffer_to_buffer (GPUCopyPass copy_pass,
        GPUBufferLocation source,
        ref GPUBufferLocation destination,
        uint32 size,
        bool cycle);

    [CCode (cname = "SDL_CopyGPUTextureToTexture")]
    public static void copy_gpu_texture_to_texture (GPUCopyPass copy_pass,
        GPUTextureLocation source,
        ref GPUTextureLocation destination,
        uint32 w,
        uint32 h,
        uint32 d,
        bool cycle);

    [CCode (cname = "SDL_CreateGPUBuffer")]
    public static GPUBuffer ? create_gpu_buffer (GPUDevice device, GPUBufferCreateInfo createinfo);

    [CCode (cname = "SDL_CreateGPUComputePipeline")]
    public static GPUComputePipeline ? create_compute_pipeline (GPUDevice device,
        GPUComputePipelineCreateInfo createinfo);

    [CCode (cname = "SDL_CreateGPUDevice")]
    public static GPUDevice ? create_gpu_device (GPUShaderFormat format_flags, bool debug_mode, string? name);

    [CCode (cname = "SDL_CreateGPUDeviceWithProperties")]
    public static GPUDevice ? create_gpu_device_with_properties (Properties.PropertiesID props);

    [CCode (cname = "SDL_CreateGPUGraphicsPipeline")]
    public static GPUGraphicsPipeline ? create_gpu_graphics_pipeline (GPUDevice device,
        GPUGraphicsPipelineCreateInfo createinfo);

    [CCode (cname = "SDL_CreateGPUSampler")]
    public static GPUSampler ? create_gpu_sampler (GPUDevice device, GPUSamplerCreateInfo createinfo);

    [CCode (cname = "SDL_CreateGPUShader")]
    public static GPUShader ? create_gpu_shader (GPUDevice device, GPUShaderCreateInfo createinfo);

    [CCode (cname = "SDL_CreateGPUTexture")]
    public static GPUTexture ? create_gpu_texture (GPUDevice device, GPUTextureCreateInfo createinfo);

    [CCode (cname = "SDL_CreateGPUTransferBuffer")]
    public static GPUTransferBuffer ? create_gpu_transfer_buffer (GPUDevice device,
        GPUTransferBufferCreateInfo createinfo);

    [CCode (cname = "SDL_DestroyGPUDevice")]
    public static void destroy_gpu_device (GPUDevice device);

    [CCode (cname = "SDL_DispatchGPUCompute")]
    public static void dipatch_gpu_compute (GPUComputePass compute_pass,
        uint32 groupcount_x,
        uint32 groupcount_y,
        int32 groupcount_z);

    [CCode (cname = "SDL_DispatchGPUComputeIndirect")]
    public static void dipatch_gpu_compute_indirect (GPUComputePass compute_pass,
        GPUBuffer buffer,
        uint32 offset);

    [CCode (cname = "SDL_DownloadFromGPUBuffer")]
    public static void download_from_gpu_buffer (GPUCopyPass copy_pass,
        GPUBufferRegion source,
        GPUTransferBufferLocation destination);

    [CCode (cname = "SDL_DownloadFromGPUTexture")]
    public static void download_from_gpu_texture (GPUCopyPass copy_pass,
        GPUTextureRegion source,
        GPUTextureTransferInfo destination);

    [CCode (cname = "SDL_DrawGPUIndexedPrimitives")]
    public static void draw_gpu_indexed_primitives (GPURenderPass render_pass,
        uint32 num_indices,
        uint32 num_instances,
        uint32 first_index,
        int32 vertex_offset,
        uint32 first_instance);

    [CCode (cname = "SDL_DrawGPUIndexedPrimitivesIndirect")]
    public static void draw_gpu_indexed_primitives_indirect (GPURenderPass render_pass,
        GPUBuffer buffer,
        uint32 offset,
        uint32 draw_count);

    [CCode (cname = "SDL_DrawGPUPrimitives")]
    public static void draw_gpu_primitives (GPURenderPass render_pass,
        uint32 num_vertices,
        uint32 num_instances,
        uint32 first_vertex,
        uint32 first_instance);

    [CCode (cname = "SDL_DrawGPUPrimitivesIndirect")]
    public static void draw_gpu_primitives_indirect (GPURenderPass render_pass,
        GPUBuffer buffer,
        uint32 offset,
        uint32 draw_count);

    [CCode (cname = "SDL_EndGPUComputePass")]
    public static void end_gpu_compute_pass (GPUComputePass compute_pass);

    [CCode (cname = "SDL_EndGPUCopyPass")]
    public static void end_gpu_copy_pass (GPUCopyPass copy_pass);

    [CCode (cname = "SDL_EndGPURenderPass")]
    public static void end_gpu_render_pass (GPURenderPass render_pass);

    [CCode (cname = "SDL_GDKResumeGPU")]
    public static void gdk_resume_gpu (GPUDevice device);

    [CCode (cname = "SDL_GDKSuspendGPU")]
    public static void gdk_suspend_gpu (GPUDevice device);

    [CCode (cname = "SDL_GenerateMipmapsForGPUTexture")]
    public static void generate_mipmaps_for_gpu_texture (GPUCommandBuffer command_buffer, GPUTexture texture);

    [CCode (cname = "SDL_GetGPUDeviceDriver")]
    public static unowned string ? get_gpu_device_driver (GPUDevice device);

    [CCode (cname = "SDL_GetGPUDriver")]
    public static unowned string get_gpu_driver (int index);

    [CCode (cname = "SDL_GetGPUShaderFormats")]
    public static GPUShaderFormat get_gpu_shader_formats (GPUDevice device);

    [CCode (cname = "SDL_GetGPUSwapchainTextureFormat")]
    public static GPUTextureFormat get_gpu_swapchain_texture_format (GPUDevice device, Video.Window window);

    [CCode (cname = "SDL_GetNumGPUDrivers")]
    public static int get_num_gpu_drivers ();

    [CCode (cname = "SDL_GPUSupportsProperties")]
    public static bool gpu_supports_properties (Properties.PropertiesID props);

    [CCode (cname = "SDL_GPUSupportsShaderFormats")]
    public static bool gpu_supports_shader_formats (GPUShaderFormat format_flags, string? name);

    [CCode (cname = "SDL_GPUTextureFormatTexelBlockSize")]
    public static uint32 gpu_texture_format_text_block_size (GPUTextureFormat format);

    [CCode (cname = "SDL_GPUTextureSupportsFormat")]
    public static bool gpu_texture_supports_format (GPUDevice device,
        GPUTextureFormat format,
        GPUTextureType type,
        GPUTextureUsageFlags usage);

    [CCode (cname = "SDL_GPUTextureSupportsSampleCount")]
    public static bool gpu_texture_supports_sample_count (GPUDevice device,
        GPUTextureFormat format,
        GPUSampleCount sample_count);

    [CCode (cname = "SDL_InsertGPUDebugLabel")]
    public static void insert_gpu_debug_label (GPUCommandBuffer command_buffer, string text);

    [CCode (cname = "SDL_MapGPUTransferBuffer")]
    public static void * map_gpu_transfer_buffer (GPUDevice device, GPUTransferBuffer transfer_buffer, bool cycle);

    [CCode (cname = "SDL_PopGPUDebugGroup")]
    public static void pop_gpu_debug_group (GPUCommandBuffer command_buffer);

    [CCode (cname = "SDL_PushGPUComputeUniformData")]
    public static void push_gpu_compute_uniform_data (GPUCommandBuffer command_buffer,
        uint32 slot_index,
        void* data,
        uint32 length);

    [CCode (cname = "SDL_PushGPUDebugGroup")]
    public static void push_gpu_debug_group (GPUCommandBuffer command_buffer, string name);

    [CCode (cname = "SDL_PushGPUFragmentUniformData")]
    public static void push_gpu_fragment_uniform_data (GPUCommandBuffer command_buffer,
        uint32 slot_index,
        void* data,
        uint32 length);

    [CCode (cname = "SDL_PushGPUVertexUniformData")]
    public static void push_gpu_vertex_uniform_data (GPUCommandBuffer command_buffer,
        uint32 slot_index,
        void* data,
        uint32 length);

    [CCode (cname = "SDL_QueryGPUFence")]
    public static bool query_gpu_fence (GPUDevice device, GPUFence fence);

    [CCode (cname = "SDL_ReleaseGPUBuffer")]
    public static void release_gpu_buffer (GPUDevice device, GPUBuffer buffer);

    [CCode (cname = "SDL_ReleaseGPUComputePipeline")]
    public static void release_gpu_computer_pipeline (GPUDevice device, GPUComputePipeline compute_pipeline);

    [CCode (cname = "SDL_ReleaseGPUFence")]
    public static void release_gpu_fence (GPUDevice device, GPUFence fence);

    [CCode (cname = "SDL_ReleaseGPUGraphicsPipeline")]
    public static void release_gpu_graphics_pipeline (GPUDevice device, GPUGraphicsPipeline graphics_pipeline);

    [CCode (cname = "SDL_ReleaseGPUSampler")]
    public static void release_gpu_sampler (GPUDevice device, GPUSampler sampler);

    [CCode (cname = "SDL_ReleaseGPUShader")]
    public static void release_gpu_shader (GPUDevice device, GPUShader shader);

    [CCode (cname = "SDL_ReleaseGPUTexture")]
    public static void release_gpu_texture (GPUDevice device, GPUTexture texture);

    [CCode (cname = "SDL_ReleaseGPUTransferBuffer")]
    public static void release_gpu_transfer_buffer (GPUDevice device, GPUTransferBuffer transfer_buffer);

    [CCode (cname = "SDL_ReleaseWindowFromGPUDevice")]
    public static void release_window_from_gpu_device (GPUDevice device, Video.Window window);

    [CCode (cname = "SDL_SetGPUAllowedFramesInFlight")]
    public static bool set_gpu_allowed_frame_in_flight (GPUDevice device, uint32 allowed_frames_in_flight);

    [CCode (cname = "SDL_SetGPUBlendConstants")]
    public static void set_gpu_blend_constants (GPURenderPass render_pass, Pixels.FColor blend_constants);

    [CCode (cname = "SDL_SetGPUBufferName")]
    public static void set_gpu_buffer_name (GPUDevice device, GPUBuffer buffer, string text);

    [CCode (cname = "SDL_SetGPUScissor")]
    public static void set_gpu_scissor (GPURenderPass render_pass, Rect.Rect scissor);

    [CCode (cname = "SDL_SetGPUStencilReference")]
    public static void set_gpu_stencil_reference (GPURenderPass render_pass, uint8 reference);

    [CCode (cname = "SDL_SetGPUSwapchainParameters")]
    public static bool set_gpu_swapchain_parameters (GPUDevice device,
        Video.Window window,
        GPUSwapchainComposition swapchain_composition,
        GPUPresentMode present_mode);

    [CCode (cname = "SDL_SetGPUTextureName")]
    public static void set_gpu_texture_name (GPUDevice device, GPUTexture texture, string text);

    [CCode (cname = "SDL_SetGPUViewport")]
    public static void set_gpu_viewport (GPURenderPass render_pass, GPUViewport viewport);

    [CCode (cname = "SDL_SubmitGPUCommandBuffer")]
    public static bool submit_gpu_command_buffer (GPUCommandBuffer command_buffer);

    [CCode (cname = "SDL_SubmitGPUCommandBufferAndAcquireFence")]
    public static GPUFence ? submit_gpu_command_buffer_and_acquire_fence (GPUCommandBuffer command_buffer);

    [CCode (cname = "SDL_UnmapGPUTransferBuffer")]
    public static void unmap_gpu_transfer_buffer (GPUDevice device, GPUTransferBuffer transfer_buffer);

    [CCode (cname = "SDL_UploadToGPUBuffer")]
    public static void upload_to_gpu_buffer (GPUCopyPass copy_pass,
        GPUTransferBufferLocation source,
        GPUBufferRegion destination,
        bool cycle);

    [CCode (cname = "SDL_UploadToGPUTexture")]
    public static void upload_to_gpu_texture (GPUCopyPass copy_pass,
        GPUTextureTransferInfo source,
        GPUTextureRegion destination,
        bool cycle);

    [CCode (cname = "SDL_WaitAndAcquireGPUSwapchainTexture")]
    public static bool wait_and_acquire_gpu_swapchain_texture (GPUCommandBuffer command_buffer,
        Video.Window window,
        out GPUTexture swapchain_texture,
        out uint32 swapchain_texture_width,
        out uint32 swapchain_texture_height);

    [CCode (cname = "SDL_WaitForGPUFences")]
    public static bool wait_for_gpu_fences (GPUDevice device, bool wait_all, GPUFence[] fences);

    [CCode (cname = "SDL_WaitForGPUIdle")]
    public static bool wait_for_gpu_idle (GPUDevice device);

    [CCode (cname = "SDL_WaitForGPUSwapchain")]
    public static bool wait_for_gpu_swapchain (GPUDevice device, Video.Window window);

    [CCode (cname = "SDL_WindowSupportsGPUPresentMode")]
    public static bool window_support_gpu_present_mode (GPUDevice device,
        Video.Window window,
        GPUPresentMode present_mode);

    [CCode (cname = "SDL_WindowSupportsGPUSwapchainComposition")]
    public static bool window_supports_gpu_swapchain_composition (GPUDevice device,
        Video.Window window,
        GPUSwapchainComposition swapchain_composition);

    [CCode (cname = "SDL_GPUBuffer", has_type_id = false)]
    public struct GPUBuffer {}

    [Flags, CCode (cname = "uint32", cprefix = "SDL_GPU_BUFFERUSAGE_", has_type_id = false)]
    public enum GPUBufferUsageFlags {
        VERTEX,
        INDEX,
        INDIRECT,
        GRAPHICS_STORAGE_READ,
        COMPUTE_STORAGE_READ,
        COMPUTE_STORAGE_WRITE,
    }

    [Flags, CCode (cname = "uint8", cprefix = "SDL_GPU_COLORCOMPONENT_", has_type_id = false)]
    public enum GPUColorComponentFlags {
        R,
        G,
        B,
        A,
    }

    [CCode (cname = "SDL_GPUCommandBuffer", has_type_id = false)]
    public struct GPUCommandBuffer {}

    [CCode (cname = "SDL_GPUComputePass", has_type_id = false)]
    public struct GPUComputePass {}

    [CCode (cname = "SDL_GPUComputePipeline", has_type_id = false)]
    public struct GPUComputePipeline {}

    [CCode (cname = "SDL_GPUCopyPass", has_type_id = false)]
    public struct GPUCopyPass {}

    [Compact, CCode (cname = "SDL_GPUDevice", free_function = "", has_type_id = false)]
    public class GPUDevice {}

    [CCode (cname = "SDL_GPUFence", has_type_id = false)]
    public struct GPUFence {}

    [CCode (cname = "SDL_GPUGraphicsPipeline", has_type_id = false)]
    public struct GPUGraphicsPipeline {}

    [CCode (cname = "SDL_GPURenderPass", has_type_id = false)]
    public struct GPURenderPass {}

    [CCode (cname = "SDL_GPUSampler", has_type_id = false)]
    public struct GPUSampler {}

    [CCode (cname = "SDL_GPUShader", has_type_id = false)]
    public struct GPUShader {}

    [CCode (cname = "uint32", cprefix = "SDL_GPU_SHADERFORMAT_", has_type_id = false)]
    public enum GPUShaderFormat {
        INVALID,
        PRIVATE,
        SPIRV,
        DXBC,
        DXIL,
        MSL,
        METALLIB,
    }

    [CCode (cname = "SDL_GPUTexture", has_type_id = false)]
    public struct GPUTexture {}

    [Flags, CCode (cname = "uint32", cprefix = "SDL_GPU_TEXTUREUSAGE_", has_type_id = false)]
    public enum GPUTextureUsageFlags {
        SAMPLER,
        COLOR_TARGET,
        DEPTH_STENCIL_TARGET,
        GRAPHICS_STORAGE_READ,
        COMPUTE_STORAGE_READ,
        COMPUTE_STORAGE_WRITE,
        COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE,
    }

    [CCode (cname = "SDL_GPUTransferBuffer", has_type_id = false)]
    public struct GPUTransferBuffer {}

    [CCode (cname = "SDL_GPUBlitInfo", has_type_id = false)]
    public struct GPUBlitInfo {
        public GPUBlitRegion source;
        public GPUBlitRegion destination;
        public GPULoadOp load_op;
        public Pixels.FColor clear_color;
        public Surface.FlipMode flip_mode;
        public GPUFilter filter;
        public bool cycle;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
    } // GPUBlitInfo

    [CCode (cname = "SDL_GPUBlitRegion", has_type_id = false)]
    public struct GPUBlitRegion {
        public GPUTexture texture;
        public uint32 mip_level;
        public uint32 layer_or_depth_plane;
        public uint32 x;
        public uint32 y;
        public uint32 w;
        public uint32 h;
    } // GPUBlitRegion

    [CCode (cname = "SDL_GPUBufferBinding", has_type_id = false)]
    public struct GPUBufferBinding {
        public GPUBuffer buffer;
        public uint32 offset;
    } // GPUBufferBinding

    [CCode (cname = "SDL_GPUBufferCreateInfo", has_type_id = false)]
    public struct GPUBufferCreateInfo {
        public GPUBufferUsageFlags usage;
        public uint32 size;
        public Properties.PropertiesID props;
    } // GPUBufferCreateInfo

    [CCode (cname = "SDL_GPUBufferLocation", has_type_id = false)]
    public struct GPUBufferLocation {
        GPUBuffer buffer;
        public uint32 offset;
    } // GPUBufferLocation

    [CCode (cname = "SDL_GPUBufferRegion", has_type_id = false)]
    public struct GPUBufferRegion {
        public GPUBuffer buffer;
        public uint32 offset;
        public uint32 size;
    } // GPUBufferRegion

    [CCode (cname = "SDL_GPUColorTargetBlendState", has_type_id = false)]
    public struct GPUColorTargetBlendState {
        public GPUBlendFactor src_color_blendfactor;
        public GPUBlendFactor dst_color_blendfactor;
        public GPUBlendOp color_blend_op;
        public GPUBlendFactor src_alpha_blendfactor;
        public GPUBlendFactor dst_alpha_blendfactor;
        public GPUBlendOp alpha_blend_op;
        public GPUColorComponentFlags color_write_mask;
        public bool enable_blend;
        public bool enable_color_write_mask;
        public uint8 padding1;
        public uint8 padding2;
    } // GPUColorTargetBlendState

    [CCode (cname = "SDL_GPUColorTargetDescription", has_type_id = false)]
    public struct GPUColorTargetDescription {
        public GPUTextureFormat format;
        public GPUColorTargetBlendState blend_state;
    } // GPUColorTargetDescription

    [CCode (cname = "SDL_GPUColorTargetInfo", has_type_id = false)]
    public struct GPUColorTargetInfo {
        public GPUTexture texture;
        public uint32 mip_level;
        public uint32 layer_or_depth_plane;
        public Pixels.FColor clear_color;
        public GPULoadOp load_op;
        public GPUStoreOp store_op;
        public GPUTexture resolve_texture;
        public uint32 resolve_mip_level;
        public uint32 resolve_layer;
        public bool cycle;
        public bool cycle_resolve_texture;
        public uint8 padding1;
        public uint8 padding2;
    } // GPUColorTargetInfo

    [CCode (cname = "SDL_GPUComputePipelineCreateInfo", has_type_id = false)]
    public struct GPUComputePipelineCreateInfo {
        public size_t code_size;
        public uint8[] code;
        public string entrypoint;
        public GPUShaderFormat format;
        public uint32 num_samplers;
        public uint32 num_readonly_storage_textures;
        public uint32 num_readonly_storage_buffers;
        public uint32 num_readwrite_storage_textures;
        public uint32 num_readwrite_storage_buffers;
        public uint32 num_uniform_buffers;
        public uint32 threadcount_x;
        public uint32 threadcount_y;
        public uint32 threadcount_z;
        public Properties.PropertiesID props;
    } // GPUComputePipelineCreateInfo

    [CCode (cname = "SDL_GPUDepthStencilState", has_type_id = false)]
    public struct GPUDepthStencilState {
        public GPUCompareOp compare_op;
        public GPUStencilOpState back_stencil_state;
        public GPUStencilOpState front_stencil_state;
        public uint8 compare_mask;
        public uint8 write_mask;
        public bool enable_depth_test;
        public bool enable_depth_write;
        public bool enable_stencil_test;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
    } // GPUDepthStencilState

    [CCode (cname = "SDL_GPUDepthStencilTargetInfo", has_type_id = false)]
    public struct GPUDepthStencilTargetInfo {
        public GPUTexture texture;
        public float clear_depth;
        public GPULoadOp load_op;
        public GPUStoreOp store_op;
        public GPULoadOp stencil_load_op;
        public GPUStoreOp stencil_store_op;
        public bool cycle;
        public uint8 clear_stencil;
        public uint8 padding1;
        public uint8 padding2;
    } // GPUDepthStencilTargetInfo;

    [CCode (cname = "SDL_GPUGraphicsPipelineCreateInfo", has_type_id = false)]
    public struct GPUGraphicsPipelineCreateInfo {
        public GPUShader vertex_shader;
        public GPUShader fragment_shader;
        public GPUVertexInputState vertex_input_state;
        public GPUPrimitiveType primitive_type;
        public GPURasterizerState rasterizer_state;
        public GPUMultisampleState multisample_state;
        public GPUDepthStencilState depth_stencil_state;
        public GPUGraphicsPipelineTargetInfo target_info;
        public Properties.PropertiesID props;
    } // GPUGraphicsPipelineCreateInfo

    [CCode (cname = "SDL_GPUGraphicsPipelineTargetInfo", has_type_id = false)]
    public struct GPUGraphicsPipelineTargetInfo {
        public GPUColorTargetDescription color_target_descriptions;
        public uint32 num_color_targets;
        public GPUTextureFormat depth_stencil_format;
        public bool has_depth_stencil_target;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
    } // GPUGraphicsPipelineTargetInfo

    [CCode (cname = "SDL_GPUIndexedIndirectDrawCommand", has_type_id = false)]
    public struct GPUIndexedIndirectDrawCommand {
        public uint32 num_indices;
        public uint32 num_instances;
        public uint32 first_index;
        public int32 vertex_offset;
        public uint32 first_instance;
    } // GPUIndexedIndirectDrawCommand

    [CCode (cname = "SDL_GPUIndirectDispatchCommand", has_type_id = false)]
    public struct GPUIndirectDispatchCommand {
        public uint32 groupcount_x;
        public uint32 groupcount_y;
        public uint32 groupcount_z;
    } // GPUIndirectDispatchCommand

    [CCode (cname = "SDL_GPUIndirectDrawCommand", has_type_id = false)]
    public struct GPUIndirectDrawCommand {
        public uint32 num_vertices;
        public uint32 num_instances;
        public uint32 first_vertex;
        public uint32 first_instance;
    } // GPUIndirectDrawCommand

    [CCode (cname = "SDL_GPUMultisampleState", has_type_id = false)]
    public struct GPUMultisampleState {
        public GPUSampleCount sample_count;
        public uint32 sample_mask;
        public bool enable_mask;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
    } // GPUMultisampleState

    [CCode (cname = "SDL_GPURasterizerState", has_type_id = false)]
    public struct GPURasterizerState {
        public GPUFillMode fill_mode;
        public GPUCullMode cull_mode;
        public GPUFrontFace front_face;
        public float depth_bias_constant_factor;
        public float depth_bias_clamp;
        public float depth_bias_slope_factor;
        public bool enable_depth_bias;
        public bool enable_depth_clip;
        public uint8 padding1;
        public uint8 padding2;
    } // GPURasterizerState

    [CCode (cname = "SDL_GPUSamplerCreateInfo", has_type_id = false)]
    public struct GPUSamplerCreateInfo {
        public GPUFilter min_filter;
        public GPUFilter mag_filter;
        public GPUSamplerMipmapMode mipmap_mode;
        public GPUSamplerAddressMode address_mode_u;
        public GPUSamplerAddressMode address_mode_v;
        public GPUSamplerAddressMode address_mode_w;
        public float mip_lod_bias;
        public float max_anisotropy;
        public GPUCompareOp compare_op;
        public float min_lod;
        public float max_lod;
        public bool enable_anisotropy;
        public bool enable_compare;
        public uint8 padding1;
        public uint8 padding2;
        public Properties.PropertiesID props;
    } // GPUSamplerCreateInfo

    [CCode (cname = "SDL_GPUShaderCreateInfo", has_type_id = false)]
    public struct GPUShaderCreateInfo {
        public size_t code_size;
        public char[] code;
        public string entrypoint;
        public GPUShaderFormat format;
        public GPUShaderStage stage;
        public uint32 num_samplers;
        public uint32 num_storage_textures;
        public uint32 num_storage_buffers;
        public uint32 num_uniform_buffers;
        public Properties.PropertiesID props;
    } // GPUShaderCreateInfo

    [CCode (cname = "SDL_GPUStencilOpState", has_type_id = false)]
    public struct GPUStencilOpState {
        public GPUStencilOp fail_op;
        public GPUStencilOp pass_op;
        public GPUStencilOp depth_fail_op;
        public GPUCompareOp compare_op;
    } // GPUStencilOpState

    [CCode (cname = "SDL_GPUStorageBufferReadWriteBinding", has_type_id = false)]
    public struct GPUStorageBufferReadWriteBinding {
        public GPUBuffer buffer;
        public bool cycle;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
    } // GPUStorageBufferReadWriteBinding

    [CCode (cname = "SDL_GPUStorageTextureReadWriteBinding", has_type_id = false)]
    public struct GPUStorageTextureReadWriteBinding {
        public GPUTexture texture;
        public uint32 mip_level;
        public uint32 layer;
        public bool cycle;
        public uint8 padding1;
        public uint8 padding2;
        public uint8 padding3;
    } // GPUStorageTextureReadWriteBinding

    [CCode (cname = "SDL_GPUTextureCreateInfo", has_type_id = false)]
    public struct GPUTextureCreateInfo {
        public GPUTextureType type;
        public GPUTextureFormat format;
        public GPUTextureUsageFlags usage;
        public uint32 width;
        public uint32 height;
        public uint32 layer_count_or_depth;
        public uint32 num_levels;
        public GPUSampleCount sample_count;
        public Properties.PropertiesID props;
    } // GPUTextureCreateInfo

    [CCode (cname = "SDL_GPUTextureLocation", has_type_id = false)]
    public struct GPUTextureLocation {
        public GPUTexture texture;
        public uint32 mip_level;
        public uint32 layer;
        public uint32 x;
        public uint32 y;
        public uint32 z;
    } // GPUTextureLocation

    [CCode (cname = "SDL_GPUTextureRegion", has_type_id = false)]
    public struct GPUTextureRegion {
        public GPUTexture texture;
        public uint32 mip_level;
        public uint32 layer;
        public uint32 x;
        public uint32 y;
        public uint32 z;
        public uint32 w;
        public uint32 h;
        public uint32 d;
    } // GPUTextureRegion

    [CCode (cname = "SDL_GPUTextureSamplerBinding", has_type_id = false)]
    public struct GPUTextureSamplerBinding {
        public GPUTexture texture;
        public GPUSampler sampler;
    } // GPUTextureSamplerBinding

    [CCode (cname = "SDL_GPUTextureTransferInfo", has_type_id = false)]
    public struct GPUTextureTransferInfo {
        public GPUTransferBuffer transfer_buffer;
        public uint32 offset;
        public uint32 pixels_per_row;
        public uint32 rows_per_layer;
    } // GPUTextureTransferInfo

    [CCode (cname = "SDL_GPUTransferBufferCreateInfo", has_type_id = false)]
    public struct GPUTransferBufferCreateInfo {
        public GPUTransferBufferUsage usage;
        public int32 size;
        Properties.PropertiesID props;
    } // GPUTransferBufferCreateInfo

    [CCode (cname = "SDL_GPUTransferBufferLocation", has_type_id = false)]
    public struct GPUTransferBufferLocation {
        public GPUTransferBuffer transfer_buffer;
        public uint32 offset;
    } // GPUTransferBufferLocation

    [CCode (cname = "SDL_GPUVertexAttribute", has_type_id = false)]
    public struct GPUVertexAttribute {
        public uint32 location;
        public uint32 buffer_slot;
        public GPUVertexElementFormat format;
        public uint32 offset;
    } // GPUVertexAttribute

    [CCode (cname = "SDL_GPUVertexBufferDescription", has_type_id = false)]
    public struct GPUVertexBufferDescription {
        public uint32 slot;
        public uint32 pitch;
        public GPUVertexInputRate input_rate;
        public uint32 instance_step_rate;
    } // GPUVertexBufferDescription

    [CCode (cname = "SDL_GPUVertexInputState", has_type_id = false)]
    public struct GPUVertexInputState {
        public GPUVertexBufferDescription[] vertex_buffer_descriptions;
        public uint32 num_vertex_buffers;
        public GPUVertexAttribute[] vertex_attributes;
        public uint32 num_vertex_attributes;
    } // GPUVertexInputState

    [CCode (cname = "SDL_GPUViewport", has_type_id = false)]
    public struct GPUViewport {
        public float x;
        public float y;
        public float w;
        public float h;
        public float min_depth;
        public float max_depth;
    } // GPUViewport

    [CCode (cname = "SDL_GPUBlendFactor", cprefix = "SDL_GPU_BLENDFACTOR_", has_type_id = false)]
    public enum GPUBlendFactor {
        INVALID,
        ZERO,
        ONE,
        SRC_COLOR,
        ONE_MINUS_SRC_COLOR,
        DST_COLOR,
        ONE_MINUS_DST_COLOR,
        SRC_ALPHA,
        ONE_MINUS_SRC_ALPHA,
        DST_ALPHA,
        ONE_MINUS_DST_ALPHA,
        CONSTANT_COLOR,
        ONE_MINUS_CONSTANT_COLOR,
        SRC_ALPHA_SATURATE,
    } // GPUBlendFactor

    [CCode (cname = "SDL_GPUBlendOp", cprefix = "SDL_GPU_BLENDOP_", has_type_id = false)]
    public enum GPUBlendOp {
        INVALID,
        ADD,
        SUBTRACT,
        REVERSE_SUBTRACT,
        MIN,
        MAX,
    } // GPUBlendOp

    [CCode (cname = "SDL_GPUCompareOp", cprefix = "SDL_GPU_COMPAREOP_", has_type_id = false)]
    public enum GPUCompareOp {
        INVALID,
        NEVER,
        LESS,
        EQUAL,
        LESS_OR_EQUAL,
        GREATER,
        NOT_EQUAL,
        GREATER_OR_EQUAL,
        ALWAYS,
    } // GPUCompareOp

    [CCode (cname = "SDL_GPUCubeMapFace", cprefix = "SDL_GPU_CUBEMAPFACE_", has_type_id = false)]
    public enum GPUCubeMapFace {
        POSITIVEX,
        NEGATIVEX,
        POSITIVEY,
        NEGATIVEY,
        POSITIVEZ,
        NEGATIVEZ,
    } // GPUCubeMapFace

    [CCode (cname = "SDL_GPUCullMode", cprefix = "SDL_GPU_CULLMODE_", has_type_id = false)]
    public enum GPUCullMode {
        NONE,
        FRONT,
        BACK,
    } // GPUCullMode

    [CCode (cname = "SDL_GPUFillMode", cprefix = "SDL_GPU_FILLMODE_", has_type_id = false)]
    public enum GPUFillMode {
        FILL,
        LINE,
    } // GPUFillMode

    [CCode (cname = "SDL_GPUFilter", cprefix = "SDL_GPU_FILTER_", has_type_id = false)]
    public enum GPUFilter {
        NEAREST,
        LINEAR,
    } // GPUFilter

    [CCode (cname = "SDL_GPUFrontFace", cprefix = "SDL_GSDL_GPU_FRONTFACE_PU_FILTER_", has_type_id = false)]
    public enum GPUFrontFace {
        COUNTER_CLOCKWISE,
        CLOCKWISE,
    } // GPUFrontFace

    [CCode (cname = "SDL_GPUIndexElementSize", has_type_id = false)]
    public enum GPUIndexElementSize {
        [CCode (cname = "SDL_GPU_INDEXELEMENTSIZE_16BIT")]
        SIZE_16BIT,
        [CCode (cname = "SDL_GPU_INDEXELEMENTSIZE_32BIT")]
        SIZE_32BIT,
    } // GPUIndexElementSize

    [CCode (cname = "SDL_GPULoadOp", cprefix = "SDL_GPU_LOADOP_", has_type_id = false)]
    public enum GPULoadOp {
        LOAD,
        CLEAR,
        DONT_CARE,
    } // GPULoadOp

    [CCode (cname = "SDL_GPUPresentMode", cprefix = "SDL_GPU_PRESENTMODE_", has_type_id = false)]
    public enum GPUPresentMode {
        VSYNC,
        IMMEDIATE,
        MAILBOX,
    } // GPUPresentMode

    [CCode (cname = "SDL_GPUPrimitiveType", cprefix = "SDL_GPU_PRIMITIVETYPE_", has_type_id = false)]
    public enum GPUPrimitiveType {
        TRIANGLELIST,
        TRIANGLESTRIP,
        LINELIST,
        LINESTRIP,
        POINTLIST,
    } // GPUPrimitiveType

    [CCode (cname = "SDL_GPUSampleCount", has_type_id = false)]
    public enum GPUSampleCount {
        [CCode (cname = "SDL_GPU_SAMPLECOUNT_1")]
        ONE,
        [CCode (cname = "SDL_GPU_SAMPLECOUNT_2")]
        TWO,
        [CCode (cname = "SDL_GPU_SAMPLECOUNT_4")]
        FOUR,
        [CCode (cname = "SDL_GPU_SAMPLECOUNT_8")]
        EIGHT,
    } // GPUSampleCount

    [CCode (cname = "SDL_GPUSamplerAddressMode", cprefix = "SDL_GPU_SAMPLERADDRESSMODE_", has_type_id = false)]
    public enum GPUSamplerAddressMode {
        REPEAT,
        MIRRORED_REPEAT,
        CLAMP_TO_EDGE,
    } // GPUSamplerAddressMode

    [CCode (cname = "SDL_GPUSamplerMipmapMode", cprefix = "SDL_GPU_SAMPLERMIPMAPMODE_", has_type_id = false)]
    public enum GPUSamplerMipmapMode {
        NEAREST,
        LINEAR,
    } // GPUSamplerMipmapMode

    [CCode (cname = "SDL_GPUShaderStage", cprefix = "SDL_GPU_SHADERSTAGE_", has_type_id = false)]
    public enum GPUShaderStage {
        VERTEX,
        FRAGMENT,
    } // GPUShaderStage

    [CCode (cname = "SDL_GPUStencilOp", cprefix = "SDL_GPU_STENCILOP_", has_type_id = false)]
    public enum GPUStencilOp {
        INVALID,
        KEEP,
        ZERO,
        REPLACE,
        INCREMENT_AND_CLAMP,
        DECREMENT_AND_CLAMP,
        INVERT,
        INCREMENT_AND_WRAP,
        DECREMENT_AND_WRAP,
    } // GPUStencilOp

    [CCode (cname = "SDL_GPUStoreOp", cprefix = "SDL_GPU_STOREOP_", has_type_id = false)]
    public enum GPUStoreOp {
        STORE,
        DONT_CARE,
        RESOLVE,
        RESOLVE_AND_STORE,
    } // GPUStoreOp

    [CCode (cname = "SDL_GPUSwapchainComposition", cprefix = "SDL_GPU_SWAPCHAINCOMPOSITION_", has_type_id = false)]
    public enum GPUSwapchainComposition {
        SDR,
        SDR_LINEAR,
        HDR_EXTENDED_LINEAR,
        HDR10_ST2084,
    } // GPUSwapchainComposition

    [CCode (cname = "SDL_GPUTextureFormat", cprefix = "SDL_GPU_TEXTUREFORMAT_", has_type_id = false)]
    public enum GPUTextureFormat {
        INVALID,
        A8_UNORM,
        R8_UNORM,
        R8G8_UNORM,
        R8G8B8A8_UNORM,
        R16_UNORM,
        R16G16_UNORM,
        R16G16B16A16_UNORM,
        R10G10B10A2_UNORM,
        B5G6R5_UNORM,
        B5G5R5A1_UNORM,
        B4G4R4A4_UNORM,
        B8G8R8A8_UNORM,
        BC1_RGBA_UNORM,
        BC2_RGBA_UNORM,
        BC3_RGBA_UNORM,
        BC4_R_UNORM,
        BC5_RG_UNORM,
        BC7_RGBA_UNORM,
        BC6H_RGB_FLOAT,
        BC6H_RGB_UFLOAT,
        R8_SNORM,
        R8G8_SNORM,
        R8G8B8A8_SNORM,
        R16_SNORM,
        R16G16_SNORM,
        R16G16B16A16_SNORM,
        R16_FLOAT,
        R16G16_FLOAT,
        R16G16B16A16_FLOAT,
        R32_FLOAT,
        R32G32_FLOAT,
        R32G32B32A32_FLOAT,
        R11G11B10_UFLOAT,
        R8_UINT,
        R8G8_UINT,
        R8G8B8A8_UINT,
        R16_UINT,
        R16G16_UINT,
        R16G16B16A16_UINT,
        R32_UINT,
        R32G32_UINT,
        R32G32B32A32_UINT,
        R8_INT,
        R8G8_INT,
        R8G8B8A8_INT,
        R16_INT,
        R16G16_INT,
        R16G16B16A16_INT,
        R32_INT,
        R32G32_INT,
        R32G32B32A32_INT,
        R8G8B8A8_UNORM_SRGB,
        B8G8R8A8_UNORM_SRGB,
        BC1_RGBA_UNORM_SRGB,
        BC2_RGBA_UNORM_SRGB,
        BC3_RGBA_UNORM_SRGB,
        BC7_RGBA_UNORM_SRGB,
        D16_UNORM,
        D24_UNORM,
        D32_FLOAT,
        D24_UNORM_S8_UINT,
        D32_FLOAT_S8_UINT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM")]
        ASTC_4X4_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM")]
        ASTC_5X4_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM")]
        ASTC_5X5_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM")]
        ASTC_6X5_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM")]
        ASTC_6X6_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM")]
        ASTC_8X5_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM")]
        ASTC_8X6_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM")]
        ASTC_8X8_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM")]
        ASTC_10X5_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM")]
        ASTC_10X6_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM")]
        ASTC_10X8_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM")]
        ASTC_10X10_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM")]
        ASTC_12X10_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM")]
        ASTC_12X12_UNORM,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM_SRGB")]
        ASTC_4X4_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM_SRGB")]
        ASTC_5X4_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM_SRGB")]
        ASTC_5X5_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM_SRGB")]
        ASTC_6X5_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM_SRGB")]
        ASTC_6X6_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM_SRGB")]
        ASTC_8X5_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM_SRGB")]
        ASTC_8X6_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM_SRGB")]
        ASTC_8X8_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM_SRGB")]
        ASTC_10X5_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM_SRGB")]
        ASTC_10X6_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM_SRGB")]
        ASTC_10X8_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM_SRGB")]
        ASTC_10X10_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM_SRGB")]
        ASTC_12X10_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM_SRGB")]
        ASTC_12X12_UNORM_SRGB,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_4x4_FLOAT")]
        ASTC_4X4_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_5x4_FLOAT")]
        ASTC_5X4_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_5x5_FLOAT")]
        ASTC_5X5_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_6x5_FLOAT")]
        ASTC_6X5_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_6x6_FLOAT")]
        ASTC_6X6_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x5_FLOAT")]
        ASTC_8X5_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x6_FLOAT")]
        ASTC_8X6_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_8x8_FLOAT")]
        ASTC_8X8_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x5_FLOAT")]
        ASTC_10X5_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x6_FLOAT")]
        ASTC_10X6_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x8_FLOAT")]
        ASTC_10X8_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_10x10_FLOAT")]
        ASTC_10X10_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_12x10_FLOAT")]
        ASTC_12X10_FLOAT,
        [CCode (cname = "SDL_GPU_TEXTUREFORMAT_ASTC_12x12_FLOAT")]
        ASTC_12X12_FLOAT,
    } // GPUTextureFormat

    [CCode (cname = "SDL_GPUTextureType", cprefix = "SDL_GPU_", has_type_id = false)]
    public enum GPUTextureType {
        TEXTURETYPE_2D,
        TEXTURETYPE_2D_ARRAY,
        TEXTURETYPE_3D,
        TEXTURETYPE_CUBE,
        TEXTURETYPE_CUBE_ARRAY,
    } // GPUTextureType

    [CCode (cname = "SDL_GPUTransferBufferUsage", cprefix = "SDL_GPU_TRANSFERBUFFERUSAGE_", has_type_id = false)]
    public enum GPUTransferBufferUsage {
        UPLOAD,
        DOWNLOAD,
    } // GPUTransferBufferUsage

    [CCode (cname = "SDL_GPUVertexElementFormat", cprefix = "SDL_GPU_VERTEXELEMENTFORMAT_", has_type_id = false)]
    public enum GPUVertexElementFormat {
        INVALID,
        INT,
        INT2,
        INT3,
        INT4,
        UINT,
        UINT2,
        UINT3,
        UINT4,
        FLOAT,
        FLOAT2,
        FLOAT3,
        FLOAT4,
        BYTE2,
        BYTE4,
        UBYTE2,
        UBYTE4,
        BYTE2_NORM,
        BYTE4_NORM,
        UBYTE2_NORM,
        UBYTE4_NORM,
        SHORT2,
        SHORT4,
        USHORT2,
        USHORT4,
        SHORT2_NORM,
        SHORT4_NORM,
        USHORT2_NORM,
        USHORT4_NORM,
        HALF2,
        HALF4,
    } // GPUVertexElementFormat

    [CCode (cname = "SDL_GPUVertexInputRate", cprefix = "SDL_GPU_VERTEXINPUTRATE_", has_type_id = false)]
    public enum GPUVertexInputRate {
        VERTEX,
        INSTANCE,
    } // GPUVertexInputRate

    namespace SDLPropGPUDeviceCreate {
        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN")]
        public const string DEBUGMODE_BOOLEAN;

        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN")]
        public const string PREFERLOWPOWER_BOOLEAN;

        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING")]
        public const string NAME_STRING;

        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN")]
        public const string SHADERS_PRIVATE_BOOLEAN;

        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN")]
        public const string SHADERS_SPIRV_BOOLEAN;

        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN")]
        public const string SHADERS_DXBC_BOOLEAN;

        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN")]
        public const string SHADERS_DXIL_BOOLEAN;

        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN")]
        public const string SHADERS_MSL_BOOLEAN;

        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN")]
        public const string SHADERS_METALLIB_BOOLEAN;

        // D3D 12
        [CCode (cname = "SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING")]
        public const string D3D12_SEMANTIC_NAME_STRING;
    } // SDLPropGPUDeviceCreate
} // SDL.Gpu

///
/// Threads
///

///
/// Thread Management (SDL_thread.h)
///
[CCode (cheader_filename = "SDL3/SDL_thread.h")]
namespace SDL.Threads {
    [CCode (cname = "SDL_CleanupTLS")]
    public static void cleanup_tls ();

    [CCode (cname = "SDL_CreateThread", has_target = true)]
    public static Thread ? create_thread (ThreadFunction fn, string name);

    [CCode (cname = "SDL_CreateThreadWithProperties")]
    public static Thread ? create_thread_with_properties (Properties.PropertiesID props);

    [CCode (cname = "SDL_DetachThread")]
    public static void detahc_thread (Thread thread);

    [CCode (cname = "SDL_GetCurrentThreadID")]
    public static ThreadID get_current_thread_id ();

    [CCode (cname = "SDL_GetThreadID")]
    public static ThreadID get_thread_id (Thread thread);

    [CCode (cname = "SDL_GetThreadName")]
    public static unowned string get_thread_name (Thread thread);

    [CCode (cname = "SDL_GetThreadState")]
    public static ThreadState get_thread_state (Thread thread);

    [CCode (cname = "SDL_GetTLS")]
    public static void * get_tls (TLSId id);

    [CCode (cname = "SDL_SetCurrentThreadPriority")]
    public static bool set_current_thread_priority (ThreadPriority priority);

    [CCode (cname = "SDL_SetTLS")]
    public static bool set_tls (TLSId id, void* value, TLSDestructorCallback? destructor);

    [CCode (cname = "SDL_WaitThread")]
    public static void wait_thread (Thread thread, out int status);

    [CCode (cname = "SDL_Thread", has_type_id = false)]
    public struct Thread {}

    [CCode (cname = "SDL_ThreadFunction", has_target = true)]
    public delegate int ThreadFunction ();

    [SimpleType, CCode (cname = "SDL_ThreadID", has_type_id = false)]
    public struct ThreadID : uint64 {}

    [CCode (cname = "SDL_TLSDestructorCallback")]
    public delegate void TLSDestructorCallback (void* value);

    [CCode (cname = "SDL_TLSDestructorCallback", has_type_id = false)]
    public struct TLSId : Atomic.AtomicInt {}

    [CCode (cname = "SDL_ThreadPriority", cprefix = "SDL_THREAD_PRIORITY_", has_type_id = false)]
    public enum ThreadPriority {
        LOW,
        NORMAL,
        HIGH,
        TIME_CRITICAL,
    } // ThreadPriority

    [CCode (cname = "SDL_ThreadState", cprefix = "SDL_THREAD_", has_type_id = false)]
    public enum ThreadState {
        UNKNOWN,
        ALIVE,
        DETACHED,
        COMPLETE,
    } // ThreadState

    namespace SDLPropThreadCreate {
        [CCode (cname = "SDL_PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER")]
        public const string ENTRY_FUNCTION_POINTER;

        [CCode (cname = "SDL_PROP_THREAD_CREATE_NAME_STRING")]
        public const string NAME_STRING;

        [CCode (cname = "SDL_PROP_THREAD_CREATE_USERDATA_POINTER")]
        public const string USERDATA_POINTER;

        [CCode (cname = "SDL_PROP_THREAD_CREATE_STACKSIZE_NUMBER")]
        public const string STACKSIZE_NUMBER;
    } // SDLPropThreadCreate
} // SDL.Threads

///
/// Thread Synchronization Primitives (SDL_mutex.h)
///
[CCode (cheader_filename = "SDL3/SDL_mutex.h")]
namespace SDL.Mutex {
    [CCode (cname = "SDL_BroadcastCondition")]
    public static void broadcast_condition (Condition cond);

    [CCode (cname = "SDL_CreateCondition")]
    public static Condition ? create_condition ();

    [CCode (cname = "SDL_CreateMutex")]
    public static Mutex ? create_mutex ();

    [CCode (cname = "SDL_CreateRWLock")]
    public static RWLock ? create_rw_lock ();

    [CCode (cname = "SDL_CreateSemaphore")]
    public static Semaphore ? create_semaphore (uint32 initial_value);

    [CCode (cname = "SDL_DestroyCondition")]
    public static void destroy_condition (Condition cond);

    [CCode (cname = "SDL_DestroyMutex")]
    public static void destroy_mutex (Mutex mutex);

    [CCode (cname = "SDL_DestroyRWLock")]
    public static void destroy_rw_lock (RWLock rwlock);

    [CCode (cname = "SDL_DestroySemaphore")]
    public static void destroy_semaphore (Semaphore sem);

    [CCode (cname = "SDL_GetSemaphoreValue")]
    public static uint32 get_semaphore_value (Semaphore sem);

    [CCode (cname = "SDL_LockMutex")]
    public static void lock_mutex (Mutex mutex);

    [CCode (cname = "SDL_LockRWLockForReading")]
    public static void lock_rw_lock_for_reading (RWLock rwlock);

    [CCode (cname = "SDL_LockRWLockForWriting")]
    public static void lock_rw_lock_for_writing (RWLock rwlock);

    [CCode (cname = "SDL_SetInitialized")]
    public static void set_initialized (InitState state, bool initialized);

    [CCode (cname = "SDL_ShouldInit")]
    public static bool should_init (InitState state);

    [CCode (cname = "SDL_ShouldQuit")]
    public static bool should_quit (InitState state);

    [CCode (cname = "SDL_SignalCondition")]
    public static void signal_condition (Condition cond);

    [CCode (cname = "SDL_SignalSemaphore")]
    public static void signal_semaphore (Semaphore sem);

    [CCode (cname = "SDL_TryLockMutex")]
    public static bool try_lock_mutex (Mutex mutex);

    [CCode (cname = "SDL_TryLockRWLockForReading")]
    public static bool try_lock_rw_for_reading (RWLock rwlock);

    [CCode (cname = "SDL_TryLockRWLockForWriting")]
    public static bool try_lock_rw_for_writing (RWLock rwlock);

    [CCode (cname = "SDL_TryWaitSemaphore")]
    public static bool try_wait_semaphore (Semaphore sem);

    [CCode (cname = "SDL_UnlockMutex")]
    public static void unlock_mutex (Mutex mutex);

    [CCode (cname = "SDL_UnlockRWLock")]
    public static void unlock_rw_lock (RWLock rwlock);

    [CCode (cname = "SDL_WaitCondition")]
    public static void wait_condition (Condition cond, Mutex mutex);

    [CCode (cname = "SDL_WaitConditionTimeout")]
    public static bool wait_condition_timeout (Condition cond, Mutex mutex, int32 timeout_ms);

    [CCode (cname = "SDL_WaitSemaphore")]
    public static void wait_semaphore (Semaphore sem);

    [CCode (cname = "SDL_WaitSemaphoreTimeout")]
    public static bool wait_semaphore_timeout (Semaphore sem, int32 timeout_ms);

    [Compact, CCode (cname = "SDL_Condition", free_function = "", has_type_id = false)]
    public struct Condition {}

    [Compact, CCode (cname = "SDL_Mutex", free_function = "", has_type_id = false)]
    public struct Mutex {}

    [Compact, CCode (cname = "SDL_RWLock", free_function = "", has_type_id = false)]
    public class RWLock {}

    [Compact, CCode (cname = "SDL_Semaphore", free_function = "", has_type_id = false)]
    public class Semaphore {}

    [CCode (cname = "SDL_InitState", has_type_id = false)]
    public struct InitState {
        public Atomic.AtomicInt status;
        public Threads.ThreadID thread;
        public void* reserved;
    } // InitState

    [CCode (cname = "SDL_InitStatus", cprefix = "SDL_INIT_STATUS_", has_type_id = false)]
    public enum InitStatus {
        UNINITIALIZED,
        INITIALIZING,
        INITIALIZED,
        UNINITIALIZING,
    } // InitStatus
} // SDL.Mutex

///
/// Atomic Operations (SDL_atomic.h)
///
[CCode (cheader_filename = "SDL3/SDL_atomic.h")]
namespace SDL.Atomic {
    [CCode (cname = "SDL_AddAtomicInt")]
    public static int add_atomic_int (AtomicInt a, int v);

    [CCode (cname = "SDL_CompareAndSwapAtomicInt")]
    public static bool compare_and_swap_atomic_int (AtomicInt a, int oldval, int newval);

    [CCode (cname = "SDL_CompareAndSwapAtomicPointer")]
    public static bool compare_and_swap_atomic_pointer (void* * a, void* oldval, void* newval);

    [CCode (cname = "SDL_CompareAndSwapAtomicU32")]
    public static bool compare_and_swap_atomic_u32 (AtomicU32 a, uint32 oldval, uint32 newval);

    [CCode (cname = "SDL_GetAtomicInt")]
    public static int get_atomic_int (AtomicInt a);

    [CCode (cname = "SDL_GetAtomicPointer")]
    public static void * get_atomic_pointer (void* * a);

    [CCode (cname = "SDL_GetAtomicU32")]
    public static uint32 get_atomic_u32 (AtomicU32 a);

    [CCode (cname = "SDL_LockSpinlock")]
    public static void lock_spin_lock (SpinLock spin_lock);

    [CCode (cname = "SDL_MemoryBarrierAcquireFunction")]
    public static void memory_barrier_acquire_function ();

    [CCode (cname = "SDL_MemoryBarrierReleaseFunction")]
    public static void memory_barrier_release_function ();

    [CCode (cname = "SDL_SetAtomicInt")]
    public static int set_atomic_int (AtomicInt a, int v);

    [CCode (cname = "SDL_SetAtomicPointer")]
    public static void * set_atomic_pointer (void* * a, void* v);

    [CCode (cname = "SDL_SetAtomicU32")]
    public static uint32 set_atomic_u32 (AtomicU32 a, uint32 v);

    [CCode (cname = "SDL_TryLockSpinlock")]
    public static bool try_to_spin_lock (SpinLock spin_lock);

    [CCode (cname = "SDL_UnlockSpinlock")]
    public static void unlock_spin_lock (SpinLock spin_lock);

    [SimpleType, CCode (cname = "SDL_SpinLock", has_type_id = false)]
    public struct SpinLock : int {}

    [CCode (cname = "SDL_AtomicInt", has_type_id = false)]
    public struct AtomicInt {
        public int value;
    } // AtomicInt

    [CCode (cname = "SDL_AtomicU32", has_type_id = false)]
    public struct AtomicU32 {
        public uint32 value;
    } // AtomicU32

    [CCode (cname = "SDL_AtomicDecRef")]
    public static bool atomic_dec_ref (AtomicInt a);

    [CCode (cname = "SDL_AtomicIncRef")]
    public static bool atomic_inc_ref (AtomicInt a);

    [CCode (cname = "SDL_CompilerBarrier")]
    public static void compiler_barrier ();

    [CCode (cname = "SDL_CPUPauseInstruction")]
    public static void cpu_pause_instruction ();

    [CCode (cname = "SDL_MemoryBarrierAcquire")]
    public static void memory_barrier_acquire ();

    [CCode (cname = "SDL_MemoryBarrierRelease")]
    public static void memory_barrier_release ();
} // SDL.Atomic

///
/// TIME
///

///
/// Timer Support (SDL_timer.h)
///
[CCode (cheader_filename = "SDL3/SDL_timer.h")]
namespace SDL.Timer {
    [CCode (cname = "SDL_AddTimer", has_target = true)]
    public static TimerID add_timer (uint32 interval, TimerCallback callback);

    [CCode (cname = "SDL_AddTimerNS", has_target = true)]
    public static TimerID add_timer_ns (uint64 interval, NSTimerCallback callback);

    [CCode (cname = "SDL_Delay")]
    public static void delay (uint32 ms);

    [CCode (cname = "SDL_DelayNS")]
    public static void delay_ns (uint64 ns);

    [CCode (cname = "SDL_DelayPrecise")]
    public static void delay_precise (uint64 ns);

    [CCode (cname = "SDL_GetPerformanceCounter")]
    public static uint64 get_performance_counter ();

    [CCode (cname = "SDL_GetPerformanceFrequency")]
    public static uint64 get_performance_frecuency ();

    [CCode (cname = "SDL_GetTicks")]
    public static uint64 get_ticks ();

    [CCode (cname = "SDL_GetTicksNS")]
    public static uint64 get_ticks_ns ();

    [CCode (cname = "SDL_RemoveTimer")]
    public static bool remove_timer (TimerID id);

    [CCode (cname = "SDL_NSTimerCallback", instance_pos = 0)]
    public delegate uint64 NSTimerCallback (TimerID timer_id, uint64 interval);

    [CCode (cname = "SDL_TimerCallback", instance_pos = 0)]
    public delegate uint32 TimerCallback (TimerID timer_id, uint32 interval);

    [SimpleType, CCode (cname = "SDL_TimerID", has_type_id = false)]
    public struct TimerID : uint32 {}

    [CCode (cname = "SDL_MS_PER_SECOND")]
    public const double MS_PER_SECOND;

    [CCode (cname = "SDL_MS_TO_NS")]
    public static double ms_to_ns (double ms);

    [CCode (cname = "SDL_NS_PER_MS")]
    public const double NS_PER_MS;

    [CCode (cname = "SDL_NS_PER_SECOND")]
    public const double NS_PER_SECOND;

    [CCode (cname = "SDL_NS_PER_US")]
    public const double NS_PER_US;

    [CCode (cname = "SDL_NS_TO_MS")]
    public static double ns_to_ms (double ns);

    [CCode (cname = "SDL_NS_TO_SECONDS")]
    public static double ns_to_seconds (double ns);

    [CCode (cname = "SDL_NS_TO_US")]
    public static double ns_to_us (double ns);

    [CCode (cname = "SDL_SECONDS_TO_NS")]
    public static double seconds_to_ns (double s);

    [CCode (cname = "SDL_US_PER_SECOND")]
    public const double US_PER_SECOND;

    [CCode (cname = "SDL_US_TO_NS")]
    public static double us_to_ns (double us);
} // SDL.Timer

///
/// Date and Time (SDL_time.h)
///
[CCode (cheader_filename = "SDL3/SDL_time.h")]
namespace SDL.Time {
    [CCode (cname = "SDL_DateTimeToTime")]
    public static bool datetime_to_time (Time.DateTime dt, out StdInc.Time ticks);

    [CCode (cname = "SDL_GetCurrentTime")]
    public static bool get_current_time (out StdInc.Time ticks);

    [CCode (cname = "SDL_GetDateTimeLocalePreferences")]
    public static bool get_date_time_locale_preferences (out DateFormat? date_format, out TimeFormat? time_format);

    [CCode (cname = "SDL_GetDayOfWeek")]
    public static int get_day_of_week (int year, int month, int day);

    [CCode (cname = "SDL_GetDayOfYear")]
    public static int get_day_of_year (int year, int month, int day);

    [CCode (cname = "SDL_GetDaysInMonth")]
    public static int get_days_in_month (int year, int month);

    [CCode (cname = "SDL_TimeFromWindows")]
    public static StdInc.Time time_from_windows (uint32 dw_low_date_time, uint32 dw_high_date_time);

    [CCode (cname = "SDL_TimeToDateTime")]
    public static bool time_to_datetime (StdInc.Time ticks, out DateTime dt, out bool local_time);

    [CCode (cname = "SDL_TimeToWindows")]
    public static void time_to_windows (StdInc.Time ticks, out uint32 dw_low_date_time, out uint32 dw_high_date_time);

    [CCode (cname = "SDL_DateTime", has_type_id = false)]
    public struct DateTime {
        public int year;
        public int month;
        public int day;
        public int hour;
        public int minute;
        public int second;
        public int nanosecond;
        public int day_of_week;
        public int utc_offset;
    } // DateTime

    [CCode (cname = "SDL_DateFormat", cprefix = "SDL_DATE_FORMAT_", has_type_id = false)]
    public enum DateFormat {
        YYYYMMDD,
        DDMMYYYY,
        MMDDYYYY,
    } // DateFormat

    [CCode (cname = "SDL_TimeFormat", cprefix = "SDL_TIME_FORMAT_", has_type_id = false)]
    public enum TimeFormat {
        24HR,
        12HR,
    } // TimeFormat
} // SDL.Time

///
/// File and I/O Abstractions
///

///
/// Filesystem Access (SDL_filesystem.h)
///
[CCode (cheader_filename = "SDL3/SDL_filesystem.h")]
namespace SDL.FileSystem {
    [CCode (cname = "SDL_CopyFile")]
    public static bool copy_file (string oldpath, string newpath);

    [CCode (cname = "SDL_CreateDirectory")]
    public static bool create_directory (string path);

    [CCode (cname = "SDL_EnumerateDirectory", has_target = true)]
    public static bool enumerate_directory (string path, EnumerateDirectoryCallback callback);

    [CCode (cname = "SDL_GetBasePath")]
    public static unowned string ? get_base_path ();

    [CCode (cname = "SDL_GetCurrentDirectory")]
    public static unowned string ? get_current_directory ();

    [CCode (cname = "SDL_GetPathInfo")]
    public static bool get_path_info (string path, out PathInfo? info);

    [CCode (cname = "SDL_GetPrefPath")]
    public static unowned string ? get_pref_path (string org, string app);

    [CCode (cname = "SDL_GetUserFolder")]
    public static unowned string ? get_user_folder (Folder folder);

    [CCode (cname = "SDL_GlobDirectory")]
    public static unowned string[] ? glob_directory (string path, string? pattern, GlobFlags flags);

    [CCode (cname = "SDL_RemovePath")]
    public static bool remove_path (string path);

    [CCode (cname = "SDL_RenamePath")]
    public static bool rename_path (string oldpath, string newpath);

    [CCode (cname = "SDL_EnumerateDirectoryCallback", has_target = true, instance_pos = 0)]
    public delegate EnumerationResult EnumerateDirectoryCallback (string dirname, string fname);

    [CCode (cname = "uint32", cprefix = "SDL_GLOB_", has_type_id = false)]
    public enum GlobFlags {
        CASEINSENSITIVE,
    }

    [Flags, CCode (cname = "uint32", cprefix = "SDL_GPU_TEXTUREUSAGE_", has_type_id = false)]
    public enum GPUTextureUsageFlags {
        SAMPLER,
        COLOR_TARGET,
        DEPTH_STENCIL_TARGET,
        GRAPHICS_STORAGE_READ,
        COMPUTE_STORAGE_READ,
        COMPUTE_STORAGE_WRITE,
        COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE,
    }

    [CCode (cname = "SDL_PathInfo", has_type_id = false)]
    public struct PathInfo {
        public PathType type;
        public uint64 size;
        public StdInc.Time create_time;
        public StdInc.Time modify_time;
        public StdInc.Time access_time;
    } // PathInfo;

    [CCode (cname = "SDL_EnumerationResult", cprefix = "SDL_ENUM_", has_type_id = false)]
    public enum EnumerationResult {
        CONTINUE,
        SUCCESS,
        FAILURE,
    } // EnumerationResult

    [CCode (cname = "SDL_Folder", cprefix = "SDL_FOLDER_", has_type_id = false)]
    public enum Folder {
        HOME,
        DESKTOP,
        DOCUMENTS,
        DOWNLOADS,
        MUSIC,
        PICTURES,
        PUBLICSHARE,
        SAVEDGAMES,
        SCREENSHOTS,
        TEMPLATES,
        VIDEOS,
        COUNT,
    } // Folder

    [CCode (cname = "SDL_PathType", cprefix = "SDL_PATHTYPE_", has_type_id = false)]
    public enum PathType {
        NONE,
        FILE,
        DIRECTORY,
        OTHER,
    } // PathType
} // SDL.FileSystem

///
/// Storage Abstraction (SDL_storage.h)
///
[CCode (cheader_filename = "SDL3/SDL_storage.h")]
namespace SDL.Storage {
    [CCode (cname = "SDL_CloseStorage")]
    public static bool close_storage (Storage storage);

    [CCode (cname = "SDL_CopyStorageFile")]
    public static bool copy_storage_file (Storage storage, string oldpath, string newpath);

    [CCode (cname = "SDL_CreateStorageDirectory")]
    public static bool create_storage_directory (Storage storage, string path);

    [CCode (cname = "SDL_EnumerateStorageDirectory", has_target = true)]
    public static bool enumerate_storage_directory (Storage storage,
        string path,
        FileSystem.EnumerateDirectoryCallback callback);

    [CCode (cname = "SDL_GetStorageFileSize")]
    public static bool get_storage_file_size (Storage storage, string path, out uint64 length);

    [CCode (cname = "SDL_GetStoragePathInfo")]
    public static bool get_storage_path_info (Storage storage, string path, out FileSystem.PathInfo? info);

    [CCode (cname = "SDL_GetStorageSpaceRemaining")]
    public static uint64 get_storage_space_remaining (Storage storage);

    [CCode (cname = "SDL_GlobStorageDirectory")]
    public static unowned string[] ? glob_storage_directory (Storage storage,
        string path,
        string? pattern,
        FileSystem.GlobFlags flags);

    [CCode (cname = "SDL_OpenFileStorage")]
    public static Storage ? open_file_storage (string path);

    [CCode (cname = "SDL_OpenStorage", has_target = true)]
    public static Storage ? open_storage (StorageInterface iface);

    [CCode (cname = "SDL_OpenTitleStorage")]
    public static Storage ? open_title_storage (string override_path, Properties.PropertiesID props);

    [CCode (cname = "SDL_OpenUserStorage")]
    public static Storage ? open_user_storage (string org, string app, Properties.PropertiesID props);

    [CCode (cname = "SDL_ReadStorageFile")]
    public static bool read_storage_file (Storage storage, string path, ref void* destination, uint64 length);

    [CCode (cname = "SDL_RemoveStoragePath")]
    public static bool remove_storage_path (Storage storage, string path);

    [CCode (cname = "SDL_RenameStoragePath")]
    public static bool rename_storage_path (Storage storage, string oldpath, string newpath);

    [CCode (cname = "SDL_StorageReady")]
    public static bool storage_ready (Storage storage);

    [CCode (cname = "SDL_WriteStorageFile")]
    public static bool write_sotrage_file (Storage storage, string path, void* source, uint64 length);

    [CCode (cname = "SDL_Storage", has_type_id = false)]
    public struct Storage {}

    [CCode (cname = "SDL_StorageInterface", has_type_id = false)]
    public struct StorageInterface {
        public uint32 version;

        [CCode (cname = "close", has_target = true)]
        public bool close ();

        [CCode (cname = "ready", has_target = true)]
        public bool ready ();

        [CCode (cname = "enumerate", has_target = true, instance_pos = 0, delegate_target_pos = 2)]
        public bool enumerate (string path, FileSystem.EnumerateDirectoryCallback callback);

        [CCode (cname = "info", has_target = true, instance_pos = 0)]
        public bool info (string path, out FileSystem.PathInfo info);

        [CCode (cname = "read_file", has_target = true, instance_pos = 0)]
        public bool read_file (string path, ref void* destination, uint64 length);

        [CCode (cname = "write_file", has_target = true, instance_pos = 0)]
        public bool write_file (string path, void* source, uint64 length);

        [CCode (cname = "mkdir", has_target = true, instance_pos = 0)]
        public bool mkdir (string path);

        [CCode (cname = "remove", has_target = true, instance_pos = 0)]
        public bool remove (string path);

        [CCode (cname = "rename", has_target = true, instance_pos = 0)]
        public bool rename (string oldpath, string newpath);

        [CCode (cname = "copy", has_target = true, instance_pos = 0)]
        public bool copy (string oldpath, string newpath);

        [CCode (cname = "space_remaining", has_target = true, instance_pos = 0)]
        public uint64 space_remaining ();
    } // StorageInterface;
} // SDL.Storage

///
/// I/O Streams (SDL_iostream.h)
///
[CCode (cheader_filename = "SDL3/SDL_iostream.h")]
namespace SDL.IOStream {
    [CCode (cname = "SDL_CloseIO")]
    public static bool close_io (IOStream context);

    [CCode (cname = "SDL_FlushIO")]
    public static bool flush_io (IOStream context);

    [CCode (cname = "SDL_GetIOProperties")]
    public static Properties.PropertiesID get_io_properties (IOStream context);

    [CCode (cname = "SDL_GetIOSize")]
    public static int64 get_io_size (IOStream context);

    [CCode (cname = "SDL_GetIOStatus")]
    public static IOStatus get_io_status (IOStream context);

    [CCode (cname = "SDL_IOFromConstMem")]
    public static IOStream ? io_from_const_mem (void* mem, size_t size);

    [CCode (cname = "SDL_IOFromDynamicMem")]
    public static IOStream ? io_from_dynamic_mem ();

    [CCode (cname = "SDL_IOFromFile")]
    public static IOStream ? io_from_file (string file, string mode);

    [CCode (cname = "SDL_IOFromMem")]
    public static IOStream ? io_from_mem (void* mem, size_t size);

    [CCode (cname = "SDL_IOprintf")]
    public static size_t io_printf (IOStream context, string fmt, ...);

    [CCode (cname = "SDL_LoadFile")]
    public static void * load_file (string file, size_t? datasize);

    [CCode (cname = "SDL_LoadFile")]
    public static void * load_file_io (IOStream src, size_t? datasize, bool close_io);

    [CCode (cname = "SDL_OpenIO", has_target = true)]
    public static IOStream ? open_io (IOStreamInterface iface);

    [CCode (cname = "SDL_ReadIO")]
    public static size_t read_io (IOStream context, void* ptr, size_t size);

    [CCode (cname = "SDL_ReadS16BE")]
    public static bool read_s16_be (IOStream src, out int16 value);

    [CCode (cname = "SDL_ReadS16LE")]
    public static bool read_s16_le (IOStream src, out int16 value);

    [CCode (cname = "SDL_ReadS32BE")]
    public static bool read_s32_be (IOStream src, out int32 value);

    [CCode (cname = "SDL_ReadS32LE")]
    public static bool read_s32_le (IOStream src, out int32 value);

    [CCode (cname = "SDL_ReadS64BE")]
    public static bool read_s64_be (IOStream src, out int64 value);

    [CCode (cname = "SDL_ReadS64LE")]
    public static bool read_s64_le (IOStream src, out int64 value);

    [CCode (cname = "SDL_ReadS8")]
    public static bool read_s8 (IOStream src, out int8 value);

    [CCode (cname = "SDL_ReadU16BE")]
    public static bool read_u16_be (IOStream src, out uint16 value);

    [CCode (cname = "SDL_ReadU16LE")]
    public static bool read_u16_le (IOStream src, out uint16 value);

    [CCode (cname = "SDL_ReadU32BE")]
    public static bool read_u32_be (IOStream src, out uint32 value);

    [CCode (cname = "SDL_ReadU32LE")]
    public static bool read_u32_le (IOStream src, out uint32 value);

    [CCode (cname = "SDL_ReadU64BE")]
    public static bool read_u64_be (IOStream src, out uint64 value);

    [CCode (cname = "SDL_ReadU64LE")]
    public static bool read_u64_le (IOStream src, out uint64 value);

    [CCode (cname = "SDL_ReadU8")]
    public static bool read_u8 (IOStream src, out uint8 value);

    [CCode (cname = "SDL_SaveFile")]
    public static bool save_file (string file, void* data, size_t datasize);

    [CCode (cname = "SDL_SaveFile_IO")]
    public static bool save_file_io (IOStream src, void* data, size_t datasize, bool close_io);

    [CCode (cname = "SDL_SeekIO")]
    public static int64 seek_io (IOStream context, int64 offset, IOWhence whence);

    [CCode (cname = "SDL_TellIO")]
    public static int64 tell_io (IOStream context);

    [CCode (cname = "SDL_WriteIO")]
    public static size_t write_io (IOStream context, void* ptr, size_t size);

    [CCode (cname = "SDL_WriteS16BE")]
    public static bool write_s16_be (IOStream dst, int16 value);

    [CCode (cname = "SDL_WriteS16LE")]
    public static bool write_s16_le (IOStream dst, int16 value);

    [CCode (cname = "SDL_WriteS32BE")]
    public static bool write_s32_be (IOStream dst, int32 value);

    [CCode (cname = "SDL_WriteS32LE")]
    public static bool write_s32_le (IOStream dst, int32 value);

    [CCode (cname = "SDL_WriteS64BE")]
    public static bool write_s64_be (IOStream dst, int64 value);

    [CCode (cname = "SDL_WriteS64LE")]
    public static bool write_s64_le (IOStream dst, int64 value);

    [CCode (cname = "SDL_WriteS8")]
    public static bool write_s8 (IOStream dst, int8 value);

    [CCode (cname = "SDL_WriteU16BE")]
    public static bool write_u16_be (IOStream dst, uint16 value);

    [CCode (cname = "SDL_WriteU16LE")]
    public static bool write_u16_le (IOStream dst, uint16 value);

    [CCode (cname = "SDL_WriteU32BE")]
    public static bool write_u32_be (IOStream dst, uint32 value);

    [CCode (cname = "SDL_WriteU32LE")]
    public static bool write_u32_le (IOStream dst, uint32 value);

    [CCode (cname = "SDL_WriteU64BE")]
    public static bool write_u64_be (IOStream dst, uint64 value);

    [CCode (cname = "SDL_WriteU64LE")]
    public static bool write_u64_le (IOStream dst, uint64 value);

    [CCode (cname = "SDL_WriteU8")]
    public static bool write_u8 (IOStream dst, uint8 value);

    [Compact, CCode (cname = "SDL_IOStream", free_function = "", has_type_id = false)]
    public class IOStream {}

    [CCode (cname = "SDL_IOStreamInterface", has_type_id = false)]
    public struct IOStreamInterface {
        public uint32 version;

        [CCode (cname = "size", has_target = true)]
        public int64 size ();

        [CCode (cname = "seek", has_target = true, instance_pos = 0)]
        public int64 seek (int64 offset, IOWhence whence);

        [CCode (cname = "read", has_target = true, instance_pos = 0)]
        public size_t read (void* ptr, size_t size, IOStatus status);

        [CCode (cname = "write", has_target = true, instance_pos = 0)]
        public size_t write (void* ptr, size_t size, IOStatus status);

        [CCode (cname = "flush", has_target = true, instance_pos = 0)]
        public bool flush (IOStatus status);

        [CCode (cname = "close", has_target = true)]
        public bool close ();
    } // IOStreamInterface

    [CCode (cname = "SDL_IOStatus", cprefix = "SDL_IO_STATUS_", has_type_id = false)]
    public enum IOStatus {
        READY,
        ERROR,
        EOF,
        NOT_READY,
        READONLY,
        WRITEONLY,
    } // IOStatus

    [CCode (cname = "SDL_IOWhence", cprefix = "SDL_IO_", has_type_id = false)]
    public enum IOWhence {
        SEEK_SET,
        SEEK_CUR,
        SEEK_END,
    } // IOWhence
} // SDL.IOStream

///
/// Async I/O (SDL_asyncio.h)
///
[CCode (cheader_filename = "SDL3/SDL_asyncio.h")]
namespace SDL.AsyncIO {
    [CCode (cname = "SDL_AsyncIOFromFile")]
    public static AsyncIO async_io_from_file (string file, string mode);

    [CCode (cname = "SDL_CloseAsyncIO", has_target = true)]
    public static bool close_async_io (AsyncIO asyncio, bool flush, AsyncIOQueue queue);

    [CCode (cname = "SDL_CreateAsyncIOQueue")]
    public static AsyncIOQueue create_async_io_queue ();

    [CCode (cname = "SDL_DestroyAsyncIOQueue")]
    public static void destroy_async_io_queue (AsyncIOQueue queue);

    [CCode (cname = "SDL_GetAsyncIOResult")]
    public static bool get_async_io_result (AsyncIOQueue queue, out AsyncIOOutcome outcome);

    [CCode (cname = "SDL_GetAsyncIOSize")]
    public static int64 get_async_io_size (AsyncIO asyncio);

    [CCode (cname = "SDL_LoadFileAsync")]
    public static bool load_file_async (string file, AsyncIOQueue queue, void* user_data);

    [CCode (cname = "SDL_ReadAsyncIO", has_target = true)]
    public static bool red_async_io (AsyncIO asyncio, void* ptr, uint64 offset, uint64 size, AsyncIOQueue queue);

    [CCode (cname = "SDL_SignalAsyncIOQueue")]
    public static void signal_async_io_queue (AsyncIOQueue queue);

    [CCode (cname = "SDL_WaitAsyncIOResult")]
    public static bool wait_async_io_result (AsyncIOQueue queue, out AsyncIOOutcome outcome, int32 timeout_ms);

    [CCode (cname = "SDL_WriteAsyncIO", has_target = true)]
    public static bool write_async_io (AsyncIO asyncio, ref void* ptr, uint64 offset, uint64 size, AsyncIOQueue queue);

    [CCode (cname = "SDL_AsyncIO", has_type_id = false)]
    public struct AsyncIO {}

    [Compact, CCode (cname = "SDL_AsyncIOQueue", free_function = "", has_type_id = false)]
    public class AsyncIOQueue {}

    [CCode (cname = "SDL_AsyncIOOutcome", has_type_id = false)]
    public struct AsyncIOOutcome {
        public AsyncIO asyncio;
        public AsyncIOTaskType type;
        public AsyncIOResult result;
        public void* buffer;
        public uint64 offset;
        public uint64 bytes_requested;
        public uint64 bytes_transferred;
        public void* userdata;
    } // AsyncIOOutcome

    [CCode (cname = "SDL_AsyncIOResult", cprefix = "SDL_ASYNCIO_", has_type_id = false)]
    public enum AsyncIOResult {
        COMPLETE,
        FAILURE,
        CANCELED,
    } // AsyncIOResult

    [CCode (cname = "SDL_AsyncIOTaskType", cprefix = "SDL_ASYNCIO_TASK_", has_type_id = false)]
    public enum AsyncIOTaskType {
        READ,
        WRITE,
        CLOSE,
    } // AsyncIOTaskType
} // SDL.AsyncIO

///
/// PLATFORM AND CPU INFORMATION
///

///
/// Platform Detection (SDL_platform.h)
///
/* There are defines that only exists if enabled in SDL
 * What you need to do is aks for them in Vala code, nothing more
    [CCode (cheader_filename = "SDL3/SDL_platform.h")]
    namespace SDL.Platform {
    // SDL_PLATFORM_3DS
    // SDL_PLATFORM_AIX
    // SDL_PLATFORM_ANDROID
    // SDL_PLATFORM_APPLE
    // SDL_PLATFORM_BSDI
    // SDL_PLATFORM_CYGWIN
    // SDL_PLATFORM_EMSCRIPTEN
    // SDL_PLATFORM_FREEBSD
    // SDL_PLATFORM_GDK
    // SDL_PLATFORM_HAIKU
    // SDL_PLATFORM_HPUX
    // SDL_PLATFORM_IOS
    // SDL_PLATFORM_IRIX
    // SDL_PLATFORM_LINUX
    // SDL_PLATFORM_MACOS
    // SDL_PLATFORM_NETBSD
    // SDL_PLATFORM_OPENBSD
    // SDL_PLATFORM_OS2
    // SDL_PLATFORM_OSF
    // SDL_PLATFORM_PS2
    // SDL_PLATFORM_PSP
    // SDL_PLATFORM_QNXNTO
    // SDL_PLATFORM_RISCOS
    // SDL_PLATFORM_SOLARIS
    // SDL_PLATFORM_TVOS
    // SDL_PLATFORM_UNIX
    // SDL_PLATFORM_VISIONOS
    // SDL_PLATFORM_VITA
    // SDL_PLATFORM_WIN32
    // SDL_PLATFORM_WINDOWS
    // SDL_PLATFORM_WINGDK
    // SDL_PLATFORM_XBOXONE
    // SDL_PLATFORM_XBOXSERIES
    // SDL_WINAPI_FAMILY_PHONE
    } // SDL.Platform */

///
/// CPU Feature Detection (SDL_cpuinfo.h)
///
[CCode (cheader_filename = "SDL3/SDL_cpuinfo.h")]
namespace SDL.CpuInfo {
    [CCode (cname = "SDL_GetCPUCacheLineSize")]
    public static int get_cpu_cache_line_size ();

    [CCode (cname = "SDL_GetNumLogicalCPUCores")]
    public static int get_num_logical_cpu_cores ();

    [CCode (cname = "SDL_GetSIMDAlignment")]
    public static size_t get_simd_alignment ();

    [CCode (cname = "SDL_GetSystemRAM")]
    public static int get_system_ram ();

    [CCode (cname = "SDL_HasAltiVec")]
    public static bool has_alti_vec ();

    [CCode (cname = "SDL_HasARMSIMD")]
    public static bool has_arm_simd ();

    [CCode (cname = "SDL_HasAVX")]
    public static bool has_avx ();

    [CCode (cname = "SDL_HasAVX2")]
    public static bool has_avx2 ();

    [CCode (cname = "SDL_HasAVX512F")]
    public static bool has_avx_512f ();

    [CCode (cname = "SDL_HasLASX")]
    public static bool has_lasx ();

    [CCode (cname = "SDL_HasLSX")]
    public static bool has_lsx ();

    [CCode (cname = "SDL_HasMMX")]
    public static bool has_mmx ();

    [CCode (cname = "SDL_HasNEON")]
    public static bool has_neon ();

    [CCode (cname = "SDL_HasSSE")]
    public static bool has_sse ();

    [CCode (cname = "SDL_HasSSE2")]
    public static bool has_sse2 ();

    [CCode (cname = "SDL_HasSSE3")]
    public static bool has_sse3 ();

    [CCode (cname = "SDL_HasSSE41")]
    public static bool has_sse41 ();

    [CCode (cname = "SDL_HasSSE42")]
    public static bool has_sse42 ();

    [CCode (cname = "SDL_CACHELINE_SIZE")]
    public const int CACHELINE_SIZE;
} // SDL.CpuInfo

///
/// Compiler Intrinsics Detection (SDL_intrin.h)
///
/* There are defines that only exists if enabled in SDL
 * What you need to do is aks for them in Vala code, nothing more
    [CCode (cheader_filename = "SDL3/SDL_intrin.h")]
    namespace SDL.Intrinsics {
        // SDL_ALTIVEC_INTRINSICS
        // SDL_AVX2_INTRINSICS
        // SDL_AVX512F_INTRINSICS
        // SDL_AVX_INTRINSICS
        // SDL_LASX_INTRINSICS
        // SDL_LSX_INTRINSICS
        // SDL_MMX_INTRINSICS
        // SDL_NEON_INTRINSICS
        // SDL_SSE2_INTRINSICS
        // SDL_SSE3_INTRINSICS
        // SDL_SSE4_1_INTRINSICS
        // SDL_SSE4_2_INTRINSICS
        // SDL_SSE_INTRINSICS

        // This is a very specific GCC thing that might not make sens ein Vala
        // SDL_TARGETING
    }*/

///
/// Byte Order and Byte Swapping (SDL_endian.h)
///
[CCode (cheader_filename = "SDL3/SDL_endian.h")]
namespace SDL.Endian {
    [CCode (cname = "SDL_Swap16")]
    public static uint16 swap_16 (uint16 x);

    [CCode (cname = "SDL_Swap32")]
    public static uint32 swap_32 (uint32 x);

    [CCode (cname = "SDL_Swap64")]
    public static uint64 swap_64 (uint64 x);

    [CCode (cname = "SDL_SwapFloat")]
    public static float swap_float (float x);

    [CCode (cname = "SDL_BIG_ENDIAN")]
    public const int BIG_ENDIAN;

    [CCode (cname = "SDL_BYTEORDER")]
    public const int BYTEORDER;

    [CCode (cname = "SDL_FLOATWORDORDER")]
    public const int FLOATWORDORDER;

    [CCode (cname = "SDL_LIL_ENDIAN")]
    public const int LIL_ENDIAN;

    [CCode (cname = "SDL_Swap16BE")]
    public static uint16 swap_16_be (uint16 x);

    [CCode (cname = "SDL_Swap16LE")]
    public static uint16 swap_16_le (uint16 x);

    [CCode (cname = "SDL_Swap32BE")]
    public static uint32 swap_32_be (uint32 x);

    [CCode (cname = "SDL_Swap32LE")]
    public static uint32 swap_32_le (uint32 x);

    [CCode (cname = "SDL_Swap64BE")]
    public static uint64 swap_64_be (uint64 x);

    [CCode (cname = "SDL_Swap64LE")]
    public static uint64 swap_64_le (uint64 x);

    [CCode (cname = "SDL_SwapFloatBE")]
    public static float swap_float_be (float x);

    [CCode (cname = "SDL_SwapFloatLE")]
    public static float swap_float_le (float x);
} // SDL.Endian

///
/// Bit Manipulation (SDL_bits.h)
///
[CCode (cheader_filename = "SDL3/SDL_bits.h")]
namespace SDL.Bits {
    [CCode (cname = "SDL_HasExactlyOneBitSet32")]
    public static bool has_exactly_one_bit_set_32 (uint32 x);

    [CCode (cname = "SDL_MostSignificantBitIndex32")]
    public static int most_significant_bit_index_32 (uint32 x);
} // SDL.Bits

///
/// ADDITIONAL FUNCTIONALITY
///

///
/// Shared Object/DLL Management (SDL_loadso.h)
///
[CCode (cheader_filename = "SDL3/SDL_loadso.h")]
namespace SDL.LoadSO {
    [CCode (cname = "SDL_LoadFunction")]
    public static StdInc.FunctionPointer load_function (SharedObject handle, string name);

    [CCode (cname = "SDL_LoadObject")]
    public static SharedObject ? load_object (string so_file);

    [CCode (cname = "SDL_UnloadObject")]
    public static void unload_object (SharedObject handle);

    [CCode (cname = "SDL_SharedObject", has_type_id = false)]
    public struct SharedObject {}
} // SDL.LoadSO

///
/// Power Management Status (SDL_power.h)
///
[CCode (cheader_filename = "SDL3/SDL_power.h")]
namespace SDL.Power {
    [CCode (cname = "SDL_GetPowerInfo")]
    public static PowerState get_power_info (out int seconds, out int percent);

    [CCode (cname = "SDL_PowerState", cprefix = "SDL_POWERSTATE_", has_type_id = false)]
    public enum PowerState {
        ERROR,
        UNKNOWN,
        ON_BATTERY,
        NO_BATTERY,
        CHARGING,
        CHARGED,
    } // PowerState
} // SDL.Power

///
/// Process Control (SDL_process.h)
///
[CCode (cheader_filename = "SDL3/SDL_process.h")]
namespace SDL.Process {
    [CCode (cname = "SDL_CreateProcess")]
    public static Process create_process ([CCode (array_length = false)] string[] args, bool pipe_stdio);

    [CCode (cname = "SDL_CreateProcessWithProperties")]
    public static Process create_process_with_properties (Properties.PropertiesID props);

    [CCode (cname = "SDL_DestroyProcess")]
    public static void destroy_process (Process process);

    [CCode (cname = "SDL_GetProcessInput")]
    public static IOStream.IOStream get_process_input (Process process);

    [CCode (cname = "SDL_GetProcessOutput")]
    public static IOStream.IOStream get_process_output (Process process);

    [CCode (cname = "SDL_GetProcessProperties")]
    public static Properties.PropertiesID get_process_properties (Process process);

    [CCode (cname = "SDL_KillProcess")]
    public static bool kill_process (Process process, bool force);

    [CCode (cname = "SDL_ReadProcess")]
    public static void * read_process (Process process, out size_t datasize, out int exitcode);

    [CCode (cname = "SDL_WaitProcess")]
    public static bool wait_process (Process process, bool block, out int exitcode);

    [Compact, CCode (cname = "SDL_Process", free_function = "", has_type_id = false)]
    public class Process {}

    [CCode (cname = "SDL_ProcessIO", cprefix = "SDL_PROCESS_STDIO_", has_type_id = false)]
    public enum ProcessIO {
        INHERITED,
        NULL,
        APP,
        REDIRECT,
    } // ProcessIO

    namespace SDLPropProcessCreate {
        [CCode (cname = "SDL_PROP_PROCESS_CREATE_ARGS_POINTER")]
        public const string ARGS_POINTER;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER")]
        public const string ENVIRONMENT_POINTER;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_STDIN_NUMBER")]
        public const string STDIN_NUMBER;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_STDIN_POINTER")]
        public const string STDIN_POINTER;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER")]
        public const string STDOUT_NUMBER;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_STDOUT_POINTER")]
        public const string STDOUT_POINTER;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_STDERR_NUMBER")]
        public const string STDERR_NUMBER;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_STDERR_POINTER")]
        public const string STDERR_POINTER;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN")]
        public const string STDERR_TO_STDOUT_BOOLEAN;

        [CCode (cname = "SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN")]
        public const string BACKGROUND_BOOLEAN;
    } // SDLPropProcessCreate

    namespace SDLPropProcess {
        [CCode (cname = "SDL_PROP_PROCESS_PID_NUMBER")]
        public const string PID_NUMBER;

        [CCode (cname = "SDL_PROP_PROCESS_STDIN_POINTER")]
        public const string STDIN_POINTER;

        [CCode (cname = "SDL_PROP_PROCESS_STDOUT_POINTER")]
        public const string STDOUT_POINTER;

        [CCode (cname = "SDL_PROP_PROCESS_STDERR_POINTER")]
        public const string STDERR_POINTER;

        [CCode (cname = "SDL_PROP_PROCESS_BACKGROUND_BOOLEAN")]
        public const string BACKGROUND_BOOLEAN;
    } // SDLPropProcess
} // SDL.Process

///
/// Message Boxes (SDL_messagebox.h)
///
[CCode (cheader_filename = "SDL3/SDL_messagebox.h")]
namespace SDL.MessageBox {
    [CCode (cname = "SDL_ShowMessageBox")]
    public static bool show_message_box (MessageBoxData messageboxdata, out int buttonid);

    [CCode (cname = "SDL_ShowSimpleMessageBox")]
    public static bool show_simple_message_box (MessageBoxFlags flags,
        string title,
        string message,
        Video.Window window);

    [Flags, CCode (cname = "uint32", cprefix = "SDL_MESSAGEBOX_BUTTON_", has_type_id = false)]
    public enum MessageBoxButtonFlags {
        RETURNKEY_DEFAULT,
        ESCAPEKEY_DEFAULT,
    } // MessageBoxButtonFlags

    [Flags, CCode (cname = "uint32", cprefix = "SDL_MESSAGEBOX_", has_type_id = false)]
    public enum MessageBoxFlags {
        ERROR,
        WARNING,
        INFORMATION,
        BUTTONS_LEFT_TO_RIGHT,
        BUTTONS_RIGHT_TO_LEFT,
    } // MessageBoxFlags

    [CCode (cname = "SDL_MessageBoxButtonData", has_type_id = false)]
    public struct MessageBoxButtonData {
        public MessageBoxButtonFlags flags;
        [CCode (cname = "buttonID")]
        public int button_id;
        public string text;
    } // MessageBoxButtonData;

    [CCode (cname = "SDL_MessageBoxColor", has_type_id = false)]
    public struct MessageBoxColor {
        public uint8 r;
        public uint8 g;
        public uint8 b;
    } // MessageBoxColor;

    [CCode (cname = "SDL_MessageBoxColorScheme", has_type_id = false)]
    public struct MessageBoxColorScheme {
        public MessageBoxColor colors[MessageBoxColorType.COLOR_COUNT];
    } // MessageBoxColorScheme;

    [CCode (cname = "SDL_MessageBoxData", has_type_id = false)]
    public struct MessageBoxData {
        public MessageBoxFlags flags;
        public Video.Window* window;
        public string title;
        public string message;
        public int numbuttons;
        public MessageBoxButtonData buttons;
        [CCode (cname = "colorScheme")]
        public MessageBoxColorScheme color_scheme;
    } // MessageBoxData

    [CCode (cname = "SDL_MessageBoxColorType", cprefix = "SDL_MESSAGEBOX_COLOR_", has_type_id = false)]
    public enum MessageBoxColorType {
        COLOR_BACKGROUND,
        COLOR_TEXT,
        COLOR_BUTTON_BORDER,
        COLOR_BUTTON_BACKGROUND,
        COLOR_BUTTON_SELECTED,
        COLOR_COUNT,
    } // MessageBoxColorType

    namespace SDLPropFileDialog {
        [CCode (cname = "SDL_PROP_FILE_DIALOG_FILTERS_POINTER")]
        public const string FILTERS_POINTER;

        [CCode (cname = "SDL_PROP_FILE_DIALOG_NFILTERS_NUMBER")]
        public const string NFILTERS_NUMBER;

        [CCode (cname = "SDL_PROP_FILE_DIALOG_WINDOW_POINTER")]
        public const string WINDOW_POINTER;

        [CCode (cname = "SDL_PROP_FILE_DIALOG_LOCATION_STRING")]
        public const string LOCATION_STRING;

        [CCode (cname = "SDL_PROP_FILE_DIALOG_MANY_BOOLEAN")]
        public const string MANY_BOOLEAN;

        [CCode (cname = "SDL_PROP_FILE_DIALOG_TITLE_STRING")]
        public const string TITLE_STRING;

        [CCode (cname = "SDL_PROP_FILE_DIALOG_ACCEPT_STRING")]
        public const string ACCEPT_STRING;

        [CCode (cname = "SDL_PROP_FILE_DIALOG_CANCEL_STRING")]
        public const string CANCEL_STRING;
    } // SDLPropFileDialog
} // SDL.MessageBox

///
/// File Dialogs (SDL_dialog.h)
///
[CCode (cheader_filename = "SDL3/SDL_dialog.h")]
namespace SDL.Dialog {
    [CCode (cname = "SDL_ShowFileDialogWithProperties", has_target = true)]
    public static void show_file_dialog_with_properties (FileDialogType type,
        DialogFileCallback callback,
        Properties.PropertiesID props);

    [CCode (cname = "SDL_ShowOpenFileDialog")]
    public static void show_open_file_dialog (DialogFileCallback callback,
        Video.Window? window,
        DialogFileFilter[]? filters,
        string default_location,
        bool allow_many);

    [CCode (cname = "SDL_ShowOpenFolderDialog")]
    public static void show_open_folder_dialog (DialogFileCallback callback,
        Video.Window window,
        string default_location,
        bool allow_many);

    [CCode (cname = "SDL_ShowSaveFileDialog")]
    public static void show_save_file_dialog (DialogFileCallback callback,
        Video.Window window,
        DialogFileFilter[]? filters,
        string default_location);

    [CCode (cname = "SDL_DialogFileCallback", has_target = true, instance_pos = 0)]
    public delegate void DialogFileCallback ([CCode (array_null_terminated = true)] string[] filelist,
        int filter);

    [CCode (cname = "SDL_DialogFileFilter", has_type_id = false)]
    public struct DialogFileFilter {
        public string name;
        public string pattern;
    } // DialogFileFilter

    [CCode (cname = "SDL_FileDialogType", cprefix = "SDL_FILEDIALOG_", has_type_id = false)]
    public enum FileDialogType {
        OPENFILE,
        SAVEFILE,
        OPENFOLDER,
    } // FileDialogType
} // SDL.Dialog

///
/// System Tray (SDL_tray.h)
///
[CCode (cheader_filename = "SDL3/SDL_tray.h")]
namespace SDL.Tray {
    [CCode (cname = "SDL_ClickTrayEntry")]
    public static void click_tray_entry (TrayEntry entry);

    [CCode (cname = "SDL_CreateTray")]
    public static Tray create_tray (Surface.Surface icon, string tooltip);

    [CCode (cname = "SDL_CreateTrayMenu")]
    public static TrayMenu create_tray_menu (Tray tray);

    [CCode (cname = "SDL_CreateTraySubmenu")]
    public static TrayMenu create_tray_submenu (TrayEntry entry);

    [CCode (cname = "SDL_DestroyTray")]
    public static void destroy_tray (Tray tray);

    [CCode (cname = "SDL_GetTrayEntries")]
    public static TrayEntry[] get_tray_entries (TrayMenu menu);

    [CCode (cname = "SDL_GetTrayEntryChecked")]
    public static bool get_tray_entry_checked (TrayEntry entry);

    [CCode (cname = "SDL_GetTrayEntryEnabled")]
    public static bool get_tray_entry_enabled (TrayEntry entry);

    [CCode (cname = "SDL_GetTrayEntryLabel")]
    public static unowned string get_tray_entry_label (TrayEntry entry);

    [CCode (cname = "SDL_GetTrayEntryParent")]
    public static TrayMenu * get_tray_entry_parent (TrayEntry entry);

    [CCode (cname = "SDL_GetTrayMenu")]
    public static TrayMenu get_tray_menu (Tray tray);

    [CCode (cname = "SDL_GetTrayMenuParentEntry")]
    public static TrayEntry get_tray_menu_parent_entry (TrayMenu menu);

    [CCode (cname = "SDL_GetTrayMenuParentTray")]
    public static Tray get_tray_menu_parent_tray (TrayMenu menu);

    [CCode (cname = "SDL_GetTraySubmenu")]
    public static TrayMenu get_tray_submenu (TrayEntry entry);

    [CCode (cname = "SDL_InsertTrayEntryAt")]
    public static TrayEntry insert_tray_entry_at (TrayMenu menu, int pos, string label, TrayEntryFlags flags);

    [CCode (cname = "SDL_RemoveTrayEntry")]
    public static void remove_tray_entry (TrayEntry entry);

    [CCode (cname = "SDL_SetTrayEntryCallback", has_target = true)]
    public static void set_tray_entry_callback (TrayEntry entry, TrayCallback callback);

    [CCode (cname = "SDL_SetTrayEntryChecked")]
    public static void set_tray_entry_checked (TrayEntry entry, bool checked);

    [CCode (cname = "SDL_SetTrayEntryEnabled")]
    public static void set_tray_entry_enabled (TrayEntry entry, bool enabled);

    [CCode (cname = "SDL_SetTrayEntryLabel")]
    public static void set_entry_label (TrayEntry entry, string label);

    [CCode (cname = "SDL_SetTrayIcon")]
    public static void set_tray_icon (Tray tray, Surface.Surface icon);

    [CCode (cname = "SDL_SetTrayTooltip")]
    public static void set_tray_tooltip (Tray tray, string tooltip);

    [CCode (cname = "SDL_UpdateTrays")]
    public static void update_trays ();

    [Compact, CCode (cname = "SDL_Tray", free_function = "", has_type_id = false)]
    public class Tray {}

    [CCode (cname = "SDL_TrayCallback", has_target = true, instance_pos = 0)]
    public delegate void TrayCallback (TrayEntry entry);

    [CCode (cname = "SDL_TrayEntry", has_type_id = false)]
    public struct TrayEntry {}

    [Flags, CCode (cname = "uint32", cprefix = "SDL_TRAYENTRY_", has_type_id = false)]
    public enum TrayEntryFlags {
        BUTTON,
        CHECKBOX,
        SUBMENU,
        DISABLED,
        CHECKED,
    } // SDL_TrayEntryFlags;

    [CCode (cname = "SDL_TrayMenu", has_type_id = false)]
    public struct TrayMenu {}
} // SDL.Tray

///
/// Locale Info (SDL_locale.h)
///
[CCode (cheader_filename = "SDL3/SDL_locale.h")]
namespace SDL.Locale {
    [CCode (cname = "SDL_GetPreferredLocales")]
    public static Locale[] get_preferred_locales ();

    [CCode (cname = "SDL_Locale", has_type_id = false)]
    public struct Locale {
        public string language;
        public string? country;
    } // Locale
} // SDL.Locale

///
/// Platform-specific Functionality (SDL_system.h)
///
[CCode (cheader_filename = "SDL3/SDL_system.h")]
namespace SDL.System {
    [CCode (cname = "SDL_GetAndroidActivity")]
    public static void * get_android_activity ();

    [CCode (cname = "SDL_GetAndroidCachePath")]
    public static unowned string get_android_cache_path ();

    [CCode (cname = "SDL_GetAndroidExternalStoragePath")]
    public static unowned string get_android_external_storage_path ();

    [CCode (cname = "SDL_GetAndroidInternalStoragePath")]
    public static uint32 get_android_external_storage_state ();

    [CCode (cname = "SDL_GetAndroidExternalStorageState")]
    public static unowned string get_android_internal_storage_path ();

    [CCode (cname = "SDL_GetAndroidJNIEnv")]
    public static void * get_android_jni_env ();

    [CCode (cname = "SDL_GetAndroidSDKVersion")]
    public static int get_android_sdk_version ();

    [CCode (cname = "SDL_GetDirect3D9AdapterIndex")]
    public static int get_direct3d9_adapter_index (Video.DisplayID display_id);

    [CCode (cname = "SDL_GetDXGIOutputInfo")]
    public static bool get_dxgi_output_info (Video.DisplayID display_id, out int adapter_index, out int output_index);

    [CCode (cname = "SDL_GetGDKDefaultUser")]
    public static bool get_gdk_default_user (out XUserHandle out_user_handle);

    [CCode (cname = "XUserHandle", has_type_id = false)]
    public struct XUserHandle {}

    [CCode (cname = "SDL_GetSandbox")]
    public static Sandbox get_sandbox ();

    [CCode (cname = "SDL_IsChromebook")]
    public static bool is_chromebook ();

    [CCode (cname = "SDL_IsDeXMode")]
    public static bool is_dex_mode ();

    [CCode (cname = "SDL_IsTablet")]
    public static bool is_tablet ();

    [CCode (cname = "SDL_IsTV")]
    public static bool is_tv ();

    [CCode (cname = "SDL_RequestAndroidPermission", has_target = true)]
    public static bool request_android_permission (string permission, RequestAndroidPermissionCallback cb);

    [CCode (cname = "SDL_SendAndroidBackButton")]
    public static void send_android_back_button ();

    [CCode (cname = "SDL_SetiOSAnimationCallback", has_target = true)]
    public static bool set_ios_animation_callback (Video.Window window, int interval, IOSAnimationCallback callback);

    [CCode (cname = "SDL_SetLinuxThreadPriority")]
    public static bool set_linux_thread_priotiyy (int64 thread_id, int priority);

    [CCode (cname = "SDL_SetLinuxThreadPriorityAndPolicy")]
    public static bool set_linux_thread_priority_and_policy (int64 thread_id, int sdl_priority, int sched_policy);

    [CCode (cname = "SDL_ShowAndroidToast")]
    public static bool show_android_toast (string message, int duration, int gravity, int x_offset, int y_offset);

    [CCode (cname = "SDL_iOSAnimationCallback", has_target = true)]
    public delegate void IOSAnimationCallback ();

    [CCode (cname = "SDL_RequestAndroidPermissionCallback", has_target = true, instance_pos = 0)]
    public delegate void RequestAndroidPermissionCallback (string permission, bool granted);

    [CCode (cname = "SDL_WindowsMessageHook", has_target = true, instance_pos = 0)]
    public delegate void WindowsMessageHook (Msg msg);

    [CCode (cname = "SDL_SetWindowsMessageHook", has_target = true)]
    public static void set_windows_message_hook (WindowsMessageHook callback);

    [CCode (cname = "MSG", has_type_id = false)]
    public struct Msg {}

    [CCode (cname = "SDL_X11EventHook", has_target = true, instance_pos = 0)]
    public delegate void X11EventHook (XEvent x_event);

    [CCode (cname = "SDL_SetX11EventHook", has_target = true)]
    public static void set_x11_event_hook (X11EventHook callback);

    [CCode (cname = "XEvent", has_type_id = false)]
    public struct XEvent {}

    [CCode (cname = "SDL_Sandbox", cprefix = "SDL_SANDBOX_", has_type_id = false)]
    public enum Sandbox {
        NONE,
        UNKNOWN_CONTAINER,
        FLATPAK,
        SNAP,
        MACOS,
    } // SDL_Sandbox

    [CCode (cname = "SDL_ANDROID_EXTERNAL_STORAGE_READ")]
    public const uint8 ANDROID_EXTERNAL_STORAGE_READ;

    [CCode (cname = "SDL_ANDROID_EXTERNAL_STORAGE_WRITE")]
    public const uint8 ANDROID_EXTERNAL_STORAGE_WRITE;
} // SDL.System

///
/// Standard Library Functionality (SDL_stdinc.h)
///
[CCode (cheader_filename = "SDL3/SDL_stdinc.h")]
namespace SDL.StdInc {
    [CCode (cname = "SDL_abs")]
    public static int abs (int x);

    [CCode (cname = "SDL_acos")]
    public static double acos (double x);

    [CCode (cname = "SDL_acosf")]
    public static float acosf (float x);

    [CCode (cname = "SDL_aligned_alloc")]
    public static void * aligned_alloc (size_t alignment, size_t size);

    [CCode (cname = "SDL_aligned_free")]
    public static void aligned_free (void* mem);

    [CCode (cname = "SDL_asin")]
    public static double asin (double x);

    [CCode (cname = "SDL_asinf")]
    public static float asinf (float x);

    [CCode (cname = "SDL_asprintf")]
    public static int asprintf (out string strp, string fmt, ...);

    [CCode (cname = "SDL_atan")]
    public static double atan (double x);

    [CCode (cname = "SDL_atan2")]
    public static double atan2 (double y, double x);

    [CCode (cname = "SDL_atan2f")]
    public static float atan2f (float y, float x);

    [CCode (cname = "SDL_atanf")]
    public static float atanf (float x);

    [CCode (cname = "SDL_atof")]
    public static double atof (string str);

    [CCode (cname = "SDL_atoi")]
    public static int atoi (string str);

    [CCode (cname = "SDL_bsearch")]
    public static void * bsearch (void* key, void* base, size_t nmemb, size_t size, CompareCallback compare);

    [CCode (cname = "SDL_bsearch_r", has_target = true)]
    public static void * bsearch_r (void* key, void* base, size_t nmemb, size_t size, CompareCallbackR compare);

    [CCode (cname = "SDL_calloc")]
    public static void * calloc (size_t nmemb, size_t size);

    [CCode (cname = "SDL_ceil")]
    public static double ceil (double x);

    [CCode (cname = "SDL_ceil")]
    public static float ceilf (float x);

    [CCode (cname = "SDL_copysign")]
    public static double copysign (double x, double y);

    [CCode (cname = "SDL_copysignf")]
    public static float copysignf (float x, float y);

    [CCode (cname = "SDL_cos")]
    public static double cos (double x);

    [CCode (cname = "SDL_cosf")]
    public static float cosf (float x);

    [CCode (cname = "SDL_crc16")]
    public static uint16 crc16 (uint16 crc, void* data, size_t len);

    [CCode (cname = "SDL_crc32")]
    public static uint32 crc32 (uint32 crc, void* data, size_t len);

    [CCode (cname = "SDL_CreateEnvironment")]
    public static SDLEnvironment create_environment (bool populated);

    [CCode (cname = "SDL_DestroyEnvironment")]
    public static void destroy_environment (SDLEnvironment env);

    [CCode (cname = "SDL_exp")]
    public static double exp (double x);

    [CCode (cname = "SDL_expf")]
    public static float expf (float x);

    [CCode (cname = "SDL_fabs")]
    public static double fabs (double x);

    [CCode (cname = "SDL_fabsf")]
    public static float fabsf (float x);

    [CCode (cname = "SDL_floor")]
    public static double floor (double x);

    [CCode (cname = "SDL_floorf")]
    public static float floorf (float x);

    [CCode (cname = "SDL_fmod")]
    public static double fmod (double x, double y);

    [CCode (cname = "SDL_fmodf")]
    public static float fmodf (float x, float y);

    [CCode (cname = "SDL_free")]
    public static void free (void* mem);

    [CCode (cname = "SDL_getenv")]
    public static unowned string getenv (string name);

    [CCode (cname = "SDL_getenv_unsafe")]
    public static unowned string getenv_unsafe (string name);

    [CCode (cname = "SDL_GetEnvironment")]
    public static SDLEnvironment get_environment ();

    [CCode (cname = "SDL_GetEnvironmentVariable")]
    public static unowned string get_environment_variable (SDLEnvironment env, string name);

    [CCode (cname = "SDL_GetEnvironmentVariables")]
    public static unowned string[] ? get_environment_variables (SDLEnvironment env);

    [CCode (cname = "SDL_GetMemoryFunctions")]
    public static void get_memory_functions (MallocFunc malloc_func,
        CallocFunc calloc_func,
        ReallocFunc realloc_func,
        FreeFunc free_func);

    [CCode (cname = "SDL_GetNumAllocations")]
    public static int get_num_allocations ();

    [CCode (cname = "SDL_GetOriginalMemoryFunctions")]
    public static void get_original_memory_functions (MallocFunc malloc_func,
        CallocFunc calloc_func,
        ReallocFunc realloc_func,
        FreeFunc free_func);

    [CCode (cname = "SDL_iconv")]
    public static size_t iconv (Iconv cd,
        string inbuf,
        size_t inbytesleft,
        out string outbuf,
        out size_t outbytesleft);

    [CCode (cname = "int", cprefix = "SDL_ICONV_", has_type_id = false)]
    public enum IconvError {
        ERROR,
        E2BIG,
        EILSEQ,
        EINVAL,
    } // IconvError

    [CCode (cname = "SDL_iconv_close")]
    public static int iconv_close (Iconv cd);

    [CCode (cname = "SDL_iconv_open")]
    public static Iconv iconv_open (string tocode, string fromcode);

    [CCode (cname = "SDL_iconv_string")]
    public static unowned string iconv_string (string tocode,
        string fromcode,
        string inbuf,
        size_t inbytesleft);

    [CCode (cname = "SDL_isalnum")]
    public static int is_a_lnum (int x);

    [CCode (cname = "SDL_isalpha")]
    public static int is_alpha (int x);

    [CCode (cname = "SDL_isblank")]
    public static int is_blank (int x);

    [CCode (cname = "SDL_iscntrl")]
    public static int is_cntrl (int x);

    [CCode (cname = "SDL_isdigit")]
    public static int is_digit (int x);

    [CCode (cname = "SDL_isgraph")]
    public static int is_graph (int x);

    [CCode (cname = "SDL_isinf")]
    public static int is_inf (double x);

    [CCode (cname = "SDL_isinff")]
    public static int is_inff (float x);

    [CCode (cname = "SDL_islower")]
    public static int is_lower (int x);

    [CCode (cname = "SDL_isnan")]
    public static int is_nan (double x);

    [CCode (cname = "SDL_isnanf")]
    public static int is_nanf (float x);

    [CCode (cname = "SDL_isprint")]
    public static int is_print (int x);

    [CCode (cname = "SDL_ispunct")]
    public static int is_punct (int x);

    [CCode (cname = "SDL_isspace")]
    public static int is_space (int x);

    [CCode (cname = "SDL_isupper")]
    public static int is_upper (int x);

    [CCode (cname = "SDL_isxdigit")]
    public static int is_x_digit (int x);

    [CCode (cname = "SDL_itoa")]
    public static unowned string itoa (int value, ref string str, int radix);

    [CCode (cname = "SDL_lltoa")]
    public static unowned string lltoa (long value, string str, int radix);

    [CCode (cname = "SDL_log")]
    public static double log (double x);

    [CCode (cname = "SDL_log10")]
    public static double log10 (double x);

    [CCode (cname = "SDL_log10f")]
    public static float log10f (float x);

    [CCode (cname = "SDL_logf")]
    public static float logf (double x);

    [CCode (cname = "SDL_lround")]
    public static long lround (double x);

    [CCode (cname = "SDL_lroundf")]
    public static long lroundf (float x);

    [CCode (cname = "SDL_ltoa")]
    public static unowned string ltoa (long value, string str, int radix);

    [CCode (cname = "SDL_malloc")]
    public static void * malloc (size_t size);

    [CCode (cname = "SDL_memcmp")]
    public static int memcpm (void* s1, void* s2, size_t len);

    [CCode (cname = "SDL_memcpy")]
    public static void * memcpy (void* dst, void* src, size_t len);

    [CCode (cname = "SDL_memmove")]
    public static void * memmove (void* dst, void* src, size_t len);

    [CCode (cname = "SDL_memset")]
    public static void * memset (void* dst, int c, size_t len);

    [CCode (cname = "SDL_memset4")]
    public static void * memset4 (void* dst, uint32 val, size_t dwords);

    [CCode (cname = "SDL_modf")]
    public static float modf (double x, out double y);

    [CCode (cname = "SDL_modff")]
    public static float modff (float x, out float y);

    [CCode (cname = "SDL_murmur3_32")]
    public static uint32 murmur3_32 (void* data, size_t len, uint32 seed);

    [CCode (cname = "SDL_pow")]
    public static double pow (double x, double y);

    [CCode (cname = "SDL_powf")]
    public static float powf (float x, float y);

    [CCode (cname = "SDL_qsort")]
    public static void qsort (void* array_base, size_t nmemb, size_t size, CompareCallback compare);

    [CCode (cname = "SDL_qsort_r", has_target = true)]
    public static void qsort_r (void* array_base, size_t nmemb, size_t size, CompareCallbackR compare);

    [CCode (cname = "SDL_rand")]
    public static int32 rand (int32 n);

    [CCode (cname = "SDL_rand_bits")]
    public static uint32 rand_bits ();

    [CCode (cname = "SDL_rand_bits_r")]
    public static uint32 rand_bits_r (uint64 state);

    [CCode (cname = "SDL_rand_r")]
    public static int32 rand_r (uint64 state, int32 n);

    [CCode (cname = "SDL_randf")]
    public static float randf ();

    [CCode (cname = "SDL_randf_r")]
    public static float randf_r (uint64 state);

    [CCode (cname = "SDL_realloc")]
    public static void * realloc (void* mem, size_t size);

    [CCode (cname = "SDL_round")]
    public static double round (double x);

    [CCode (cname = "SDL_roundf")]
    public static float roundf (float x);

    [CCode (cname = "SDL_scalbn")]
    public static double scalbn (double x, int n);

    [CCode (cname = "SDL_scalbnf")]
    public static float scalbnf (float x, int n);

    [CCode (cname = "SDL_setenv_unsafe")]
    public static int setenv_unsafe (string name, string value, int overwrite);

    [CCode (cname = "SDL_SetEnvironmentVariable")]
    public static bool set_environment_variable (SDLEnvironment env, string name, string value, bool overwrite);

    [CCode (cname = "SDL_SetMemoryFunctions")]
    public static bool det_memoery_functions (MallocFunc malloc_func,
        CallocFunc calloc_func,
        ReallocFunc realloc_func,
        FreeFunc free_func);

    [CCode (cname = "SDL_sin")]
    public static double sin (double x);

    [CCode (cname = "SDL_sinf")]
    public static float sinf (float x);

    [CCode (cname = "SDL_size_add_check_overflow")]
    public static bool size_add_check_overflow (size_t a, size_t b, out size_t ret);

    [CCode (cname = "SDL_size_mul_check_overflow")]
    public static bool size_mul_check_overflow (size_t a, size_t b, out size_t ret);

    [CCode (cname = "SDL_snprintf")]
    public static int snprintf (string text, size_t maxlen, string fmt, ...);

    [CCode (cname = "SDL_sqrt")]
    public static double sqrt (double x);

    [CCode (cname = "SDL_sqrtf")]
    public static float sqrtf (float x);

    [CCode (cname = "SDL_srand")]
    public static void srand (uint64 seed);

    [CCode (cname = "SDL_sscanf")]
    public static int sscanf (string text, string fmt, ...);

    [CCode (cname = "SDL_StepBackUTF8")]
    public static uint32 step_back_utf8 (string start, ref string pstr);

    [CCode (cname = "SDL_StepUTF8")]
    public static uint32 step_utf8 (ref string pstr, size_t pslen);

    [CCode (cname = "SDL_strcasecmp")]
    public static int str_case_cmp (string str1, string str2);

    [CCode (cname = "SDL_strcasestr")]
    public static char ? str_case_str (string haystack, string needle);

    [CCode (cname = "SDL_strchr")]
    public static char ? str_chr (string str, int c);

    [CCode (cname = "SDL_strcmp")]
    public static int str_cmp (string str1, string str2);

    [CCode (cname = "SDL_strdup")]
    public static unowned string str_dup (string str);

    [CCode (cname = "SDL_strlcat")]
    public static size_t str_lcat (ref string dst, string src, size_t maxlen);

    [CCode (cname = "SDL_strlcpy")]
    public static size_t str_lcpy (ref string dst, string src, size_t maxlen);

    [CCode (cname = "SDL_strlen")]
    public static size_t str_len (string str);

    [CCode (cname = "SDL_strlwr")]
    public static unowned string str_lwr (string str);

    [CCode (cname = "SDL_strncasecmp")]
    public static int strn_casecmp (string str1, string str2, size_t maxlen);

    [CCode (cname = "SDL_strncmp")]
    public static int strn_cmp (string str1, string str2, size_t maxlen);

    [CCode (cname = "SDL_strndup")]
    public static unowned string strn_dup (string str, size_t maxlen);

    [CCode (cname = "SDL_strnlen")]
    public static size_t strn_len (string str, size_t maxlen);

    [CCode (cname = "SDL_strnstr")]
    public static char ? strn_str (string haystack, string needle, size_t maxlen);

    [CCode (cname = "SDL_strpbrk")]
    public static char ? str_pbrk (string str, string breakset);

    [CCode (cname = "SDL_strrchr")]
    public static char ? str_rchr (string str, int c);

    [CCode (cname = "SDL_strrev")]
    public static unowned string str_rev (string str);

    [CCode (cname = "SDL_strstr")]
    public static unowned string str_str (string haystack, string needle);

    [CCode (cname = "SDL_strtod")]
    public static double str_tod (string str, out string endp);

    [CCode (cname = "SDL_strtok_r")]
    public static unowned string str_tok_r (string str, string delim, ref string saveptr);

    [CCode (cname = "SDL_strtol")]
    public static long str_tol (string str, ref string? endp, int base);

    [CCode (cname = "SDL_strtoll")]
    public static long str_toll (string str, ref string? endp, int base);

    [CCode (cname = "SDL_strtoul")]
    public static ulong str_toul (string str, ref string? endp, int base);

    [CCode (cname = "SDL_strtoull")]
    public static ulong str_toull (string str, ref string? endp, int base);

    [CCode (cname = "SDL_strupr")]
    public static unowned string str_upr (string str);

    [CCode (cname = "SDL_swprintf")]
    public static int swprintf (string text, size_t maxlen, string fmt, ...);

    [CCode (cname = "SDL_tan")]
    public static double tan (double x);

    [CCode (cname = "SDL_tanf")]
    public static float tanf (float x);

    [CCode (cname = "SDL_tolower")]
    public static char tolower (char x);

    [CCode (cname = "SDL_toupper")]
    public static char toupper (char x);

    [CCode (cname = "SDL_trunc")]
    public static double trunc (double x);

    [CCode (cname = "SDL_truncf")]
    public static float truncf (float x);

    [CCode (cname = "SDL_UCS4ToUTF8")]
    public static unowned string ucs4_to_utf8 (uint32 codepoint, out string dst);

    [CCode (cname = "SDL_uitoa")]
    public static char uitoa (uint value, out char str, int radix);

    [CCode (cname = "SDL_ulltoa")]
    public static char ulltoa (ulong value, out char str, int radix);

    [CCode (cname = "SDL_ultoa")]
    public static char ultoa (ulong value, out char str, int radix);

    [CCode (cname = "SDL_unsetenv_unsafe")]
    public static int unsetenv_unsafe (string name);

    [CCode (cname = "SDL_UnsetEnvironmentVariable")]
    public static bool unset_environment_variable (SDLEnvironment env, string name);

    [CCode (cname = "SDL_utf8strlcpy")]
    public static size_t utf8_str_lcpy (out string dst, string src, size_t dst_bytes);

    [CCode (cname = "SDL_utf8strlen")]
    public static size_t utf8_str_len (string str);

    [CCode (cname = "SDL_utf8strnlen")]
    public static size_t utf8_strn_len (string str, size_t bytes);

    [CCode (cname = "SDL_vasprintf")]
    public static int vasprintf (out string strp, string fmt, va_list ap);

    [CCode (cname = "SDL_vsnprintf")]
    public static int vsnprintf (out string text, size_t maxlen, string fmt, va_list ap);

    [CCode (cname = "SDL_vsscanf")]
    public static int vsscanf (out string text, string fmt, va_list ap);

    [CCode (cname = "SDL_vswprintf")]
    public static int vswprintf (out string text, size_t maxlen, string fmt, va_list ap);

    [CCode (cname = "SDL_wcscasecmp")]
    public static int wcscasecmp (string str1, string str2);

    [CCode (cname = "SDL_wcscmp")]
    public static int wcscmp (string str1, string str2);

    [CCode (cname = "SDL_wcsdup")]
    public static unowned string wcsdup (string wstr);

    [CCode (cname = "SDL_wcslcat")]
    public static size_t wcslcat (out string dst, string src, size_t maxlen);

    [CCode (cname = "SDL_wcslcpy")]
    public static size_t wcslcpy (out string dst, string src, size_t maxlen);

    [CCode (cname = "SDL_wcslen")]
    public static size_t wcslen (string wstr);

    [CCode (cname = "SDL_wcsncasecmp")]
    public static int wcsncasecmp (string str1, string str2, size_t maxlen);

    [CCode (cname = "SDL_wcsncmp")]
    public static int wcsncmp (string str1, string str2, size_t maxlen);

    [CCode (cname = "SDL_wcsnlen")]
    public static size_t wcsnlen (string wstr, size_t maxlen);

    [CCode (cname = "SDL_wcsnstr")]
    public static unowned string wcsnstr (string haystack, string needle, size_t maxlen);

    [CCode (cname = "SDL_wcsstr")]
    public static unowned string wcsstr (string haystack, string needle);

    [CCode (cname = "SDL_wcstol")]
    public static long wcstol (string str, string? endp, int base);

    [CCode (cname = "SDL_calloc_func", has_target = false)]
    public delegate void * CallocFunc (size_t nmemb, size_t size);

    [CCode (cname = "SDL_CompareCallback", has_target = false)]
    public delegate int CompareCallback (void* a, void* b);

    [CCode (cname = "SDL_CompareCallback", has_target = true, instance_pos = 0)]
    public delegate int CompareCallbackR (void* a, void* b);

    [Compact, CCode (cname = "SDL_Environment", free_function = "", has_type_id = false)]
    public class SDLEnvironment {}

    [CCode (cname = "SDL_free_func", has_target = false)]
    public delegate void FreeFunc (void* mem);

    [CCode (cname = "SDL_FunctionPointer", has_target = false)]
    public delegate void FunctionPointer ();

    [CCode (cname = "SDL_iconv_t", has_type_id = false)]
    public struct Iconv {}

    [CCode (cname = "SDL_malloc_func", has_target = false)]
    public delegate void * MallocFunc (size_t size);

    [CCode (cname = "SDL_realloc_func", has_target = false)]
    public delegate void * ReallocFunc (void* mem, size_t size);

    [CCode (cname = "SDL_Time", has_type_id = false)]
    public struct Time {}

    [CCode (cname = "SDL_MAX_TIME")]
    public const int64 MAX_TIME;

    [CCode (cname = "SDL_MIN_TIME")]
    public const int64 MIN_TIME;

    [SimpleType, CCode (cname = "Sint16", has_type_id = false)]
    public struct Sint16 : int16 {}

    [CCode (cname = "SDL_MAX_SINT16")]
    public const int16 MAX_SINT16;

    [CCode (cname = "SDL_MIN_SINT16")]
    public const int16 MIN_SINT16;

    [SimpleType, CCode (cname = "Sint32", has_type_id = false)]
    public struct Sint32 : int32 {}

    [CCode (cname = "SDL_MAX_SINT32")]
    public const int32 MAX_SINT32;

    [CCode (cname = "SDL_MIN_SINT32")]
    public const int32 MIN_SINT32;

    [SimpleType, CCode (cname = "Sint64", has_type_id = false)]
    public struct Sint64 : int64 {}

    [CCode (cname = "SDL_MAX_SINT64")]
    public const int64 MAX_SINT64;

    [CCode (cname = "SDL_MIN_SINT64")]
    public const int64 MIN_SINT64;

    [SimpleType, CCode (cname = "Sint8", has_type_id = false)]
    public struct Sint8 : int8 {}

    [CCode (cname = "SDL_MAX_SINT8")]
    public const int8 MAX_SINT8;

    [CCode (cname = "SDL_MIN_SINT8")]
    public const int8 MIN_SINT8;

    [SimpleType, CCode (cname = "Uint16", has_type_id = false)]
    public struct Uint16 : uint16 {}

    [CCode (cname = "SDL_MAX_UINT16")]
    public const uint16 MAX_UINT16;

    [CCode (cname = "SDL_MIN_UINT16")]
    public const uint16 MIN_UINT16;

    [SimpleType, CCode (cname = "Uint32", has_type_id = false)]
    public struct Uint32 : uint32 {}

    [CCode (cname = "SDL_MAX_UINT32")]
    public const uint32 MAX_UINT32;

    [CCode (cname = "SDL_MIN_UINT32")]
    public const uint32 MIN_UINT32;

    [SimpleType, CCode (cname = "Uint64", has_type_id = false)]
    public struct Uint64 : uint64 {}

    [CCode (cname = "SDL_MAX_UINT64")]
    public const uint64 MAX_UINT64;

    [CCode (cname = "SDL_MIN_UINT64")]
    public const uint64 MIN_UINT64;

    [SimpleType, CCode (cname = "Uint8", has_type_id = false)]
    public struct Uint8 : uint8 {}

    [CCode (cname = "SDL_MAX_UINT8")]
    public const uint8 MAX_UINT8;

    [CCode (cname = "SDL_MIN_UINT8")]
    public const uint8 MIN_UINT8;

    [CCode (cname = "SDL_clamp", simple_generics = true)]
    public static T clamp<T> (T x, T a, T b);

    [CCode (cname = "SDL_FLT_EPSILON")]
    public const float FLT_EPSILON;

    [CCode (cname = "SDL_FOURCC")]
    public static uint32 fourcc (char a, char b, char c, char d);

    [CCode (cname = "SDL_INIT_INTERFACE", simple_generics = true)]
    public static T init_interface<T> (out T iface);

    [CCode (cname = "SDL_iconv_utf8_locale")]
    public static unowned string ? iconv_utf8_locale (string s);

    [CCode (cname = "SDL_iconv_utf8_ucs2")]
    public static unowned string ? iconv_utf8_ucs2 (string s);

    [CCode (cname = "SDL_iconv_utf8_ucs4")]
    public static unowned string ? iconv_utf8_ucs4 (string s);

    [CCode (cname = "SDL_iconv_wchar_utf8")]
    public static unowned string ? iconv_wchar_utf8 (string s);

    [CCode (cname = "SDL_INVALID_UNICODE_CODEPOINT")]
    public const uint32 INVALID_UNICODE_CODEPOINT;

    [CCode (cname = "SDL_max", simple_generics = true)]
    public static T max<T> (T x, T y);

    [CCode (cname = "SDL_min", simple_generics = true)]
    public static T min<T> (T x, T y);

    [CCode (cname = "SDL_PI_D")]
    public const double PI_D;

    [CCode (cname = "SDL_PI_F")]
    public const float PI_F;

    [CCode (cname = "SDL_PRILL_PREFIX")]
    public const string PRILL_PREFIX;

    [CCode (cname = "SDL_PRILLd")]
    public const string PRILLd; // vala-lint=naming-convention

    [CCode (cname = "SDL_PRILLu")]
    public const string PRILLu; // vala-lint=naming-convention

    [CCode (cname = "SDL_PRILLX")]
    public const string PRILLX;

    [CCode (cname = "SDL_PRILLx")]
    public const string PRILLx; // vala-lint=naming-convention

    [CCode (cname = "SDL_PRIs32")]
    public const string PRIs32; // vala-lint=naming-convention

    [CCode (cname = "SDL_PRIs64")]
    public const string PRIs64; // vala-lint=naming-convention

    [CCode (cname = "SDL_PRIu32")]
    public const string PRIu32; // vala-lint=naming-convention

    [CCode (cname = "SDL_PRIu64")]
    public const string PRIu64; // vala-lint=naming-convention

    [CCode (cname = "SDL_PRIX32")]
    public const string PRIX32;

    [CCode (cname = "SDL_PRIx32")]
    public const string PRIx32; // vala-lint=naming-convention

    [CCode (cname = "SDL_PRIX64")]
    public const string PRIX64;

    [CCode (cname = "SDL_PRIx64")]
    public const string PRIx64; // vala-lint=naming-convention

    [CCode (cname = "SDL_SIZE_MAX")]
    public const size_t SIZE_MAX;
} // SDL.StdInc

///
/// GUIDs (SDL_guid.h)
///
[CCode (cheader_filename = "SDL3/SDL_guid.h")]
namespace SDL.Guid {
    [CCode (cname = "SDL_GUIDToString")]
    public static void guid_to_string (Guid guid, [CCode (array_length = false)] out string[] psz_guid, int cb_guid);

    [CCode (cname = "SDL_StringToGUID")]
    public static Guid string_to_guid (string pch_guid);

    [CCode (cname = "SDL_GUID", has_type_id = false)]
    public struct Guid {
        public uint8 data[16];
    } // Guid
} // SDL.Guid

///
/// Miscellaneous (SDL_misc.h)
///
[CCode (cheader_filename = "SDL3/SDL_misc.h")]
namespace SDL.Misc {
    [CCode (cname = "SDL_OpenURL")]
    public static bool open_url (string[] url);
} // SDL.Misc