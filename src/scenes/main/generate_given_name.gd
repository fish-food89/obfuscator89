extends Button

func _ready() -> void:
    pass


func _pressed() -> void:
    var output: Label = self.get_node("../output")
    output.text = ""

    for file_path in DataFiles._files.keys():
        var metadata: FileMetadata = DataFiles._files[file_path]

        if len(output.text):
            output.text += "\n"

        output.text += "{file_path}: {metadata}".format({
            "file_path": file_path,
            "metadata": metadata,
        })

        print(metadata.file_pointers[0])
