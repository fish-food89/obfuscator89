class_name ArrayTools
extends RefCounted89
## Tools that help with arrays.


static func _find_array_error(
        source: Array,
        what: Array,
        from: int,
) -> Error89.Code:
    if not source:
        return Error89.Code.SOURCE_IS_EMPTY
    if not what:
        return Error89.Code.WHAT_IS_EMPTY
    if len(source) < len(what):
        return Error89.Code.SOURCE_IS_SMALLER
    if from < 0:
        return Error89.Code.INDEX_IS_LESS_THAN_ZERO
    return Error89.Code.OK


## Returns `true` if the logic determines that `what` was not found.
## `false is returned as a complement of that logic.
static func _find_array__what_not_found__source_index(
        source_index: int,
        previous_error: Error89.Code,
) -> bool:
    if source_index == -1:
        return true

    if source_index > 0 and previous_error == Error89.Code.WHAT_CUT_SHORT:
        return true

    return false


## Searches for the first occurrence of an array from an array[br]
##
## Works like the `find()` method of arrays, but instead of looking a single
## object it searches for an array of objects from the source array.[br]
##
## [b][u]Args:[/u][/b][br]
##     - [param source]: The array to which the search is conducted.[br]
##     - [param what]: The array that is being search from from the [param source].[br]
##     - [param from]: The index from which to being the searching from.[br]
##
## [b][u]Returns:[/u][/b][br]
##     - FindArrayResult
static func find_array(
        source: Array,
        what: Array,
        from: int,
        previous_error: Error89.Code,
) -> FindArrayResult:
    var error: Error89.Code = _find_array_error(source, what, from)

    if error:
        return FindArrayResult.new(error)

    var source_index: int = find_array_first_element(source, what, from)

    if _find_array__what_not_found__source_index(source_index, previous_error):
        return FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND)

    # No need to go to the for loop if the length of the array we are looking for
    # is 1.
    if len(what) > 1:
        # Index `0` has already been checked for when calling `_find_array_first_element()`
        # above. Therefore we start the range from `1` so that we don't lose of the
        # correct track of processed indices.
        for i in range(1, len(what)):
            var next_source_index: int = source_index + i

            if next_source_index == len(source):
                return FindArrayResult.new(Error89.Code.WHAT_CUT_SHORT)

            if source[next_source_index] != what[i]:
                return FindArrayResult.new(Error89.Code.WHAT_NOT_FOUND)

    return FindArrayResult.new(Error89.Code.OK, source_index)


## Searches for the position of the first element of `what` from `source`[br]
##
## [b][u]Args:[/u][/b]
##     - [param source]: The array to which the search is conducted.[br]
##     - [param what]: The array that is being search from from the [param source].[br]
##     - [param from]: The index from which to being the searching from.[br]
##
## [b][u]Returns:[/u][/b][br]
##     - GTE 0: The index of `source` from which the first element of `what` was
##         found from when staring the discovery from the index given through the
##         argument `from`.[br]
##     - -1: The first element of `what` was not discovered from `source`.
static func find_array_first_element(
        source: Array,
        what: Array,
        from: int,
) -> int:
    var index: int = source.find(what[0], from)

    if index == null:
        return -1
    return index
