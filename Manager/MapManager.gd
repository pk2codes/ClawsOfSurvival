extends Node

var WIDTH = 640
var HEIGHT = 360


func get_random_position_near_to(pos, range_to_pos):
	var rng = RandomNumberGenerator.new()
	rng.seed = OS.get_ticks_msec()
	var x_min = pos.x - range_to_pos
	var x_max = pos.x + range_to_pos
	var y_min = pos.y - range_to_pos
	var y_max = pos.y + range_to_pos
	if x_min < 0:
		x_min = 0
	if y_min < 0:
		y_min = 0
	if x_max >= WIDTH:
		x_max = WIDTH
	if y_max >=HEIGHT:
		y_max = HEIGHT
	return Vector2(
		rng.randi_range(x_min, x_max),
		rng.randi_range(y_min, y_max)
	)
