extends Button

func _ready() -> void:
    pass


func _pressed() -> void:
    var output: Label = self.get_node("../output")
    output.text = "{given_name} {surname}".format({
        "given_name": _get_random_given_name(),
        "surname": _get_random_surname(),
    })


func _remove_last_character(value: String) -> String:
    return value.substr(0, value.length() - 1)


func _get_random_given_name() -> String:
    var value: String = DataFiles.category[DataFiles.Category.GIVEN_NAME].files.get_random_file_value()
    return _remove_last_character(value)


func _get_random_surname() -> String:
    var value: String = DataFiles.category[DataFiles.Category.SURNAME].files.get_random_file_value()
    return _remove_last_character(value)
