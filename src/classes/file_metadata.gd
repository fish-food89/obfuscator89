class_name FileMetadata
extends RefCounted89
## [b]A class which stores file metadata.[/b][br]
##
## [b][u]Args:[/u][/b][br][br]
##    - [param file_path_]: The file path to the file whose metadata is to be
##        processed.[br]
##    - [param file_pointer_delimiter_]: The delimiter which is to be used when
##        generating file pointers for the file. By default this is `null` in
##        which case no file pointers will be generated for the file.[br]

## The length of the file in bytes.
var length: int:
    get:
        return _length
    set(_value):
        _set_not_allowed("length")

## The path to the file in the file system.
var file_path: String:
    get:
        return _file_path
    set(_value):
        _set_not_allowed("file_path")

## The delimiter used when generating file pointers.
var file_pointer_delimiter: int:
    get:
        return _file_pointer_delimiter
    set(_value):
        _set_not_allowed("file_pointer_delimiter")

## Tells if there are some errors with `file_pointers`.
##
##
var file_pointer_error:
    get:
        return _get__file_pointer_error()
    set(_value):
        _set_not_allowed("file_pointer_error")

## The array of file pointers generated from the file.
var file_pointers: Array[FilePointer]:
    get:
        return _file_pointers
    set(_value):
        _set_not_allowed("file_pointers")


var _length: int
var _file_path: String
var _file_pointer_delimiter: int
var _file_pointers: Array[FilePointer]


func _init(
        file_path_: String,
        file_pointer_delimiter_: int = Utils.Char89.NEWLINE,
) -> void:
    _file_path = file_path_
    _file_pointer_delimiter = file_pointer_delimiter_

    var file: FileAccess = FileAccess.open(
        file_path,
        FileAccess.ModeFlags.READ,
    )

    if not file:
        _push_file_open_error(file_path, FileAccess.get_open_error())
        return

    _length = file.get_length()
    FilePointerReader.scan(
        file,
        file_pointer_delimiter,
        _file_pointers,
    )


func _push_file_open_error(
        file_path_: String,
        error: Error,
) -> void:
    ErrorDialog.error(
        "Could not open `{file_path}`! Received Error value `{error}`.".format({
            "file_path": file_path_,
            "error": error,
        })
    )


func _set_not_allowed(property_name: String) -> void:
    Utils.set_not_allowed(self.get_class_name(), property_name)


func _to_string() -> String:
    if len(file_pointers) <= 10:
        return "{class_name}(file_path=\"{file_path}\", length={length}, file_pointers={file_pointers}) #{id}".format({
            "class_name": self.get_class_name(),
            "file_path": file_path,
            "length": length,
            "file_pointers": file_pointers,
            "id": self.get_instance_id(),
        })

    return "{class_name}(file_path=\"{file_path}\", length={length}, len(file_pointers)={file_pointers}) #{id}".format({
            "class_name": self.get_class_name(),
            "file_path": file_path,
            "length": length,
            "file_pointers": len(file_pointers),
            "id": self.get_instance_id(),
        })


func get_file_value(
        file: FileAccess,
        file_pointer: FilePointer,
) -> String:
    file.seek(file_pointer.start_pos)
    return file.get_buffer(file_pointer.length).get_string_from_utf8()



func get_random_file_value() -> String:
    var file_pointer: FilePointer = file_pointers.pick_random()
    var file: FileAccess = FileAccess.open(
        file_path,
        FileAccess.ModeFlags.READ,
    )
    return get_file_value(file, file_pointer)


## Checks the file pointers for errors[br]
##
## [b][u]Returns:[/u][/b][br]
##     - `Utils.Error89.OK`: All clear. No errors discovered.[br]
##     - `Utils.Error89.DOES_NOT_END_WITH_DELIMITER`: This is returned if a
##         file pointer does not end with the correct delimiter.[br]
##     - `Error`: A value of the `Error` enum is returned if some error occurred
##         in opening the file for file pointer verification.
func _get__file_pointer_error() -> int:
    var file: FileAccess = FileAccess.open(
        file_path,
        FileAccess.ModeFlags.READ,
    )

    if not file:
        var error: Error = FileAccess.get_open_error()
        _push_file_open_error(file_path, error)
        return error

    for i in range(file_pointers.size()):
        var file_pointer: FilePointer = file_pointers[i]
        file.seek(file_pointer.start_pos)

        var buffer: PackedByteArray = file.get_buffer(file_pointer.length)

        if buffer[-1] != file_pointer_delimiter:
            ErrorDialog.error(
                (
                    "Could not find the expected delimiter `{delimiter}` from "
                    + "the `end_pos` of `{file_pointer}` at index `{index}` of "
                    + "`{metadata}`. Found `{value}` instead."
                ).format({
                    "delimiter": file_pointer_delimiter,
                    "file_pointer": file_pointer,
                    "index": i,
                    "metadata": self,
                    "value": buffer[-1],
                })
            )
            return Utils.Error89.DOES_NOT_END_WITH_DELIMITER

    return Utils.Error89.OK
