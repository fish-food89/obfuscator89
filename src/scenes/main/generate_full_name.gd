extends Button


func _pressed() -> void:
    var output: RichTextLabel = self.get_node("../output")
    output.text = "{given_name} {surname}".format({
        "given_name": Names.get_random_given_name(),
        "surname": Names.get_random_surname(),
    })
