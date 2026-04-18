extends Node
## General utilities.


## An enumerator for storing integer values of characters.
##
## Especially necessary when using the FilePointerReader as that operates with
## bytes instead of strings.
enum Char89 {
    NEWLINE = 10,
}


## A custom error enumerator. `OK` is the only member that is shared with the
## built in `Error` enumerator. Everything else is greater or equal to 89.
enum Error89 {
    OK = Error.OK,
    DOES_NOT_END_WITH_DELIMITER = 89,
}


## File system related utilities.
class FileSystem:
    extends RefCounted89

    ## File system object type "enumerator" intended for debugging purposes.
    class ObjectType:
        extends RefCounted89

        const DIRECTORY = "directory"
        const FILE = "file"

    static func _push_error(
            object_type: String,
            path: String,
            error: Error,
    ) -> void:
        push_error(
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
        # var dir = DirAccess.open(path)
        var dir = DirAccess.open("KAKKAPÄÄAPINA")

        if not dir:
            var error: Error = DirAccess.get_open_error()
            _push_error(
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


## Returns the names of all of the autoloaded nodes.
func get_autoload_names() -> PackedStringArray:
    var autoload_names: PackedStringArray

    for property in ProjectSettings.get_property_list():
        if property.name.begins_with("autoload/"):
            autoload_names.append(property.name.split("/")[1])

    return autoload_names


func not_implemented_error() -> void:
    var calling_function: Dictionary = get_stack()[1]
    push_error(
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
    push_error(
        "Setting a value for property `{class_name}.{variable_name}` is not supported!".format({
            "class_name": class_name_,
            "variable_name": variable_name_,
        })
    )
