tool
class_name ContainerManager
extends AbstractManager

signal changed()

const FMT_SCENE_TPL = "%s/container.tscn.tpl"

const FMT_PRIVATE_FOLDER = "%s/%s"
const FMT_PRIVATE_DATA = "%s/%s/%s.data"
const FMT_PRIVATE_SCENE = "%s/%s/%s_private.tscn"
const FMT_PRIVATE_SCRIPT = "%s/%s/%s_private.gd"
const FMT_PRIVATE_TPL = "%s/container_private.gd.tpl"

const FMT_IMPL_FOLDER = "%s/%s"
const FMT_IMPL_SCENE = "%s/%s/%s.tscn"
const FMT_IMPL_SCRIPT = "%s/%s/%s.gd"
const FMT_IMPL_TPL = "%s/container.gd.tpl"

var _folder: String = ""
var _private_folder: String = ""
var _tpl_folder: String = ""
var _containers: Dictionary = {}


func clean() -> void:
	_containers = {}


func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []

	if form_name == "new_container":
		var id = form["id"]
		if id.empty():
			errors.append("Container ID cannot be empty")
		elif !form["edit"] && _containers.has(id):
			errors.append("Container ID already exists")
		elif !Utils.is_id_valid(id):
			errors.append("Invalid container ID, must only contains alphanumeric characters or _, no space and starts with a letter")

		var name = form["name"]
		if name.empty():
			errors.append("Container Name cannot be empty")
		elif !Utils.is_class_name_valid(name):
			errors.append("Invalid container Name, must only contains letters and cannot contains space")

	return errors


func load_containers(folder: String, private_folder: String, tpl_folder: String) -> void:
	_folder = folder
	_private_folder = private_folder
	_tpl_folder = tpl_folder
	var dir = Directory.new()
	if dir.open(_private_folder) == OK:
		dir.list_dir_begin(true, true)
		var filename = dir.get_next()
		while filename != "":
			if dir.current_is_dir():
				var cont = _read_metadata(filename)
				_containers[cont.id] = cont
			filename = dir.get_next()
		dir.list_dir_end()
		emit_signal("changed")
	else:
		printerr("Could not read CardEngine container folder")


func containers() -> Dictionary:
	return _containers


func create_container(cont: ContainerData) -> void:
	var dir = Directory.new()
	if dir.open(_private_folder) == OK:
		dir.make_dir(cont.id)
		var private_scene = _write_private_scene(cont)
		if private_scene == "":
			return
		_write_public_scene(cont, private_scene)
		_write_metadata(cont)
		CardEngine.scan_for_new_files()
	else:
		printerr("Could not access CardEngine container folder")
		return

	_containers[cont.id] = cont
	emit_signal("changed")


func get_container(id: String) -> ContainerData:
	if !_containers.has(id):
		return null
	return _containers[id]


func update_container(modified_cont: ContainerData) -> void:
	_write_private_scene(modified_cont)
	_write_metadata(modified_cont)
	_containers[modified_cont.id] = modified_cont
	emit_signal("changed")


func open(id: String) -> void:
	CardEngine.open_scene(FMT_IMPL_SCENE % [_folder, id, id])


func delete_container(cont: ContainerData) -> void:
	if Utils.directory_remove_recursive(FMT_PRIVATE_FOLDER % [_private_folder, cont.id]):
		_containers.erase(cont.id)
		emit_signal("changed")
		CardEngine.scan_for_new_files()
	else:
		printerr("Container not accessible")


func _write_metadata(cont: ContainerData) -> void:
	var file = ConfigFile.new()
	file.set_value("meta", "id", cont.id)
	file.set_value("meta", "name", cont.name)
	file.set_value("meta", "mode", cont.mode)
	file.set_value("meta", "face_up", cont.face_up)

	# Grid data
	file.set_value("grid", "card_width", cont.grid_card_width)
	file.set_value("grid", "fixed_width", cont.grid_fixed_width)
	file.set_value("grid", "card_spacing", cont.grid_card_spacing)
	file.set_value("grid", "halign", cont.grid_halign)
	file.set_value("grid", "valign", cont.grid_valign)
	file.set_value("grid", "columns", cont.grid_columns)
	file.set_value("grid", "expand", cont.grid_expand)

	# Drag and drop data
	file.set_value("drag", "enabled", cont.drag_enabled)
	file.set_value("drag", "drop_enabled", cont.drop_enabled)

	# Path data
	file.set_value("path", "card_width", cont.path_card_width)
	file.set_value("path", "fixed_width", cont.path_fixed_width)
	file.set_value("path", "spacing", cont.path_spacing)

	# Position data
	file.set_value("position", "enabled", cont.fine_pos)
	file.set_value("position", "mode", cont.fine_pos_mode)
	file.set_value("position", "min", cont.fine_pos_min)
	file.set_value("position", "max", cont.fine_pos_max)

	# Angle data
	file.set_value("angle", "enabled", cont.fine_angle)
	file.set_value("angle", "mode", cont.fine_angle_mode)
	file.set_value("angle", "min", cont.fine_angle_min)
	file.set_value("angle", "max", cont.fine_angle_max)

	# Scale data
	file.set_value("scale", "enabled", cont.fine_scale)
	file.set_value("scale", "mode", cont.fine_scale_mode)
	file.set_value("scale", "ratio", cont.fine_scale_ratio)
	file.set_value("scale", "min", cont.fine_scale_min)
	file.set_value("scale", "max", cont.fine_scale_max)

	# Transitions data
	file.set_value("order", "duration", cont.order_duration)
	file.set_value("order", "type", cont.order_type)
	file.set_value("order", "easing", cont.order_easing)

	file.set_value("in", "duration", cont.in_duration)
	file.set_value("in", "type", cont.in_type)
	file.set_value("in", "easing", cont.in_easing)

	file.set_value("out", "duration", cont.out_duration)
	file.set_value("out", "type", cont.out_type)
	file.set_value("out", "easing", cont.out_easing)

	# Animations data
	file.set_value("anim", "interactive", cont.interactive)
	file.set_value("anim", "id", cont.anim)

	file.set_value("adjust", "mode", cont.adjust_mode)
	file.set_value("adjust", "pos_mode_x", cont.adjust_pos_x_mode)
	file.set_value("adjust", "pos_mode_y", cont.adjust_pos_y_mode)
	file.set_value("adjust", "pos", cont.adjust_pos)
	file.set_value("adjust", "scale_mode_x", cont.adjust_scale_x_mode)
	file.set_value("adjust", "scale_mode_y", cont.adjust_scale_y_mode)
	file.set_value("adjust", "scale", cont.adjust_scale)
	file.set_value("adjust", "rot_mode", cont.adjust_rot_mode)
	file.set_value("adjust", "rot", cont.adjust_rot)

	file.save(FMT_PRIVATE_DATA % [_private_folder, cont.id, cont.id])


func _write_private_scene(cont: ContainerData) -> String:
	var dir = Directory.new()
	if !dir.dir_exists(FMT_PRIVATE_FOLDER % [_private_folder, cont.id]):
		dir.make_dir_recursive(FMT_PRIVATE_FOLDER % [_private_folder, cont.id])

	var tpl_path = FMT_PRIVATE_TPL % _tpl_folder
	var script_path = FMT_PRIVATE_SCRIPT % [_private_folder, cont.id, cont.id]
	var params = {
		"container_id": cont.id,
		"container_name": cont.name,
		"mode": _translate_mode(cont.mode),
		"face_up": _translate_bool(cont.face_up),
		"grid_width": cont.grid_card_width,
		"grid_fixed": _translate_bool(cont.grid_fixed_width),
		"grid_spacing_h": cont.grid_card_spacing.x,
		"grid_spacing_v": cont.grid_card_spacing.y,
		"grid_align_h": _translate_align(cont.grid_halign),
		"grid_align_v": _translate_align(cont.grid_valign),
		"grid_columns": cont.grid_columns,
		"grid_expand": _translate_bool(cont.grid_expand),
		"drag_enabled": _translate_bool(cont.drag_enabled),
		"drop_enabled": _translate_bool(cont.drop_enabled),
		"path_width": cont.path_card_width,
		"path_fixed": _translate_bool(cont.path_fixed_width),
		"path_spacing": cont.path_spacing,
		"pos_enabled": _translate_bool(cont.fine_pos),
		"pos_mode": _translate_fine_tune_mode(cont.fine_pos_mode),
		"pos_range_min_h": cont.fine_pos_min.x,
		"pos_range_min_v": cont.fine_pos_min.y,
		"pos_range_max_h": cont.fine_pos_max.x,
		"pos_range_max_v": cont.fine_pos_max.y,
		"angle_enabled": _translate_bool(cont.fine_angle),
		"angle_mode": _translate_fine_tune_mode(cont.fine_angle_mode),
		"angle_range_min": cont.fine_angle_min,
		"angle_range_max": cont.fine_angle_max,
		"scale_enabled": _translate_bool(cont.fine_scale),
		"scale_mode": _translate_fine_tune_mode(cont.fine_scale_mode),
		"scale_ratio": _translate_ratio_mode(cont.fine_scale_ratio),
		"scale_range_min_h": cont.fine_scale_min.x,
		"scale_range_min_v": cont.fine_scale_min.y,
		"scale_range_max_h": cont.fine_scale_max.x,
		"scale_range_max_v": cont.fine_scale_max.y,
		"order_duration": cont.order_duration,
		"order_type": _translate_trans_type(cont.order_type),
		"order_easing": _translate_trans_easing(cont.order_easing),
		"in_duration": cont.in_duration,
		"in_type": _translate_trans_type(cont.in_type),
		"in_easing": _translate_trans_easing(cont.in_easing),
		"out_duration": cont.out_duration,
		"out_type": _translate_trans_type(cont.out_type),
		"out_easing": _translate_trans_easing(cont.out_easing),
		"interactive": _translate_bool(cont.interactive),
		"anim": cont.anim,
		"adjust_mode": cont.adjust_mode,
		"adjust_pos_x_mode": cont.adjust_pos_x_mode,
		"adjust_pos_y_mode": cont.adjust_pos_y_mode,
		"adjust_pos_x": cont.adjust_pos.x,
		"adjust_pos_y": cont.adjust_pos.y,
		"adjust_scale_x_mode": cont.adjust_scale_x_mode,
		"adjust_scale_y_mode": cont.adjust_scale_y_mode,
		"adjust_scale_x": cont.adjust_scale.x,
		"adjust_scale_y": cont.adjust_scale.y,
		"adjust_rot_mode": cont.adjust_rot_mode,
		"adjust_rot": cont.adjust_rot
	}
	Utils.copy_template(tpl_path, script_path, params)

	tpl_path = FMT_SCENE_TPL % _tpl_folder
	var scene_path = FMT_PRIVATE_SCENE % [_private_folder, cont.id, cont.id]
	params = {
		"container_name": "%sPrivate" % cont.name,
		"parent_scene": "res://addons/cardengine/container/abstract_container.tscn",
		"script_path": script_path,
	}
	Utils.copy_template(tpl_path, scene_path, params)

	return scene_path


func _write_public_scene(cont: ContainerData, private_scene: String) -> void:
	var dir = Directory.new()
	if dir.dir_exists(FMT_IMPL_FOLDER % [_folder, cont.id]):
		return
	else:
		dir.make_dir_recursive(FMT_IMPL_FOLDER % [_folder, cont.id])

	var tpl_path = FMT_IMPL_TPL % _tpl_folder
	var script_path = FMT_IMPL_SCRIPT % [_folder, cont.id, cont.id]
	var params =  {
		"container_id": cont.id,
		"container_name": cont.name}
	Utils.copy_template(tpl_path, script_path, params)

	tpl_path = FMT_SCENE_TPL % _tpl_folder
	var scene_path = FMT_IMPL_SCENE % [_folder, cont.id, cont.id]
	params = {
		"container_name": cont.name,
		"parent_scene": private_scene,
		"script_path": script_path}
	Utils.copy_template(tpl_path, scene_path, params)


func _read_metadata(id: String) -> ContainerData:
	var file = ConfigFile.new()

	var err = file.load(FMT_PRIVATE_DATA % [_private_folder, id, id])
	if err != OK:
		printerr("Error while loading container")
		return null

	var cont = ContainerData.new(
		file.get_value("meta", "id"  , ""),
		file.get_value("meta", "name", ""))

	cont.mode = file.get_value("meta", "mode", "grid")
	cont.face_up = file.get_value("meta", "face_up", true)

	# Grid data
	cont.grid_card_width = file.get_value("grid", "card_width", 200)
	cont.grid_fixed_width = file.get_value("grid", "fixed_width", true)
	cont.grid_card_spacing = file.get_value("grid", "card_spacing", Vector2(1.0, 1.0))
	cont.grid_halign = file.get_value("grid", "halign", "center")
	cont.grid_valign = file.get_value("grid", "valign", "middle")
	cont.grid_columns = file.get_value("grid", "columns", 3)
	cont.grid_expand = file.get_value("grid", "expand", true)

	# Drag and drop data
	cont.drag_enabled = file.get_value("drag", "enabled", false)
	cont.drop_enabled = file.get_value("drag", "drop_enabled", false)

	# Path data
	cont.path_card_width = file.get_value("path", "card_width", 200)
	cont.path_fixed_width = file.get_value("path", "fixed_width", true)
	cont.path_spacing = file.get_value("path", "spacing", 1.0)

	# Position data
	cont.fine_pos = file.get_value("position", "enabled", false)
	cont.fine_pos_mode = file.get_value("position", "mode", "linear")
	cont.fine_pos_min = file.get_value("position", "min", Vector2(0.0, 0.0))
	cont.fine_pos_max = file.get_value("position", "max", Vector2(0.0, 0.0))

	# Angle data
	cont.fine_angle = file.get_value("angle", "enabled", false)
	cont.fine_angle_mode = file.get_value("angle", "mode", "linear")
	cont.fine_angle_min = file.get_value("angle", "min", 0.0)
	cont.fine_angle_max = file.get_value("angle", "max", 0.0)

	# Scale data
	cont.fine_scale = file.get_value("scale", "enabled", false)
	cont.fine_scale_mode = file.get_value("scale", "mode", "linear")
	cont.fine_scale_ratio = file.get_value("scale", "ratio", "keep")
	cont.fine_scale_min = file.get_value("scale", "min", Vector2(0.0, 0.0))
	cont.fine_scale_max = file.get_value("scale", "max", Vector2(0.0, 0.0))

	# Transitions data
	cont.order_duration = file.get_value("order", "duration", 0.0)
	cont.order_type = file.get_value("order", "type", "linear")
	cont.order_easing = file.get_value("order", "easing", "in")

	cont.in_duration = file.get_value("in", "duration", 0.0)
	cont.in_type = file.get_value("in", "type", "linear")
	cont.in_easing = file.get_value("in", "easing", "in")

	cont.out_duration = file.get_value("out", "duration", 0.0)
	cont.out_type = file.get_value("out", "type", "linear")
	cont.out_easing = file.get_value("out", "easing", "in")

	cont.interactive = file.get_value("anim", "interactive", true)
	cont.anim = file.get_value("anim", "id", "none")

	cont.adjust_mode = file.get_value("adjust", "mode", "focused")
	cont.adjust_pos_x_mode = file.get_value("adjust", "pos_mode_x", "disabled")
	cont.adjust_pos_y_mode = file.get_value("adjust", "pos_mode_y", "disabled")
	cont.adjust_pos = file.get_value("adjust", "pos", Vector2(0.0, 0.0))
	cont.adjust_scale_x_mode = file.get_value("adjust", "scale_mode_x", "disabled")
	cont.adjust_scale_y_mode = file.get_value("adjust", "scale_mode_y", "disabled")
	cont.adjust_scale = file.get_value("adjust", "scale", Vector2(0.0, 0.0))
	cont.adjust_rot_mode = file.get_value("adjust", "rot_mode", "disabled")
	cont.adjust_rot = file.get_value("adjust", "rot", 0.0)

	return cont


func _translate_mode(mode: String) -> String:
	match mode:
		"grid":
			return "LayoutMode.GRID"
		"path":
			return "LayoutMode.PATH"
		_:
			return "LayoutMode.GRID"


func _translate_bool(val: bool) -> String:
	if val:
		return "true"
	else:
		return "false"


func _translate_align(align: String) -> String:
	match align:
		"left":
			return "HALIGN_LEFT"
		"center":
			return "HALIGN_CENTER"
		"right":
			return "HALIGN_RIGHT"
		"top":
			return "VALIGN_TOP"
		"middle":
			return "VALIGN_CENTER"
		"bottom":
			return "VALIGN_BOTTOM"
		_:
			return "0"


func _translate_fine_tune_mode(mode: String) -> String:
	match mode:
		"linear":
			return "FineTuningMode.LINEAR"
		"symmetric":
			return "FineTuningMode.SYMMETRIC"
		"random":
			return "FineTuningMode.RANDOM"
		_:
			return ""


func _translate_ratio_mode(mode: String) -> String:
	match mode:
		"keep":
			return "AspectMode.KEEP"
		"ignore":
			return "AspectMode.IGNORE"
		_:
			return ""


func _translate_trans_type(type: String) -> String:
	match type:
		"linear":
			return "Tween.TRANS_LINEAR"
		"sine":
			return "Tween.TRANS_SINE"
		"quint":
			return "Tween.TRANS_QUINT"
		"quart":
			return "Tween.TRANS_QUART"
		"quad":
			return "Tween.TRANS_QUAD"
		"expo":
			return "Tween.TRANS_EXPO"
		"elastic":
			return "Tween.TRANS_ELASTIC"
		"cubic":
			return "Tween.TRANS_CUBIC"
		"circ":
			return "Tween.TRANS_CIRC"
		"bounce":
			return "Tween.TRANS_BOUNCE"
		"back":
			return "Tween.TRANS_BACK"
		_:
			return ""


func _translate_trans_easing(easing: String) -> String:
	match easing:
		"in":
			return "Tween.EASE_IN"
		"out":
			return "Tween.EASE_OUT"
		"in_out":
			return "Tween.EASE_IN_OUT"
		"out_in":
			return "Tween.EASE_OUT_IN"
		_:
			return ""
