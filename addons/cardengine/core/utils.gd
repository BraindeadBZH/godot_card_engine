tool
extends Node
class_name UtilsInstance

func is_id_valid(id: String) -> bool:
	return is_valid_for_regex(id, "^[a-zA-Z]+([a-zA-Z0-9]|_)*$")

func is_db_file(filename: String) -> bool:
	return is_valid_for_regex(filename, "^[a-zA-Z]+([a-zA-Z0-9]|_)*\\.data$")

func is_valid_for_regex(value: String, regex: String) -> bool:
	var validation = RegEx.new()
	validation.compile(regex)
	if validation.search(value) != null:
		return true
	else:
		return false

func directory_remove_recursive(path: String) -> bool:
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, false)
		var filename = dir.get_next()
		while filename != "":
			if dir.current_is_dir():
				directory_remove_recursive("%s/%s" % [path, filename])
			else:
				dir.remove(filename)
			filename = dir.get_next()
		dir.list_dir_end()
		dir.remove(".")
		return true
	else:
		return false
