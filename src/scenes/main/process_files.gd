extends Button89

const _ERROR_DIALOG_PATH = "../../ErrorDialog"
const _LOAD_FILES_NODE_PATH = "../../LoadFiles/Button"
const _SELECT_OUTPUT_DIR_NODE_PATH = "../../SelectOutputDir/Button"


func _pressed() -> void:
    var i: int = 0

    for file_path in _get_file_paths():
        i += 1

        if not FileAccess.file_exists(file_path):
            _file_does_not_exist_error(file_path)
            break

        _process_file(file_path)

    if not i:
        _no_loaded_files_error()


func _process_file(file_path: String) -> void:
    if not _get_output_dir():
        _no_output_dir_error()
        return

    var file: FileAccess = FileAccess.open(
        file_path,
        FileAccess.ModeFlags.READ,
    )


func _file_does_not_exist_error(file_path: String) -> void:
    ErrorDialog.error(
        "".join([
            "No file exists at the path pointed to by: ",
            '"{file_path}".\n',
            "Aborting file processing.",
        ]).format({
            "file_path": file_path,
        })
    )


func _get_file_paths() -> PackedStringArray:
    return _get_load_files_button().get_output().text.split("\n", false)


func _get_load_files_button() -> Button89:
    return self.get_node(_LOAD_FILES_NODE_PATH)


func _get_output_dir() -> String:
    return _get_select_output_dir_buttion().get_output().text


func _get_select_output_dir_buttion() -> Button89:
    return self.get_node(_SELECT_OUTPUT_DIR_NODE_PATH)


func _no_loaded_files_error() -> void:
    ErrorDialog.error(
        " ".join([
            "No loaded files to process!",
            "Make sure you have selected files with the",
            '"{load_files_text}" button.',
        ]).format({
            "load_files_text": _get_load_files_button().text,
        })
    )


func _no_output_dir_error() -> void:
    ErrorDialog.error(
        " ".join([
            "No output directory has been specified for the processed files.",
            "Make sure you have defined an output directory with the",
            '"{select_output_dir_text}" button.',
        ]).format({
            "select_output_dir_text": _get_select_output_dir_buttion().text,
        })
    )
