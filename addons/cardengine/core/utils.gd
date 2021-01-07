tool
class_name UtilsInstance
extends Node


func is_id_valid(id: String) -> bool:
	return is_valid_for_regex(id, "^[a-zA-Z]+([a-zA-Z0-9]|_)*$")


func is_class_name_valid(name: String) -> bool:
	return is_valid_for_regex(name, "^[a-zA-Z]*$")


func is_db_file(filename: String) -> bool:
	return is_valid_for_regex(filename, "^[a-zA-Z]+([a-zA-Z0-9]|_)*\\.data$")


func is_anim_file(filename: String) -> bool:
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


func copy_template(src_path: String, dst_path: String, params: Dictionary) -> bool:
	var src_file = File.new()
	var dst_file = File.new()

	if src_file.open(src_path, File.READ) != OK:
		printerr("Cannot open template file '%'" % src_path)
		return false

	if dst_file.open(dst_path, File.WRITE) != OK:
		printerr("Cannot open destination file '%'" % dst_path)
		return false

	while !src_file.eof_reached():
		var line = src_file.get_line()
		dst_file.store_line(line.format(params))

	src_file.close()
	dst_file.close()

	return true


func delete_all_children(node: Node) -> void:
	if node == null:
		return

	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func shift_elt_left(arr: Array, idx: int) -> void:
	var elt = arr[idx]
	arr.remove(idx)
	arr.insert(idx-1, elt)

func shift_elt_right(arr: Array, idx: int) -> void:
	var elt = arr[idx]
	arr.remove(idx)
	arr.insert(idx+1, elt)
