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
        metadata.file_pointers[0].start_pos = 1337

    for category in DataFiles.categories:
        print(category.file_path)
        category.file_path = "haha"
        print(category.file_path)
