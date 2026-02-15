@abstract
class_name RefCounted89
extends RefCounted
## Abstract base class which should be used instead of RefCounted
##
## This requires certain abstract functions that make the larger code base
## easier and cleaner to maintain.


## Returns the customer class name of the custom class.
func get_class_name() -> String:
    return self.get_script().get_global_name()


func _set_not_allowed(variable_name: String) -> void:
    Utils.set_not_allowed(
        get_class_name(),
        variable_name,
    )
