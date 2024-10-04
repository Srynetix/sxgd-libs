extends RefCounted
## File extensions.
##
## Additional methods around files/folders functionalities.

## Represents a path: a directory or a file.
class FilePath:
	extends RefCounted

	## Path type.
	enum Type {
		## Directory.
		DIRECTORY = 0,
		## File.
		FILE = 1
	}

	## File name / Directory name.
	var name := "" as String
	## Concrete path.
	var path := "" as String
	## Path type.
	var type := Type.DIRECTORY as int

	## Path to string.
	static func type_to_string(type: Type) -> String:
		match type:
			Type.DIRECTORY:
				return "Directory"
			Type.FILE:
				return "File"

		assert(false, "Unsupported path type")
		return ""

	func _init(name_: String, path_: String, type_: int) -> void:
		name = name_
		path = path_
		type = type_

	## Path is a file?
	func is_file() -> bool:
		return type == Type.FILE

	## Path is a directory?
	func is_directory() -> bool:
		return type == Type.DIRECTORY

	func _to_string() -> String:
		return "%s (%s) (%s)" % [name, type_to_string(type), path]

## List all files in a directory.
static func list_files_in_directory(path: String, filters: Array[String]) -> Array[FilePath]:
	var files: Array[FilePath] = []
	var directory := DirAccess.open(path)
	directory.list_dir_begin()
	var file_name := directory.get_next()

	while file_name != "":
		# Edge case: ignore . & ..
		if file_name in [".", ".."]:
			file_name = directory.get_next()
			continue

		var dir_or_file := FilePath.Type.DIRECTORY as int
		var file_path := path
		if !path.ends_with("/"):
			file_path += "/"
		file_path += file_name

		if directory.file_exists(file_path):
			dir_or_file = FilePath.Type.FILE

		var collect := true
		if dir_or_file == FilePath.Type.FILE:
			if len(filters) > 0:
				collect = false
				for filter in filters:
					collect = collect || file_name.match(filter)

		if collect:
			files.append(FilePath.new(file_name, file_path, dir_or_file))
		file_name = directory.get_next()

	return files
