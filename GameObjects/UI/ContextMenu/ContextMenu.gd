extends Control

onready var figure_context = $Panel/FigureContext
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var visible_info
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible_info = null
	self.visible = false
	var selectables = get_tree().get_nodes_in_group("Selectable")
	for s in selectables:
		s.connect("on_select", self, "_on_selection")
		s.connect("on_unselect", self, "_on_unselection")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_selection(info):
	if info != null:
		visible_info = info["id"]
		self.visible = true
		figure_context.update_stats(info)


func _on_unselection():
	self.visible = false


func _on_Peasent_on_update_stats(info):
	if info == null:
		return
	else :
		if visible_info == info["id"]:
			figure_context.update_stats(info)
