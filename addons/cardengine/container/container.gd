tool
extends Reference
class_name ContainerData

var id: String = ""
var name: String = ""
var visual: String = ""
var db: String = ""
var filters: Array = []

func _init(id: String, name: String, visual: String = "", db: String = "", filters: Array = []):
	self.id = id
	self.name = name
	self.visual = visual
	self.db = db
	self.filters = filters
