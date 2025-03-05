sources = [
    'App.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep]

executable(
    'main-04-main-handled-callbacks-glib-app',
    sources,
    dependencies: deps,
    vala_args:  ['-D', 'SDL_USE_PTR_ARRAY'],
    c_args: '-DSDL_MAIN_HANDLED',
    install: true,
)