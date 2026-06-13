extends Node
## General utilities.


## An enumerator for storing integer values of characters in UTF-8 encoded format
##
## Especially necessary when using the FilePointerReader as that operates with
## bytes instead of strings.
enum Char89 {
    NEWLINE = 10,
    SPACE = 32,
}


## File system related utilities.
class FileSystem:
    extends RefCounted89

    ## File system object type "enumerator" intended for debugging purposes.
    class ObjectType:
        extends RefCounted89

        const DIRECTORY = "directory"
        const FILE = "file"

    static func path_open_error(
            object_type: String,
            path: String,
            error: Error,
    ) -> void:
        ErrorDialog.error(
            "Error in opening {object_type}: `{path}`. Received Error: {error}".format({
                "object_type": object_type,
                "path": path,
                "error": error,
            })
        )


    ## [b]Lists all files discovered in the given directory.[/b][br][br]
    ##
    ## [b][u]Args:[/u][/b][br][br]
    ##    - [param path]: The file path to the directory.[br][br]
    ##    - [param files]: The PackedStringArray to which the discovered files' paths are to be
    ##        stored.[br][br]
    ##    - [param recursive]: Set this to `true` if you wish to recursively list also the
    ##        files in the subdirectories of the directory given in `path`.[br][br]
    ##    - [param include_hidden]: Include hidden files in the results if this is `true`. By
    ##        default this is set to `false`, so hidden files are not returned in the
    ##        `files` PackedStringArray by default.[br][br]
    ##
    ## [b][u]Returns:[/u][/b][br][br]
    ##    - [enum Error]
    static func list_dir_files(
            path: String,
            files: PackedStringArray,
            recursive: bool = false,
            include_hidden: bool = false
    ) -> Error:
        var dir = DirAccess.open(path)

        if not dir:
            var error: Error = DirAccess.get_open_error()
            path_open_error(
                ObjectType.DIRECTORY,
                path,
                error,
            )
            return error

        dir.include_hidden = include_hidden
        dir.list_dir_begin()
        var item: String = dir.get_next()
        var item_path: String

        while item:
            item_path = "/".join([
                dir.get_current_dir(),
                item,
            ])

            if recursive and dir.current_is_dir():
                var error: Error = list_dir_files(
                    item_path,
                    files,
                    recursive,
                    include_hidden,
                )

                if error:
                    return error

            elif not dir.current_is_dir():
                files.append(item_path)

            item = dir.get_next()

        dir.list_dir_end()
        return Error.OK


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


## Searches for the position of the first element of `what` from `source`[br]
##
## [b][u]Args:[/u][/b]
##     - [param source]: The array to which the search is conducted.[br]
##     - [param what]: The array that is being search from from the [param source].[br]
##     - [param from]: The index from which to being the searching from.[br]
##
## [b][u]Returns:[/u][/b][br]
##     - >= 0: The index of `source` from which the first element of `what` was
##         found from when staring the discovery from the index given through the
##         argument `from`.
##     - -1: The first element of `what` was not discovered from `source`.
static func _find_array_first_element(
        source: Array,
        what: Array,
        from: int,
) -> int:
    var index: int = source.find(what[0], from)

    if index == null:
        return -1
    return index


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
func find_array(
        source: Array,
        what: Array,
        from: int,
        previous_error: Error89.Code,
) -> FindArrayResult:
    var result: FindArrayResult = FindArrayResult.new()

    result.error = _find_array_error(source, what, from)

    if result.error:
        return result

    var source_index: int = _find_array_first_element(source, what, from)

    if _find_array__what_not_found__source_index(source_index, previous_error):
        result.error = Error89.Code.WHAT_NOT_FOUND
        return result

    # We can set the discoery point once we've found the first element.
    result.index = source_index

    # No need to go to the for loop if the length of the array we are looking for
    # is 1.
    if len(what) == 1:
        return result

    # Index `0` has already been checked for when calling `_find_array_first_element()`
    # above. Therefore we start the range from `1` so that we don't lose of the
    # correct track of processed indices.
    for i in range(1, len(what)):
        var next_source_index: int = source_index + i

        if next_source_index == len(source):
            result.error = Error89.Code.WHAT_CUT_SHORT
            return result

        if source[next_source_index] != what[i]:
            result.error = Error89.Code.WHAT_NOT_FOUND
            return result

    return result


## Returns the names of all of the autoloaded nodes.
func get_autoload_names() -> PackedStringArray:
    var autoload_names: PackedStringArray

    for property in ProjectSettings.get_property_list():
        if property.name.begins_with("autoload/"):
            autoload_names.append(property.name.split("/")[1])

    return autoload_names


func not_implemented_error() -> void:
    var calling_function: Dictionary = get_stack()[1]
    ErrorDialog.error(
        "NOT IMPLEMENTED ERROR: `{function}` in `{source}` at line `{line}`.".format({
            "function": calling_function["function"],
            "source": calling_function["source"],
            "line": calling_function["line"],
        })
    )


func set_not_allowed(
        class_name_: String,
        variable_name_: String,
) -> void:
    ErrorDialog.error(
        "Setting a value for property `{class_name}.{variable_name}` is not supported!".format({
            "class_name": class_name_,
            "variable_name": variable_name_,
        })
    )
