tool
extends Reference
class_name ContainerData

var id: String = ""
var name: String = ""
var visual: String = ""

func _init(id: String, name: String, visual: String = ""):
	self.id = id
	self.name = name
	self.visual = visual
