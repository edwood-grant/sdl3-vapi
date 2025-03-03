using SDL3;


public void test_version_macros () {
    assert (SDL3.Version.MAJOR == 3);
    assert (SDL3.Version.MINOR == 2);
    assert (SDL3.Version.MICRO == 6);
    assert (SDL3.Version.VERSION == 3002006);
    assert (SDL3.Revision.REVISION == "release-3.2.6-0-g65864190c");
}

public void test_version_functions () {
    assert (SDL3.Version.get_version () == SDL3.Version.VERSION);
    assert (SDL3.Version.get_revision () == SDL3.Revision.REVISION);
}

public void test_version_macro_functions () {
    // Arbitrary version number
    var custom_version = SDL3.Version.version_num (2, 3, 8);

    assert (custom_version == 2003008);

    assert (SDL3.Version.sdl_version_at_least (2, 3, 2) == true);
    assert (SDL3.Version.sdl_version_at_least (3, 9, 9) == false);

    assert (SDL3.Version.version_num_major (custom_version) == 2);
    assert (SDL3.Version.version_num_minor (custom_version) == 3);
    assert (SDL3.Version.version_num_micro (custom_version) == 8);
}

public int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/test_version_macros", test_version_macros);
    Test.add_func ("/test_version_functions", test_version_functions);
    Test.add_func ("/test_version_macro_functions", test_version_macro_functions);
    return Test.run ();
}