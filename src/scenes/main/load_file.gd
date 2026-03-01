extends Button89


func _ready() -> void:
    self.get_file_dialog().files_selected.connect(_on_files_selected)


func _on_files_selected(file_paths: PackedStringArray) -> void:
    var output: RichTextLabel = self.get_output()
    output.text = ""

    for file_path in file_paths:
        output.text += "%s\n" % file_path


func _pressed() -> void:
    var file_dialog: FileDialog = self.get_file_dialog()
    file_dialog.file_mode = FileDialog.FileMode.FILE_MODE_OPEN_FILES
    file_dialog.visible = true
