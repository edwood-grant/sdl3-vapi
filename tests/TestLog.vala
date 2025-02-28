using SDL3;

int message_count = 0;
unowned SDL3.Log.LogOutputFunction original_output_function;

public void enable_test_log () {
    message_count = 0;
    SDL3.Log.get_log_output_function (original_output_function);
    SDL3.Log.set_log_ouput_function (test_log_output);
}

public void disable_test_log () {
    SDL3.Log.set_log_ouput_function (original_output_function);
}

public void test_log_output () {
    message_count++;
}

public void test_log_hint_null () {
    SDL3.Hints.set_hint (SDL3.Hints.LOGGING, null);

    enable_test_log ();
    SDL3.Log.log_message (SDL3.Log.LogCategory.APPLICATION, SDL3.Log.LogPriority.INFO, "test");
    disable_test_log ();
    assert (message_count == 1);

    enable_test_log ();
    SDL3.Log.log_message (SDL3.Log.LogCategory.APPLICATION, SDL3.Log.LogPriority.DEBUG, "test");
    disable_test_log ();
    assert (message_count == 0);
}

public int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/test_log_hint_null", test_log_hint_null);
    return Test.run ();
}