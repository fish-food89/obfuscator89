class_name FilePointer
extends RefCounted89
## A pointer to a position in a file.

var _start_pos: int
var _end_pos: int

var start_pos: int:
    get:
        return _start_pos
    set(_value):
        self._set_not_allowed("start_pos")

var end_pos: int:
    get:
        return _end_pos
    set(_value):
        self._set_not_allowed("end_pos")

var length: int:
    get:
        # Offset by + 1 to include the last character in the length.
        return _end_pos - _start_pos + 1
    set(_value):
        self._set_not_allowed("length")


func _init(
        start_pos_: int,
        end_pos_: int,
) -> void:
    _start_pos = start_pos_
    _end_pos = end_pos_


func _to_string() -> String:
    return "{class_name}(start_pos={start_pos}, end_pos={end_pos}) #{id}".format({
        "class_name": self.get_class_name(),
        "start_pos": start_pos,
        "end_pos": end_pos,
        "id": self.get_instance_id(),
    })
