extends Button

func _ready() -> void:
    pass


func _pressed() -> void:
    var output: Label = self.get_node("../output")
    output.text = "\n".join(DataFiles._files)
