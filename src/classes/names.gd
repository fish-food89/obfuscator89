class_name Names
extends RefCounted89
## The class for handling logic for generating obfuscated names.


static func _remove_last_character(value: String) -> String:
    return value.substr(0, value.length() - 1)


static func _remove_last_element(value: PackedByteArray) -> void:
    value.remove_at(len(value) - 1)


## Returns a random full name as a UTF-8 encoded PackedByteArray
##
## The returned full name is in the format of: "<full_name> <surname>", e.g.
## "Jazz Hands".
static func get_random_full_name_buffer() -> PackedByteArray:
    var full_name: PackedByteArray = get_random_given_name_buffer()
    full_name.append(Utils.Char89.SPACE)
    full_name.append_array(get_random_surname_buffer())
    return full_name


## Returns a random full name as a String
##
## The returned full name is in the format of: "<full_name> <surname>", e.g.
## "Jazz Hands".
static func get_random_full_name() -> String:
    return "{given_name} {surname}".format({
        "given_name": get_random_given_name(),
        "surname": get_random_surname(),
    })


## Returns a random given name as a UTF-8 encoded PackedByteArray
static func get_random_given_name_buffer() -> PackedByteArray:
    var value: PackedByteArray = (
        DataFiles.category[DataFiles.Category.GIVEN_NAME].files.get_random_file_value_buffer()
    )
    # The value contains the delimiter character at the end so we're dropping that.
    # TODO: Dropping only the last item is naive. The dropping should be done with
    #       the actual delimiter instead.
    _remove_last_element(value)
    return value


## Returns a random given name as a String
static func get_random_given_name() -> String:
    var value: String = (
        DataFiles.category[DataFiles.Category.GIVEN_NAME].files.get_random_file_value()
    )
    # TODO: Dropping only the last item is naive. The dropping should be done with
    #       the actual delimiter instead.
    return _remove_last_character(value)


## Returns a random surname as a UTF-8 encoded PackedByteArray
static func get_random_surname_buffer() -> PackedByteArray:
    var value: PackedByteArray = (
        DataFiles.category[DataFiles.Category.SURNAME].files.get_random_file_value_buffer()
    )
    # The value contains the delimiter character at the end so we're dropping that.
    # TODO: Dropping only the last item is naive. The dropping should be done with
    #       the actual delimiter instead.
    _remove_last_element(value)
    return value


## Returns a random surname as a String
static func get_random_surname() -> String:
    var value: String = (
        DataFiles.category[DataFiles.Category.SURNAME].files.get_random_file_value()
    )
    # TODO: Dropping only the last item is naive. The dropping should be done with
    #       the actual delimiter instead.
    return _remove_last_character(value)
