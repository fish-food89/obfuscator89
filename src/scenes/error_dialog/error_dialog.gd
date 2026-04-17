extends AcceptDialog


func _ready() -> void:
    self.visible = false


func error(message: String) -> void:
    self.title = "Error!"
    self.dialog_text = message
    self.visible = true
