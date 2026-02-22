class_name FileMetadata
extends RefCounted89
## A class which stores file metadata.

var length: int
var file_path: String
var file_pointers: Array[FilePointer]


func _to_string() -> String:
    if len(file_pointers) <= 10:
        return "{class_name}(file_path=\"{file_path}\", length={length}, file_pointers={file_pointers}) #{id}".format({
            "class_name": self.get_class_name(),
            "file_path": file_path,
            "length": length,
            "file_pointers": file_pointers,
            "id": self.get_instance_id(),
        })

    return "{class_name}(file_path=\"{file_path}\", length={length}, len(file_pointers)={file_pointers}) #{id}".format({
            "class_name": self.get_class_name(),
            "file_path": file_path,
            "length": length,
            "file_pointers": len(file_pointers),
            "id": self.get_instance_id(),
        })


func get_random_file_value() -> String:
    var file_pointer: FilePointer = file_pointers.pick_random()
    var file: FileAccess = FileAccess.open(
        file_path,
        FileAccess.ModeFlags.READ,
    )
    file.seek(file_pointer.start_pos)
    return file.get_buffer(file_pointer.length).get_string_from_utf8()
