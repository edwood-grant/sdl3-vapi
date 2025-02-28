sources = [
    'App.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep]

# Copy data task
data_files = ['sample.bmp']
data_copy = []
foreach file : data_files
    copy_file = import('fs').copyfile(join_paths(data_dir, file))
    data_copy += copy_file
endforeach

executable(
    'renderer-06-textures-app',
    sources,
    dependencies: deps,
    install: true,
    link_depends: data_copy,
)