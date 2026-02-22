extends Node
## A singleton for storing metadata about data files
##
## Amount of lines and available data files per locale and such are scanned by
## and stored by this singleton upon loading the application.


const _DIRECTORY: String = "directory"
const _FILES: String = "files"
const _METADATA: String = "metadata"
const _NEWLINE_CHAR: int = 10

const FILE_PATH_BASE: String = "res://data"

enum Category {
    GIVEN_NAME = 1,
    SURNAME,
}

var _category: Dictionary[Category, Dictionary] = {
    Category.GIVEN_NAME: {
        _DIRECTORY: "names/given_names",
        _FILES: null,
    },
    Category.SURNAME: {
        _DIRECTORY: "names/surnames",
        _FILES: null,
    },
}

var category: Dictionary[Category, Dictionary]:
    get:
        return _category.duplicate(true)
    set(_value):
        Utils.set_not_allowed(
            self.name,
            "category",
        )


func _ready() -> void:
    _initialize_category()
    _scan()


## Returns the [enum Category] the given [param file_path] belongs to if it has
## been defined. Otherwise it returns [code]null[/code].
func _find_category(file_path: String) -> Variant:
    for key in _category.keys():
        var category_dict: Dictionary = _category[key]

        if file_path.begins_with(category_dict[_DIRECTORY]):
            return key

    return null


func _initialize_category() -> void:
    for value in _category.values():
        value[_DIRECTORY] = "{base}/{path}".format({
            "base": FILE_PATH_BASE,
            "path": value[_DIRECTORY],
        })


## Scans the files in the `data/` directory recursively
##
## While scanning it gathers the files' metadata and stores them to this
## singleton.
func _scan() -> void:
    const DELIMITER: int = _NEWLINE_CHAR
    var _file_paths: PackedStringArray

    Utils.FileSystem.list_dir_files(
        FILE_PATH_BASE,
        _file_paths,
        true,
        false,
    )

    for file_path in _file_paths:
        var discovered_category: Variant = _find_category(file_path)

        if not discovered_category:
            continue

        var file: FileAccess = FileAccess.open(
            file_path,
            FileAccess.ModeFlags.READ,
        )
        var metadata: FileMetadata = FileMetadata.new()
        metadata.file_path = file_path
        metadata.length = file.get_length()

        FilePointerReader.scan(
            file,
            DELIMITER,
            metadata.file_pointers,
        )

        if _verify_file_pointers(
                DELIMITER,
                file,
                metadata,
        ):
            continue

        _category[discovered_category][_FILES] = metadata


func _verify_file_pointers(
        delimiter: int,
        file: FileAccess,
        metadata: FileMetadata,
) -> Utils.Error89:
    for i in range(metadata.file_pointers.size()):
        var file_pointer: FilePointer = metadata.file_pointers[i]
        file.seek(file_pointer.start_pos)

        var buffer: PackedByteArray = file.get_buffer(file_pointer.length)

        if buffer[-1] != delimiter:
            push_error(
                (
                    "Could not find the expected delimiter `{delimiter}` from "
                    + "the `end_pos` of `{file_pointer}` at index `{index}` of "
                    + "`{metadata}`. Found `{value}` instead."
                ).format({
                    "delimiter": delimiter,
                    "file_pointer": file_pointer,
                    "index": i,
                    "metadata": metadata,
                    "value": buffer[-1],
                })
            )
            return Utils.Error89.DOES_NOT_END_WITH_DELIMITER

    return Utils.Error89.OK
