class_name FileMetadata
extends RefCounted
## A class which stores file metadata.

var length: int
var file_pointers: Array[FilePointer]


func _to_string() -> String:
    if len(file_pointers) <= 10:
        return "FileMetadata(length={length}, file_pointers={file_pointers}) #{id}".format({
            "length": length,
            "file_pointers": file_pointers,
            "id": self.get_instance_id(),
        })

    return "FileMetadata(length={length}, len(file_pointers)={file_pointers}) #{id}".format({
            "length": length,
            "file_pointers": len(file_pointers),
            "id": self.get_instance_id(),
        })
