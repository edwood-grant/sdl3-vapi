sources = [
    'App.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep]

executable(
    'main-03-main-handled-callbacks-posix-app',
    sources,
    dependencies: deps,
    c_args: '-DSDL_MAIN_HANDLED',
    install: true,
)