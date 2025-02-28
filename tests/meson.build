glib_dep = dependency('glib-2.0')
gee_dep = dependency('gee-0.8')
gobject_dep = dependency('gobject-2.0')
sdl3_dep = dependency('sdl3')

dependencies = [
    glib_dep,
    gee_dep,
    gobject_dep,
    sdl3_dep,
]

unit_test_files = ['Error', 'Log', 'Properties', 'Version']

foreach name : unit_test_files
    test(
        name,
        executable(
            name,
            'Test' + name + '.vala',
            dependencies: dependencies,
        ),
    )
endforeach
