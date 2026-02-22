extends PopupMenu


func _ready() -> void:
    var file: FileAccess = FileAccess.open(
        "res://LICENSE",
        FileAccess.ModeFlags.READ,
    )

    while file.get_position() < file.get_length():
        self.add_item(file.get_line())
