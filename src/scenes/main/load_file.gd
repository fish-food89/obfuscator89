extends Button


var _file_dialog: FileDialog


func _create_file_dialog() -> void:
    _file_dialog = FileDialog.new()
    _file_dialog.access = FileDialog.Access.ACCESS_FILESYSTEM
    _file_dialog.display_mode = FileDialog.DisplayMode.DISPLAY_LIST
    _file_dialog.file_mode = FileDialog.FileMode.FILE_MODE_OPEN_FILES
    _file_dialog.name = "LoadFileDialog"

    self.get_tree().get_current_scene().add_child(_file_dialog)
    _file_dialog.files_selected.connect(_on_files_selected)


func _get_output() -> RichTextLabel:
    return self.get_node("../Output")


func _on_files_selected(file_paths: PackedStringArray) -> void:
    var output: RichTextLabel = _get_output()
    output.text = ""

    for file_path in file_paths:
        output.text += "%s\n" % file_path


func _pressed() -> void:
    if not _file_dialog:
        _create_file_dialog()

    _file_dialog.visible = true
