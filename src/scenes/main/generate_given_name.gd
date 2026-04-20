extends Button


func _pressed() -> void:
    var output: RichTextLabel = self.get_node("../Output")
    output.text = Names.get_random_given_name()
