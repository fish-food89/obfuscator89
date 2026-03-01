extends Button


var _file_dialog: FileDialog


func _create_file_dialog() -> void:
    _file_dialog = FileDialog.new()
    _file_dialog.access = FileDialog.Access.ACCESS_FILESYSTEM
    _file_dialog.display_mode = FileDialog.DisplayMode.DISPLAY_LIST
    _file_dialog.file_mode = FileDialog.FileMode.FILE_MODE_OPEN_DIR
    _file_dialog.name = "SelectDirFileDialog"

    self.get_tree().get_current_scene().add_child(_file_dialog)
    _file_dialog.dir_selected.connect(_on_dir_selected)


func _get_output() -> RichTextLabel:
    return self.get_node("../Output")


func _on_dir_selected(dir_path: String) -> void:
    var output: RichTextLabel = _get_output()
    output.text = dir_path


func _pressed() -> void:
    if not _file_dialog:
        _create_file_dialog()

    _file_dialog.visible = true
