class_name FilePointerReader
extends RefCounted89
## A reader which creates `FilePointer´ objects.

const _BUFFER_SIZE: int = 10


static func scan(
        file: FileAccess,
        delimiter: int,
        file_pointers: Array[FilePointer],
) -> void:
    # Set the file cursor to the beginning of the file.
    file.seek(0)
    var start_pos: int = file.get_position()

    while file.get_position() < file.get_length():
        var offset: int = file.get_position()
        var buffer: PackedByteArray = file.get_buffer(_BUFFER_SIZE)
        var find_pos: int = buffer.find(delimiter, 0)

        while find_pos >= 0:
            var end_pos: int = offset + find_pos
            var file_pointer: FilePointer = FilePointer.new(
                start_pos,
                end_pos,
            )
            file_pointers.append(file_pointer)
            start_pos = end_pos + 1
            find_pos = buffer.find(delimiter, find_pos + 1)
