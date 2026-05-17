extends Button89

const _ERROR_DIALOG_PATH = "../../ErrorDialog"
const _LOAD_FILES_NODE_PATH = "../../LoadFiles/Button"
const _SELECT_OUTPUT_DIR_NODE_PATH = "../../SelectOutputDir/Button"

## Holds the most recent error that occurred in the instance
var error: Error89.Code:
    get:
        return _error
    set(_value):
        Utils.set_not_allowed(self.name, "error")


var _error: Error89.Code = Error89.Code.OK


func _pressed() -> void:
    _error = Error89.Code.OK

    if _validation_error():
        return

    for file_path in _get_file_paths():
        if not FileAccess.file_exists(file_path):
            _file_does_not_exist_error(file_path)
            break

        # TODO: Create a way for the user to give the file pointer delimiter.
        #       This could be done using a text field node to which the user
        #       types the delimiter of their choice. White space characters
        #       should be detected as well. Maybe also having the option of
        #       inputting UTF-8 character codes should be added as well for
        #       even finer control. These codes could be parsed from the user
        #       input.
        _process_file(
            file_path,
            PackedByteArray([Utils.Char89.NEWLINE]),
        )


func _process_file(
        input_file_path: String,
        file_pointer_delimiter: PackedByteArray,
) -> void:
    var metadata: FileMetadata = _get_input_file_metadata(
        input_file_path,
        file_pointer_delimiter,
    )
    if not metadata:
        return

    var output_file_path: String = _get_output_file_path(input_file_path)
    if not output_file_path:
        return

    var output_file: FileAccess = FileAccess.open(output_file_path, FileAccess.ModeFlags.WRITE)
    if not output_file:
        _output_file_open_error(output_file_path, FileAccess.get_open_error())
        return

    var obfuscation_map: Dictionary[PackedByteArray, PackedByteArray] = {}

    for file_pointer in metadata.file_pointers:
        var value: Variant = _generate_output_value(
            obfuscation_map,
            metadata,
            file_pointer,
        )

        if value is Error89.Code:
            _error = value
            break

        if not output_file.store_buffer(value):
            _saving_to_output_file_error(output_file_path, value)
            break


func _directory_does_not_exist_error(file_path: String) -> void:
    _error = Error89.Code.DIRECTORY_DOES_NOT_EXIST
    ErrorDialog.error(
        "".join([
            "No directory exists at the path pointed to by: ",
            '"{file_path}".\n',
            "Aborting file processing.",
        ]).format({
            "file_path": file_path,
        })
    )


func _file_does_not_exist_error(file_path: String) -> void:
    _error = Error89.Code.FILE_DOES_NOT_EXIST
    ErrorDialog.error(
        "".join([
            "No file exists at the path pointed to by: ",
            '"{file_path}".\n',
            "Aborting file processing.",
        ]).format({
            "file_path": file_path,
        })
    )


## [b][u]Returns:[/u][/b][br]
##     - [PackedByteArray] when successful.[br]
##     - [member Error89.Code][code].INPUT_FILE_OPEN_ERROR[/code] when unsucessful and
##         opens the [code]ErrorDialog[/code] singleton with an error message.
func _generate_output_value(
        obfuscation_map: Dictionary[PackedByteArray, PackedByteArray],
        input_file: FileMetadata,
        file_pointer: FilePointer,
) -> Variant:
    var input_value: Variant = input_file.get_file_value_buffer(file_pointer)

    if input_value is Error89.Code:
        return Error89.Code.INPUT_FILE_OPEN_ERROR

    var value = obfuscation_map.get(input_value)

    if value:
        return value

    value = Names.get_random_full_name_buffer()

    while value in obfuscation_map.values():
        value = Names.get_random_full_name_buffer()

    value.append(input_file.file_pointer_delimiter)
    obfuscation_map[input_value] = value
    return value


func _get_file_paths() -> PackedStringArray:
    return _get_load_files_button().get_output().text.split("\n", false)


func _get_input_file_metadata(
        input_file_path: String,
        file_pointer_delimiter: PackedByteArray,
) -> Variant:
    var metadata: FileMetadata = FileMetadata.new(
        input_file_path,
        file_pointer_delimiter,
    )

    if not metadata.file_pointers:
        _no_file_pointers_error(metadata)
        return null

    return metadata


func _get_load_files_button() -> Button89:
    return self.get_node(_LOAD_FILES_NODE_PATH)


func _get_output_dir() -> Variant:
    var output_dir: String = _get_select_output_dir_buttion().get_output().text

    if not output_dir:
        _no_output_dir_error()
        return null

    if not DirAccess.dir_exists_absolute(output_dir):
        _directory_does_not_exist_error(output_dir)
        return null

    return output_dir


func _get_output_file_path(input_file_path: String) -> Variant:
    var output_file_path: String = "{output_dir}/{file_name}".format({
        "output_dir": _get_output_dir(),
        "file_name": input_file_path.get_file(),
    })

    if _error:
        return null

    return output_file_path


func _get_select_output_dir_buttion() -> Button89:
    return self.get_node(_SELECT_OUTPUT_DIR_NODE_PATH)


func _no_file_pointers_error(input_file: FileMetadata) -> void:
    _error = Error89.Code.NO_FILE_POINTERS
    ErrorDialog.error(
        "".join([
            "Cannot process the file!\n",
            'No file pointers were created for "{file_path}" ',
            'with delimiter "U+000{delimiter}".'
        ]).format({
            "file_path": input_file.file_path,
            "delimiter": ("%X" % input_file.file_pointer_delimiter),
        })
    )


func _no_loaded_files_error() -> void:
    _error = Error89.Code.NO_LOADED_FILES
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
    _error = Error89.Code.NO_OUTPUT_DIRECTORY
    ErrorDialog.error(
        " ".join([
            "No output directory has been specified for the processed files.",
            "Make sure you have defined an output directory with the",
            '"{select_output_dir_text}" button.',
        ]).format({
            "select_output_dir_text": _get_select_output_dir_buttion().text,
        })
    )


func _output_file_open_error(
        file_path: String,
        error_: Error,
) -> void:
    _error = Error89.Code.OUTPUT_FILE_OPEN_ERROR
    Utils.FileSystem.path_open_error(
        Utils.FileSystem.ObjectType.FILE,
        file_path,
        error_,
    )


func _saving_to_output_file_error(
        file_path: String,
        value: PackedByteArray,
) -> void:
    _error = Error89.Code.SAVING_TO_OUTPUT_FILE_ERROR
    ErrorDialog.error(
        'Problem saving "{value}" to "{file_path}"!'.format({
            "value": value.get_string_from_utf8(),
            "file_path": file_path,
        }),
    )


func _validation_error() -> Error89.Code:
    if not _get_file_paths():
        _no_loaded_files_error()
    elif not _get_output_dir():
        _no_output_dir_error()

    return _error
