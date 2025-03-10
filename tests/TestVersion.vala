using SDL;


public void test_version_macros () {
    assert (SDL.Version.MAJOR == 3);
    assert (SDL.Version.MINOR == 2);
    assert (SDL.Version.MICRO == 8);
    assert (SDL.Version.VERSION == 3002008);
    assert (SDL.Revision.REVISION == "release-3.2.8-0-gf6864924f");
}

public void test_version_functions () {
    assert (SDL.Version.get_version () == SDL.Version.VERSION);
    assert (SDL.Version.get_revision () == SDL.Revision.REVISION);
}

public void test_version_macro_functions () {
    // Arbitrary version number
    var custom_version = SDL.Version.version_num (2, 3, 8);

    assert (custom_version == 2003008);

    assert (SDL.Version.sdl_version_at_least (2, 3, 2) == true);
    assert (SDL.Version.sdl_version_at_least (3, 9, 9) == false);

    assert (SDL.Version.version_num_major (custom_version) == 2);
    assert (SDL.Version.version_num_minor (custom_version) == 3);
    assert (SDL.Version.version_num_micro (custom_version) == 8);
}

public int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/test_version_macros", test_version_macros);
    Test.add_func ("/test_version_functions", test_version_functions);
    Test.add_func ("/test_version_macro_functions", test_version_macro_functions);
    return Test.run ();
}