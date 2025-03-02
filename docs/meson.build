valadoc = find_program('valadoc', required: false)
if valadoc.found()
    doc_name = meson.project_name()

    # Specify some common flags
    docs_common_valadoc_flags = [
        '--package-name=' + doc_name,
        '--package-version=' + meson.project_version(),
        '--enable-experimental-non-null',
        '--no-protected',
        '--force',
    ]

    docs_common_valadoc_deps = [
        '--pkg', 'glib-2.0',
        '--pkg', 'sdl3',
        '--vapidir', vapi_dir,
    ]

    docsdir = join_paths(get_option('datadir'), 'devhelp', 'books')
    custom_target(
        doc_name + '-valadoc',
        input: vapi_dir + '/sdl3.vapi',
        output: doc_name + '-valadoc',
        command: [
            valadoc,
            '--doclet=html',
            '--directory=@OUTDIR@',
            '--package-name=@0@'.format(doc_name),
            docs_common_valadoc_flags,
            docs_common_valadoc_deps,
            '@INPUT@',
        ],
        install: true,
        install_dir: docsdir,
        build_by_default: true,
    )
endif