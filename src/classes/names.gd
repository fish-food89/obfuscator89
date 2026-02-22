class_name Names
extends RefCounted89
## The class for handling logic for generating obfuscated names.


static func _remove_last_character(value: String) -> String:
    return value.substr(0, value.length() - 1)


static func get_random_given_name() -> String:
    var value: String = DataFiles.category[DataFiles.Category.GIVEN_NAME].files.get_random_file_value()
    return _remove_last_character(value)


static func get_random_surname() -> String:
    var value: String = DataFiles.category[DataFiles.Category.SURNAME].files.get_random_file_value()
    return _remove_last_character(value)
