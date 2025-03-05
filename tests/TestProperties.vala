using SDL;

SDL.Properties.PropertiesID props;
uint properties_count = 0;
uint8[] array_pointer_sample;
bool cleanup_function_called = false;

public void test_create_properties () {
    props = SDL.Properties.create_properties ();
    assert (props != -0);
}

public void test_basic_properties () {
    assert (SDL.Properties.set_boolean_property (props, "TestProp_boolean", true) == true);
    assert (SDL.Properties.set_float_property (props, "TestProp_float", 3.1584f) == true);
    assert (SDL.Properties.set_number_property (props, "TestProp_number", 12345) == true);
    assert (SDL.Properties.set_string_property (props, "TestProp_string", "This is a test string") == true);

    var bool_value = SDL.Properties.get_boolean_property (props, "TestProp_boolean", false);
    var float_value = SDL.Properties.get_float_property (props, "TestProp_float", 0);
    var number_value = SDL.Properties.get_number_property (props, "TestProp_number", 0);
    var string_value = SDL.Properties.get_string_property (props, "TestProp_string", "Should not appear here");

    assert (bool_value == true);
    assert (float_value == 3.1584f);
    assert (number_value == 12345);
    assert (string_value == "This is a test string");
}

public void test_false_properties () {
    var false_prop_exists = SDL.Properties.has_property (props, "FalseProp");
    var false_prop_def_val = SDL.Properties.get_string_property (props, "FalseProp", "Default text");
    assert (false_prop_exists == false);
    assert (false_prop_def_val == "Default text");
}

public void test_pointer_properties () {
    array_pointer_sample = { 2, 4, 10 };
    // Store length, should be the proper way to know what to hold a pointer value (if an array for example) and such
    SDL.Properties.get_number_property (props, "TestProp_pointer_length", array_pointer_sample.length);
    assert (SDL.Properties.set_pointer_property (props, "TestProp_pointer", (void*) array_pointer_sample) == true);

    var pointer_retrieved = SDL.Properties.get_pointer_property (props, "TestProp_pointer", null);
    var pointer_length = SDL.Properties.get_number_property (props, "TestProp_pointer_length", -1);

    // Don't copy the data, thus the unowned
    unowned uint8[] retrieved_array = (uint8[]) pointer_retrieved;
    retrieved_array.length = (int) pointer_length;

    assert (retrieved_array[0] == 2);
    assert (retrieved_array[1] == 4);
    assert (retrieved_array[2] == 10);
}

public void test_callback_properties () {
    properties_count = 0;
    assert (SDL.Properties.enumerate_properties (props, callback_count_properties) == true);
    assert (properties_count == 5);

    assert (SDL.Properties.set_pointer_property_with_cleanup (props,
                                                              "TestProp_pointer_2",
                                                              (void*) array_pointer_sample,
                                                              callback_set_pointer_property_cleanup) == true);
    assert (SDL.Properties.clear_property (props, "TestProp_pointer_2") == true);
    assert (cleanup_function_called == true);
}

public void test_destroy_properties () {
    SDL.Properties.destroy_properties (props);
    properties_count = 0;
    SDL.Properties.enumerate_properties (props, callback_count_properties);
    assert (properties_count == 0);
}

public void callback_count_properties (SDL.Properties.PropertiesID props, string name) {
    properties_count++;
}

public void callback_set_pointer_property_cleanup (void* value) {
    cleanup_function_called = true;
}

public int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/test_create_properties", test_create_properties);
    Test.add_func ("/test_basic_properties", test_basic_properties);
    Test.add_func ("/test_false_properties", test_false_properties);

    Test.add_func ("/test_pointer_properties", test_pointer_properties);
    Test.add_func ("/test_callback_properties", test_callback_properties);

    Test.add_func ("/test_destroy_properties", test_destroy_properties);

    return Test.run ();
}