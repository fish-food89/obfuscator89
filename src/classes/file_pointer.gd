class_name FilePointer
extends RefCounted
## A pointer to a position in a file.

var start_pos: int
var end_pos: int


func _to_string() -> String:
    return "FilePointer(start_pos={start_pos}, end_pos={end_pos}) #{id}".format({
        "start_pos": start_pos,
        "end_pos": end_pos,
        "id": self.get_instance_id(),
    })
