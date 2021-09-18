extends Node2D

onready var status = $Status

signal new_target

var tolerance = 50
var plan_map = {
	"eating": null,
	"sleeping": null,
	"drinking": null,
	"wandering": null
}

func _drink():
	pass
	
func _eat():
	pass

func _sleep():
	pass

var walking_watchdog = 0
func _wander():
	if plan_map["wandering"] == null:
		var pos = MapManager.get_random_position_near_to(global_position, 180)
		plan_map["wandering"] = {
			"target_pos": pos
		}
		emit_signal("new_target", pos)
	else:
		var target_pos = plan_map["wandering"]["target_pos"]
		if (global_position.x == target_pos.x && global_position.y == target_pos.y) || walking_watchdog > 10:
			plan_map["wandering"] = null
			walking_watchdog = 0
		else:
			print("my pos", global_position, target_pos)
			walking_watchdog += 1

func _ready():
	status.hide_all()

func _execute_plans():
	var drink_plan = plan_map["drinking"]
	var eat_plan = plan_map["eating"]	
	var sleep_plan = plan_map["sleeping"]
	var wandering_plan = plan_map["wandering"]
	
	if drink_plan != null:
		_drink()
	elif eat_plan != null:
		_eat()
	elif sleep_plan != null:
		_sleep()
	else :
		_wander()

# make plans
func think(stats):
	var hunger = stats["hunger"]
	var thurst = stats["thurst"]
	var energy = stats["energy"]
	if (hunger < tolerance):
		plan_map["eating"] = true
	elif (thurst < tolerance):
		plan_map["drinking"] = true
	elif (energy < tolerance):
		plan_map["sleeping"] = true
	_show_plans()
	_execute_plans()

func _show_plans(): 
	if plan_map["drinking"] != null:
		status.show_thursty()
	elif plan_map["eating"] != null:
		status.show_hungry()
	elif plan_map["sleeping"] != null:
		status.show_tired()
	else:
		status.hide_all()
