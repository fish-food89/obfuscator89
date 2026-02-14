extends Node
## A singleton for storing metadata about data files
##
## Amount of lines and available data files per locale and such are scanned by
## and stored by this singleton upon loading the application.


var _files: Dictionary[String, Variant]


func _ready() -> void:
    _scan()


## Scans the files in the `data/` directory recursively
##
## While scanning it gathers the files' metadata and stores them to this
## singleton.
func _scan() -> void:
    var _file_paths: PackedStringArray

    Utils.FileSystem.list_dir_files(
        "res://data/",
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
