class_name FileMetadata
extends RefCounted89
## A class which stores file metadata.

var length: int
var file_pointers: Array[FilePointer]


func _to_string() -> String:
    if len(file_pointers) <= 10:
        return "{class_name}(length={length}, file_pointers={file_pointers}) #{id}".format({
            "class_name": self.get_class_name(),
            "length": length,
            "file_pointers": file_pointers,
            "id": self.get_instance_id(),
        })

    return "{class_name}(length={length}, len(file_pointers)={file_pointers}) #{id}".format({
            "class_name": self.get_class_name(),
            "length": length,
            "file_pointers": len(file_pointers),
            "id": self.get_instance_id(),
        })
