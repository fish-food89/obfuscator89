extends Button

func _ready() -> void:
    pass


func _pressed() -> void:
    var output: Label = self.get_node("../output")
    output.text = "{given_name} {surname}".format({
        "given_name": _get_random_given_name(),
        "surname": _get_random_surname(),
    })

    # for file_path in DataFiles._files.keys():
    #     var metadata: FileMetadata = DataFiles._files[file_path]

    #     if len(output.text):
    #         output.text += "\n"

    #     output.text += "{file_path}: {metadata}".format({
    #         "file_path": file_path,
    #         "metadata": metadata,
    #     })

    #     print(metadata.file_pointers[0])


# TODO: IMPLEMENT
func _get_random_given_name() -> String:
    Utils.not_implemented_error()
    return ""


# TODO: IMPLEMENT
func _get_random_surname() -> String:
    Utils.not_implemented_error()
    return ""
