sources += [
    'App.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep]

# Copy data task
shader_data_files = [
    'RawTriangle.vert.dxil',
    'SolidColor.frag.dxil',
    'RawTriangle.vert.msl',
    'SolidColor.frag.msl',
    'RawTriangle.vert.spv',
    'SolidColor.frag.spv',
]
data_copy = []

foreach file : shader_data_files
    copy_file = import('fs').copyfile(join_paths(shader_data_dir, file))
    data_copy += copy_file
endforeach

executable(
    'gpu-01-basic-triangle-app',
    sources,
    dependencies: deps,
    install: true,
)