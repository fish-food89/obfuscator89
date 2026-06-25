class_name FindArrayResult
extends RefCounted89
## A class originally created for holding the results of `ArrayTools.find_array()`.


var _error: Error89.Code
var _index: int

## Holds any information about errors that occurred.
## If errors occured the value of `index` should be ignored except in the
## case of the error being `Error89.Code.WHAT_CUT_SHORT`.
var error: Error89.Code:
    get:
        return _error
    set(_value):
        self._set_not_allowed("error")

## The index from which "what" was found from "source".
var index: int:
    get:
        return _index
    set(_value):
        self._set_not_allowed("index")


func _init(
        error_: Error89.Code,
        index_: int = -1,
) -> void:
    _error = error_
    _index = index_
