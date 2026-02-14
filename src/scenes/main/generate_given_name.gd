extends Button

func _ready() -> void:
    pass


func _pressed() -> void:
    print('Virtual pressed function call!')

    var path: String = "res://data/"
    var files: PackedStringArray = []
    var error: Error = Utils.list_dir_files(
        path,
        files,
        true,
        false,
    )
    print("Error:", error)
    print("files:", files)
