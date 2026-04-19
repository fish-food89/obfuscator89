class_name Names
extends RefCounted89
## The class for handling logic for generating obfuscated names.


static func _remove_last_character(value: String) -> String:
    return value.substr(0, value.length() - 1)


## Returns a random full name
##
## The returned full name is in the format of: "<full_name> <surname>", e.g.
## "Jazz Hands".
static func get_random_full_name() -> String:
    return "{given_name} {surname}".format({
        "given_name": get_random_given_name(),
        "surname": get_random_surname(),
    })


## Returns a random given name
static func get_random_given_name() -> String:
    var value: String = DataFiles.category[DataFiles.Category.GIVEN_NAME].files.get_random_file_value()
    return _remove_last_character(value)


## Returns a random surname
static func get_random_surname() -> String:
    var value: String = DataFiles.category[DataFiles.Category.SURNAME].files.get_random_file_value()
    return _remove_last_character(value)
