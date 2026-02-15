extends Node
## A singleton for storing metadata about data files
##
## Amount of lines and available data files per locale and such are scanned by
## and stored by this singleton upon loading the application.


const FILE_PATH_BASE: String = "res://data/"

var _categories: Array[Category] = [
    Category.new(
        "given_name",
        "names/given_names",
    ),
    Category.new(
        "surname",
        "names/surnames",
    ),
]
var _files: Dictionary[String, Variant]

var categories: Array[Category]:
    get:
        return _categories.duplicate(true)
    set(_value):
        Utils.set_not_allowed(
            self.name,
            "categories",
        )


## To be used for categorising data files so that they are logically managed.
class Category:
    extends RefCounted89

    static var _wrapping_class_name: String = "":
        get:
            return _wrapping_class_name
        set(value):
            if not len(_wrapping_class_name):
                _wrapping_class_name = value

    static var _class_name: String = "Category":
        get:
            return "{wrapping_class}.{class_name}".format({
                "wrapping_class": _wrapping_class_name,
                "class_name": _class_name,
            })
        set(_value):
            Utils.set_not_allowed(
                _class_name,
                "_class_name",
            )

    var _name: String
    var _file_path: String

    var name: String:
        get:
            return _name
        set(_value):
            Utils.set_not_allowed(
                _class_name,
                "name",
            )
    var file_path: String:
        get:
            return _file_path
        set(_value):
            Utils.set_not_allowed(
                _class_name,
                "file_path",
            )

    func _init(
            name_: String,
            file_path_: String,
    ) -> void:
        _name = name_
        _file_path = file_path_


func _ready() -> void:
    Category._wrapping_class_name = self.name
    _scan()


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
