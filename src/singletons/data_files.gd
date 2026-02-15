extends Node
## A singleton for storing metadata about data files
##
## Amount of lines and available data files per locale and such are scanned by
## and stored by this singleton upon loading the application.


const _FILE_PATH: String = "file_path"
const FILE_PATH_BASE: String = "res://data"

var _category: Dictionary[String, Dictionary] = {
    "given_name": {
        _FILE_PATH: "names/given_names",
    },
    "surname": {
        _FILE_PATH: "names/surnames",
    },
}
var _files: Dictionary[String, FileMetadata]

var category: Dictionary[String, Dictionary]:
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


func _initialize_category() -> void:
    for value in _category.values():
        value.file_path = "{base}/{path}".format({
            "base": FILE_PATH_BASE,
            "path": value.file_path,
        })


## Scans the files in the `data/` directory recursively
##
## While scanning it gathers the files' metadata and stores them to this
## singleton.
func _scan() -> void:
    var _file_paths: PackedStringArray

    Utils.FileSystem.list_dir_files(
        FILE_PATH_BASE,
        _file_paths,
        true,
        false,
    )

    for file_path in _file_paths:
        var file: FileAccess = FileAccess.open(
            file_path,
            FileAccess.ModeFlags.READ,
        )
        var metadata: FileMetadata = FileMetadata.new()
        metadata.length = file.get_length()
        FilePointerReader.scan(
            file,
            "\n",
            metadata.file_pointers,
        )
        _files[file_path] = metadata
