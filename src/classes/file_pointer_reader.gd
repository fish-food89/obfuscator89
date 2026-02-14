class_name FilePointerReader
extends RefCounted
## A reader which creates `FilePointer´ objects.

const _BUFFER_SIZE: int = 1024


static func scan(
        file: FileAccess,
        delimiter: String,
        file_pointers: Array[FilePointer],
) -> void:
    # Set the file cursor to the beginning of the file.
    file.seek(0)
    var start_pos: int = file.get_position()

    while file.get_position() < file.get_length():
        var offset: int = file.get_position()
        var buffer: String = file.get_buffer(_BUFFER_SIZE).get_string_from_utf8()
        var find_pos: int = buffer.find(delimiter, 0)

        while find_pos >= 0:
            var file_pointer: FilePointer = FilePointer.new()
            file_pointer.start_pos = start_pos
            file_pointer.end_pos = find_pos + offset
            file_pointers.append(file_pointer)
            start_pos = find_pos + 1
            find_pos = buffer.find(delimiter, start_pos)
