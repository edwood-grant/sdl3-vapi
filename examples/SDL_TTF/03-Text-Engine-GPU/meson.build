sources = [
    'App.vala',
    'ContextGpu.vala',
    'ContextTtf.vala',
    'Data.vala',
    'Math3D.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep, sdl3_ttf_dep]

# Copy data task
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
    join_paths(shader_prefix, 'GPUText.vert' + shader_ext),
    join_paths(shader_prefix, 'GPUText.frag' + shader_ext),
    join_paths(shader_prefix, 'GPUTextSDF.frag' + shader_ext),
]
foreach file : shader_data_files
    copy_file = import('fs').copyfile(join_paths(shader_data_dir, file))
    data_copy += copy_file
endforeach

data_files = ['HomeVideo-Regular.ttf', 'OpenMoji-black-glyf.ttf']
data_copy = []
foreach file : data_files
    copy_file = import('fs').copyfile(join_paths(fonts_data_dir, file))
    data_copy += copy_file
endforeach

executable(
    'sdl-ttf-03-text-engine-gpu-app',
    sources,
    dependencies: deps,
    install: true,
)