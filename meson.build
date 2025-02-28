project(
    'sdl3',
    ['c', 'vala'],
    version: '3.2.4',
    license: 'GPLv3',
    default_options: ['warning_level=2'],
)

vapi_dir = join_paths(meson.project_source_root(), 'vapi')
data_dir = join_paths(meson.project_source_root(), 'examples', 'data')
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

examples_enabled = get_option('examples')
tests_enabled = get_option('tests')
docs_enabled = get_option('docs')

# Examples
if examples_enabled
    subdir('examples')
endif

# Tests
if tests_enabled
    subdir('tests')
endif

# Docs
if docs_enabled
    subdir('docs')
endif