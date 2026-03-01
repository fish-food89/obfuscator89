extends FileDialog


func _ready() -> void:
    self.access = FileDialog.Access.ACCESS_FILESYSTEM
    self.display_mode = FileDialog.DisplayMode.DISPLAY_LIST
    self.visible = false
