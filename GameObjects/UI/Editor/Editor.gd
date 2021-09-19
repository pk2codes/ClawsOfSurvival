extends Control

onready var editor_panel = $EditorPanel
onready var editor_btn = $EditorButton
onready var item_list = $EditorPanel/ItemList
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal on_change

var y_sort: YSort

var pressed = null

func _on_icon_pressed(item_factory):
	pressed = item_factory

# Called when the node enters the scene tree for the first time.
func _ready():
	y_sort = get_tree().get_root().find_node("YSort", true, false)
	var foodFactories = FoodDb.get_all_foods()
	for fac in foodFactories:
		var name = fac.name
		var label = Label.new()
		label.text = name
		item_list.add_child(label)
		
		var icon: TextureButton = fac.create_icon()
		item_list.add_child(icon)
		icon.connect("pressed", self, "_on_icon_pressed", [fac])



func _input(event):
	if not event.is_action_pressed("click_left"):
		return
	if pressed == null:
		return
	var pos = get_local_mouse_position()
	var item = pressed.create_instance()
	item.position = get_local_mouse_position()
	if pressed.type == FoodDb.FoodType.DRINK:
		FoodDb.register_placed_drink(item)
	elif pressed.type == FoodDb.FoodType.FOOD:
		FoodDb.register_placed_food(item)
	y_sort.add_child(item)
	pressed = null
	emit_signal("on_change")
	
func _on_EditorButton_pressed():
	editor_panel.visible = !editor_panel.visible
	if editor_panel.visible:
		editor_btn.text = "X"
	else: 
		editor_btn.text = "Editor"
