extends Node2D

onready var character_select_box = $CharacterSelectBox
onready var area2d = $Area2D
signal on_select
signal on_unselect

func _ready():
	add_to_group("Selectable")
	area2d.connect("input_event", self, "_on_Area2D_input_event")


var is_selected

func _on_select():
	character_select_box.visible = true
	self.is_selected = true
	emit_signal("on_select", self.get_parent().info)
	
func _on_unselect():
	self.is_selected = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			character_select_box.visible = false
			_on_unselect()
			emit_signal("on_unselect")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_on_select()
