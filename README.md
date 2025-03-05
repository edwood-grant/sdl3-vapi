SDL3 Vapi bindings for Vala
===========================

These are a set of vapi files for SDL3 for the [Vala
Language](https://www.vala.dev). They are based on the current ABI stable
version of SDL3. 

Currently there are vapis for:

* SDL3
* SDL3 Image

Support for the rest of SDL3 libraries (SDL3_mixer, SDL3_ttf, etc.)
is planned as soon as these APIs go ABI stable.

If you spot any bug, any missing functionality, or any regression, you are more
then welcome to report it and to Issue or submit a pull/merge request. 

Keep in mind that this is still not stable.  Most basic functionality works ok,
but not everything has been tested, especially more advanced functions.

## About SDL3

[Simple DirectMedia Layer](https://libsdl.org) is a cross-platform development
library designed to provide low level access to audio, keyboard, mouse,
joystick, and graphics hardware via OpenGL/Direct3D/Metal/Vulkan.

It is used by video playback software, emulators, and popular games including
Valve's award-winning catalog and many Humble Bundle games. SDL3 officially
supports Windows, macOS, Linux, iOS, and Android, and several other platforms.
SDL3 is written in C.

### What about SDL2?

If you are looking for SDL2, Vala has SDL2 bindings default already via a
[package](https://valadoc.org/sdl2/index.htm).

Suffice to say, here's a warning:

**DO NOT MIX THE SDL2 AND SDL3 vapis.**

Both SDL2 and SDL3 libraries are NOT compatible and use different structures
(the SDL2 vapi is more OOP vala-ified, whereas this vapi is more static function
based). Furthermore, they use the same SDL namespace. So adding the SDL namespace might
generate unwanted collision and odd behaviour.

## How is this vapi written?

This aims to be a 'semi-pure' port of the C headers. This means that currently,
this API is not 'Vala-friendly'. Some basics have been introduced:

1. All syntax is adapted to Vala style syntax. Some macros will change syntax
   because they become functions adapting it to vala.
3. Each header is contained within its own namespace. For example: `SDL_init.h`
   is located in the `SDL.Init` namespace.
       * The only current exceptions are `SDL_keycode.h` and `SDL_scancode.h`, which are located within the
         `SDL.Keyboard` namespace.
2. Whenever possible, some defines lists become enums, most enums have the
   `SDL_` part remoed to make it more compact.
3. Most delegates  (but not all) have their *userdata pointer stored as the self
   instance via `has_target` and `instance_pos` (this might change if it proves
   to be a problem)

Apart from these changes, all the API should be as similar to the C API as
possible. The recommended approach is to eventually create wrappers and
interface around this binding for your project/engine/framework.

There might be plans to actually create a more Vala-friendly implementation of
this vapi as a separate library.

In the vapi itself, the API order goes by the category classification expressed
in the official SDL3 docs [API by
Category](https://wiki.libsdl.org/SDL3/APIByCategory)

## How to use this vapi?

This assumes that you have already installed SDL3 in your machine, or you have
DLL or SO files available for your project. Releases are available
[here](https://github.com/libsdl-org/SDL/releases/). You may also want to
compile SDL3 yourself. Don't forget to get a 3.2.x release.

SDL3 is ABI stable as of now, so any SDL3 release above 3.2.0 should work ok
(save some missing potential APIs.)

To include it in your project, you only need to copy/add the vapi file
(./vapi/sdl3.vapi) in your vapi directories and add the --vapidir and -pgk
command to include it.

Example command line:

`valac --vapidir ./my-vapis-dir/ --pkg sdl3 my_sdl3_program.vala`

Example in Meson:

```
executable(
    'my-sdl3-program',
    'MySDLProgram.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('sdl3'),
    ],
)
```

### SDL3 Image

Similar to SDL3, it assume you have installed it in your system, or gave the DLL/SO files available.

The current SDL# Image verison supported is 3.2.0

The package name is sdl3-image. It has a necessary dependency to sdl3:

Example command line:

`valac --vapidir ./my-vapis-dir/ --pkg sdl3 --pkg sdl3-image my_sdl3_program.vala`

Example in Meson:

```
executable(
    'my-sdl3-program',
    'MySDLProgram.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('sdl3'),
        dependency('sdl3-image'),
    ],
)
```

## Build tests and examples

This repository has multiple examples and tests in their respective folders that
you are more than welcome to check out. If you want to compile them and try them
out, you can do it through meson.

Examples are the same examples as the official SDL3 examples, but adapted to
Vala, plus a few more to show to do different game loops. Tests are pretty slim
right now, but more are planned.

Type the following on the command line in the repository root:

```
meson setup builddir
cd builddir
ninja
```

To run tests, you can execute: ```ninja test```

You can check the built examples in the `./builddir/examples` folder.

## Vala docs

Docs are non-existent right now, but they are planned. The aim is to provide a
simple description of each function with a URL to the official SDL3 docs. The
SDL3 docs are pretty complete and provide good info, so we think it's best to
just keep the reference there.

To build docs, just set the _docs_ meson option in `./meson_options.txt` to
true, and run ninja normally.

The documentation will be generated in the `buidldir/docs` folder

## Are there any specifics about this vapi?

There are some APIs that have better suited replacements in Vala. Since Vala is
GLib dependent, most of the C standard library lies within GLib. SDL3 provides
equivalents that are not technically needed.

Here is the list of APIs that have good alternative on Vala via GLib:

* SDL_log.h: Equivalent found in
  [GLib.Log](https://valadoc.org/glib-2.0/GLib.Log.html):
* SDL_endian.h: Equivalents found within the basic types (int/float, etc.)
  methods provided in the [GLib](https://valadoc.org/glib-2.0/index.htm) main
  namespace 
* SDL_bits.h: Equivalent found in
  [GLib.Bit](https://valadoc.org/glib-2.0/GLib.Bit.html)
* SDL_stdinc.h: Most of the C standard library is provided in
  [GLib](https://valadoc.org/glib-2.0/index.htm)
* SDL_filesystem.h: Equivalents found in
  [GLib.File](https://valadoc.org/gio-2.0/GLib.File.html)
* SDL_loadso.h: Equivalent found in the
  [gmodule-2.0](https://valadoc.org/gmodule-2.0/GLib.Module.html) library, part
  of GLib.

That being said, this vapi nonetheless implements these headers such as it can,
for portability’s sake within other SDL3-baed projects.

If you don't want to use GLib and stay in a POSIX interface. These libraries
provide functional compiler independent implementations of many useful functions
of the C Standard Library.

## Wait, how much of the SDL3 API was implemented?

Even though Some things will not be implemented as part of the binding API.
There can be various reasons, included but not limited to:

* Vala already has it (as is, it already has a Glib equivalent) in such a way
  that is meaningless to implement
    * Note that some things *will* be implemented though as even there are
      equivalents to it, its worthy enough to have their own implementations.
* It's not feasible to implement (certain function calls and macros for example)
* It's not meant to be used by the final user (some defines and callbacks in the
  SDL3 docs explicitly mention this)

This means that, for these reason, not all API calls are implemented. However,
if you find that some signatures are worth including, do not hesitate to submit
an issue or a PR to add to the SDL3 bindings if you think is necessary.

### List of not implemented API calls

The following is a list of what is NOT implemented from each file:

#### SDL_main.h

SDL_main is the new SDL implementation of the main loop via callbacks. This can
be tricky to implemented because of the nature of Vala and the SDL library
expecting specific implementation of functions that cannot be bound to Vala
because they are meant to be defined in C.

The following API signatures have not been implemented because these are
declarations meant to be implemented:

* SDL_AppEvent
* SDL_AppInit
* SDL_AppIterate
* SDL_AppQuit
* SDL_main

The following are meant to be defined in the build system to support the
callbacks system if desired. Thus, no implementation exists:

* SDL_MAIN_HANDLED
* SDL_MAIN_USE_CALLBACKS

#### SDL_error.h

The only API removed is the one related to va_list arguments, are not really
needed for Vala.

The following API signatures have not been implemented:

* SDL_SetErrorV

#### SDL_log.h

Similar to SDL_assert.h this is technically not needed. Vala has sufficient
logging functions and systems better suited for the language. Nevertheless, some
of it has been implemented for portability reasons.

What has not been implemented in essence are the va_list version of the methods
as are considered not necessary for Vala.

The following API signatures have not been implemented:

* SDL_LogMessageV

#### SDL_assert.h

In general, the whole assert.h header is not needed, Vala has a whole assert
system already, Nevertheless some of it is implemented for other SDL elements to
work.

The following API signatures have not been implemented:

* SDL_AssertBreakpoint
* SDL_disabled_assert
* SDL_enabled_assert 
* SDL_FILE
* SDL_FUNCTION
* SDL_LINE
* SDL_NULL_WHILE_LOOP_CONDITION
* SDL_TriggerBreakpoint

The following API signature are defines that can be applied via compilation
flags to check later

* SDL_ASSERT_LEVEL

#### SDL_Mouse.h

The following API signatures have not been implemented:

* SDL_BUTTON_MASK
* SDL_BUTTON_LMASK
* SDL_BUTTON_MMASK
* SDL_BUTTON_RMASK
* SDL_BUTTON_X1MASK
* SDL_BUTTON_X2MASK

#### SDL_audio.h

The following API signatures have not been implemented:

* AUDIO_MASK_BIG_ENDIAN
* SDL_AUDIO_MASK_BITSIZE
* SDL_AUDIO_MASK_FLOAT
* SDL_AUDIO_MASK_SIGNED
* SDL_DEFINE_AUDIO_FORMAT

#### SDL_mutex.h

Vala already has its own threading solution, but this is implemented anyway to
provide portability. Not everything is implemented though. Particularly some
macros around the clang compiler.

The following API signatures have not been implemented:

* SDL_ACQUIRE
* SDL_ACQUIRE_SHARED
* SDL_ACQUIRED_AFTER
* SDL_ACQUIRED_BEFORE
* SDL_ASSERT_CAPABILITY
* SDL_ASSERT_SHARED_CAPABILITY
* SDL_CAPABILITY
* SDL_EXCLUDES
* SDL_GUARDED_BY
* SDL_NO_THREAD_SAFETY_ANALYSIS
* SDL_PT_GUARDED_BY
* SDL_RELEASE
* SDL_RELEASE_GENERIC
* SDL_RELEASE_SHARED
* SDL_REQUIRES
* SDL_REQUIRES_SHARED
* SDL_RETURN_CAPABILITY
* SDL_SCOPED_CAPABILITY
* SDL_THREAD_ANNOTATION_ATTRIBUTE__
* SDL_TRY_ACQUIRE
* SDL_TRY_ACQUIRE_SHARED

#### SDL_iostream.h

The following API signatures have not been implemented:

* SDL_IOvprintf

#### SDL_platform.h

None of the SDL_platform.h header has been implemented. This is because all of
them are just defines that you should ask for their existence with conditional
compilation to make your decisions, nothing more.

The following API signatures are things that you can ask as a conditional
compilation define, but are not implementable in the vapi:

* SDL_PLATFORM_3DS
* SDL_PLATFORM_AIX
* SDL_PLATFORM_ANDROID
* SDL_PLATFORM_APPLE
* SDL_PLATFORM_BSDI
* SDL_PLATFORM_CYGWIN
* SDL_PLATFORM_EMSCRIPTEN
* SDL_PLATFORM_FREEBSD
* SDL_PLATFORM_GDK
* SDL_PLATFORM_HAIKU
* SDL_PLATFORM_HPUX
* SDL_PLATFORM_IOS
* SDL_PLATFORM_IRIX
* SDL_PLATFORM_LINUX
* SDL_PLATFORM_MACOS
* SDL_PLATFORM_NETBSD
* SDL_PLATFORM_OPENBSD
* SDL_PLATFORM_OS2
* SDL_PLATFORM_OSF
* SDL_PLATFORM_PS2
* SDL_PLATFORM_PSP
* SDL_PLATFORM_QNXNTO
* SDL_PLATFORM_RISCOS
* SDL_PLATFORM_SOLARIS
* SDL_PLATFORM_TVOS
* SDL_PLATFORM_UNIX
* SDL_PLATFORM_VISIONOS
* SDL_PLATFORM_VITA
* SDL_PLATFORM_WIN32
* SDL_PLATFORM_WINDOWS
* SDL_PLATFORM_WINGDK
* SDL_PLATFORM_XBOXONE
* SDL_PLATFORM_XBOXSERIES
* SDL_WINAPI_FAMILY_PHONE

#### SDL_intrin.h
 
None of the SDL_intrin.h header has been implemented. This is because all of
them are just defines that you should ask for their existence with conditional
compilation to make your decisions, nothing more.

Its macros are also a very GCC oriented, and not relevant to Vala.

The following API signatures are things that you can ask as a conditional
compilation define, but are not implementable in the vapi:

* SDL_ALTIVEC_INTRINSICS
* SDL_AVX2_INTRINSICS
* SDL_AVX512F_INTRINSICS
* SDL_AVX_INTRINSICS
* SDL_LASX_INTRINSICS
* SDL_LSX_INTRINSICS
* SDL_MMX_INTRINSICS
* SDL_NEON_INTRINSICS
* SDL_SSE2_INTRINSICS
* SDL_SSE3_INTRINSICS
* SDL_SSE4_1_INTRINSICS
* SDL_SSE4_2_INTRINSICS
* SDL_SSE_INTRINSICS

The following API signatures have not been implemented:

* SDL_TARGETING

#### SDL_system.h

The following API signatures have not been implemented:

* SDL_OnApplicationDidChangeStatusBarOrientation
* SDL_OnApplicationDidEnterBackground
* SDL_OnApplicationDidEnterForeground
* SDL_OnApplicationDidReceiveMemoryWarning
* SDL_OnApplicationWillEnterBackground
* SDL_OnApplicationWillEnterForeground
* SDL_OnApplicationWillTerminate

#### SDL_stdinc.h

Similar to SDL_assert.h and SDL_log.h, this is not needed. SDL_stdinc.h is meant
to be a replacement of the C standard library, in case you want to use SDL
without the C STD libraries. Vala already comes with GLib as a dependency, so
most of these functions are moot. Nevertheless, most of it has been implemented
for portability and completeness sake, since the main objective of SDL is to
provide a compiler independent set that works with any compile and even without
the C STD libraries, we think it's worth implementing it.

Some of it makes no sense in Vala however, so not absolutely everything has been
implemented.

The following API signatures have not been implemented:

* SDL_arraysize
* SDL_const_cast
* SDL_COMPILE_TIME_ASSERT
* SDL_copyp
* SDL_IN_BYTECAP
* SDL_INOUT_Z_CAP
* SDL_OUT_BYTECAP
* SDL_OUT_CAP
* SDL_OUT_Z_BYTECAP
* SDL_OUT_Z_CAP
* SDL_PRINTF_FORMAT_STRING
* SDL_PRINTF_VARARG_FUNC
* SDL_PRINTF_VARARG_FUNCV
* SDL_reinterpret_cast
* SDL_SCANF_FORMAT_STRING
* SDL_SCANF_VARARG_FUNC
* SDL_SCANF_VARARG_FUNCV
* SDL_SINT64_C
* SDL_stack_alloc
* SDL_static_cast
* SDL_STRINGIFY_ARG
* SDL_UINT64_C
* SDL_WPRINTF_VARARG_FUNC
* SDL_WPRINTF_VARARG_FUNCV
* SDL_zero
* SDL_zeroa
* SDL_zerop

The following API signatures are things that you can ask as a conditional
compilation define, but are not implementable in the vapi:

* SDL_NOLONGLONG
