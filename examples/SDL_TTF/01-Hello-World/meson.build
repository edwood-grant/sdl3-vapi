sources = [
    'App.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep, sdl3_ttf_dep]

# Copy data task
data_files = ['HomeVideo-Regular.ttf', 'OpenMoji-black-glyf.ttf']
data_copy = []
foreach file : data_files
    copy_file = import('fs').copyfile(join_paths(fonts_data_dir, file))
    data_copy += copy_file
endforeach

executable(
    'sdl-ttf-01-hello-world-app',
    sources,
    dependencies: deps,
    install: true,
)