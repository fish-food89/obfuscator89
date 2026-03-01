@abstract
class_name Button89
extends Button


func get_file_dialog() -> FileDialog:
    return self.get_tree().get_current_scene().get_node("FileDialog")


func get_output() -> RichTextLabel:
    return self.get_node("../Output")
