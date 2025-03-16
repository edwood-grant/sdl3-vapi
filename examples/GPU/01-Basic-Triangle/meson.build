sources += [
    'App.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep]

# Copy correct shaders according to system
shader_prefix = ''
shader_ext = ''
if host_machine.system() == 'linux'
    shader_prefix = 'SPIRV'
    shader_ext = '.spv'
elif host_machine.system() == 'windows'
    shader_prefix = 'DXIL'
    shader_ext = '.dxil'
elif host_machine.system() == 'darwin'
    shader_prefix = 'MSL'
    shader_ext = '.msl'
endif

shader_data_files = [
    join_paths(shader_prefix, 'RawTriangle.vert' + shader_ext),
    join_paths(shader_prefix, 'SolidColor.frag' + shader_ext),
]

# Copy data task
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