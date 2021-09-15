extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var navigation: Navigation2D = get_tree().get_root().find_node("Navigation", true, false)

var speed = 130
var character
func _ready():
	pass

func move_to_pos():
	if character == null:
		print("ERR: Need character assigned to move")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var path = []

func _process(delta):
	var walk_distance = character.info["stats"]["speed"] * delta
	move_along_path(walk_distance)


# The "click" event is a custom input action defined in
# Project > Project Settings > Input Map tab.
func _unhandled_input(event):
	if not event.is_action_pressed("click_right"):
		return
	if character.selectable.is_selected:
		var pos = character.transform.xform(get_local_mouse_position())
		_update_navigation_path(transform.xform(character.position), pos)

func move_along_path(distance):
	var last_point = character.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			character.set_position(last_point.linear_interpolate(path[0], distance / distance_between_points))
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	character.set_position(last_point)
	set_process(false)


func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = navigation.get_simple_path(start_position, end_position, true)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	path.remove(0)
	set_process(true)
