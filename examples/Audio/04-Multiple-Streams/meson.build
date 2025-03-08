sources = [
    'App.vala',
]

deps = [glib_dep, gobject_dep, sdl3_dep]

# Copy data task
data_files = ['play_now_intro.wav', 'sword04.wav']
data_copy = []
foreach file : data_files
    copy_file = import('fs').copyfile(join_paths(sounds_data_dir, file))
    data_copy += copy_file
endforeach

executable(
    'audio-04-multiple-streams-app',
    sources,
    dependencies: deps,
    install: true,
    link_depends: data_copy,
)