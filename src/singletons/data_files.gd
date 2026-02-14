extends Node
## A singleton for storing metadata about data files
##
## Amount of lines and available data files per locale and such are scanned by
## and stored by this singleton upon loading the application.


var _files: PackedStringArray


func _ready() -> void:
    _scan()


## Scans the files in the `data/` directory recursively
##
## While scanning it gathers the files' metadata and stores them to this
## singleton.
func _scan() -> void:
    Utils.list_dir_files(
        "res://data/",
        _files,
        true,
        false,
    )
