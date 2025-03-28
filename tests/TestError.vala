using SDL;

public void test_error_basic () {
    SDL.Error.invalid_param_error ("example_param");
    string error_message = SDL.Error.get_error ();
    assert (error_message == "Parameter 'example_param' is invalid");

    SDL.Error.unsupported ();
    error_message = SDL.Error.get_error ();
    assert (error_message == "That operation is not supported");

    SDL.Error.set_error ("custom %s error: %d", "random", 3);
    error_message = SDL.Error.get_error ();
    assert (error_message == "custom random error: 3");

    SDL.Error.set_error ("custom %s error: %.2f", "random_two", 10.4);
    error_message = SDL.Error.get_error ();
    message (error_message);
    assert (error_message == "custom random_two error: 10.40");
}

public int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/test_error_basic", test_error_basic);
    return Test.run ();
}