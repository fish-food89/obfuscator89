class_name FindArrayResult
extends RefCounted89
## A class for holding the results of `Utils.find_array()`.


## Holds any information about errors that occurred.
## If errors occured the value of `index` should be ignored except in the
## case of the error being `Error89.Code.WHAT_CUT_SHORT`.
var error: Error89.Code
## The index from which "what" was found from "source".
var index: int
