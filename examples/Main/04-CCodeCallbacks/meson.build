sources = [
    'App.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep]

executable(
    'main-04-ccode-callbacks-app',
    sources,
    dependencies: deps,
    c_args: '-DSDL_MAIN_USE_CALLBACKS',
    install: true,
)