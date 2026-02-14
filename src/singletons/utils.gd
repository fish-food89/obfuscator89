extends Node
## General utilities.


## File system related utilities.
class FileSystem:
    extends RefCounted

    static func _push_error(
            path: String,
            error: Error,
    ) -> void:
        push_error(
            "Error in opening directory: `{path}`. Received Error: {error}".format({
                "path": path,
                "error": error,
            })
        )


    ## Lists all files discovered in the given directory.
    ##
    ## Args:
    ##  path: The file path to the directory.
    ##  files: The PackedStringArray to which the discovered files' paths are to be
    ##      stored.
    ##  recursive: Set this to `true` if you wish to recursively list also the
    ##      files in the subdirectories of the directory given in `path`.
    ##  include_hidden: Include hidden files in the results if this is `true`. By
    ##      default this is set to `false`, so hidden files are not returned in the
    ##      `files` PackedStringArray by default.
    ##
    ## Returns:
    ##  Error
    static func list_dir_files(
            path: String,
            files: PackedStringArray,
            recursive: bool = false,
            include_hidden: bool = false
    ) -> Error:
        var dir = DirAccess.open(path)

        if not dir:
            var error: Error = DirAccess.get_open_error()
            _push_error(path, error)
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
