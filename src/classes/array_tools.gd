class_name ArrayTools
extends RefCounted89
## Tools that help with arrays.


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
