extends Button89


func _ready() -> void:
    self.get_file_dialog().dir_selected.connect(_on_dir_selected)


func _on_dir_selected(dir_path: String) -> void:
    self.get_output().text = dir_path


func _pressed() -> void:
    var file_dialog: FileDialog = self.get_file_dialog()
    file_dialog.file_mode = FileDialog.FileMode.FILE_MODE_OPEN_DIR
    file_dialog.visible = true
