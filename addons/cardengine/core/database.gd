tool
extends Reference
class_name CardDatabase

var id  : String = ""
var name: String = ""
var path: String = ""

func _init(id: String, name: String, path: String):
	self.id   = id
	self.name = name
	self.path = path
