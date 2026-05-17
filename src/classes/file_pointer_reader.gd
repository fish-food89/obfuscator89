class_name FilePointerReader
extends RefCounted89
## A reader which creates `FilePointer´ objects.

const _BUFFER_SIZE: int = 10


static func _get_end_position(
        start_position: int,
        buffer_loads: int,
        buffer_size: int,
        find_position: int,
        delimiter_length: int,
) -> int:
    return (
        start_position
        + ((buffer_loads - 1) * buffer_size)
        + find_position
        + delimiter_length
        - 1
    )


static func _delimiter_cut_short(
        file: FileAccess,
        delimiter: PackedByteArray,
        buffer: PackedByteArray,
        latest_index: int,
        error: Error89.Code,
) -> Error89.Code:
    var discovered_delimiter_length: int = 0

    while error == Error89.Code.WHAT_CUT_SHORT:
        discovered_delimiter_length += len(buffer) - latest_index
        buffer = file.get_buffer(_BUFFER_SIZE)
        var cut_short_result: FindArrayResult = Utils.find_array(
            buffer,
            delimiter.slice(discovered_delimiter_length),
            0,
        )
        latest_index = cut_short_result.index
        error = cut_short_result.error

    return error


## Scans the given file for file pointers based on the given delimiter.
static func scan(
        file: FileAccess,
        delimiter: PackedByteArray,
        file_pointers: Array[FilePointer],
) -> Error89.Code:
    var error: Error89.Code = Error89.Code.OK

    # Set the file cursor to the beginning of the file.
    file.seek(0)
    var start_pos: int = file.get_position()
    var buffer_loads: int = 0

    while file.get_position() < file.get_length():
        var buffer: PackedByteArray = file.get_buffer(_BUFFER_SIZE)
        buffer_loads += 1

        var find_pos: FindArrayResult = Utils.find_array(buffer, delimiter, 0)
        var latest_index: int = find_pos.index
        error = find_pos.error

        # The delimiter was not found in the buffer. It is possible it exists in
        # a buffer that comes along later so we continue scanning buffers with
        # the hopes of finding a delimiter.
        if error == Error89.Code.WHAT_NOT_FOUND:
            continue

        if error == Error89.Code.WHAT_CUT_SHORT:
            error = _delimiter_cut_short(
                file,
                delimiter,
                buffer,
                latest_index,
                error,
            )

        if error != Error89.Code.OK:
            return error

        var end_pos: int = _get_end_position(
            start_pos,
            buffer_loads,
            _BUFFER_SIZE,
            find_pos.index,
            len(delimiter),
        )
        var file_pointer: FilePointer = FilePointer.new(
            start_pos,
            end_pos,
        )
        file_pointers.append(file_pointer)
        start_pos = end_pos + 1
        file.seek(start_pos)
        buffer_loads = 0

    return error
