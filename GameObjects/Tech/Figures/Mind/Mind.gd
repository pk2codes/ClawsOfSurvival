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

onready var navigation: Navigation2D = get_tree().get_root().find_node("Navigation", true, false)

func _drink():
	var type = "drinking"
	if plan_map[type] == true:
		var drinks = FoodDb.get_registered_drinks()
		var closest_drink = navigation.get_closest_item(drinks, self.position)
		if closest_drink != null:
			var pos = closest_drink.position
			_set_target(type, pos)
		else: 
			print("cannot find a drink!")
	else:
		_check_reach_target_process(type)
	
func _eat():
	pass

func _sleep():
	pass

func _set_target(type, pos):
	plan_map[type] = {
		"target_pos": pos,
		"watchdog": 10,
	}
	emit_signal("new_target", pos)

var last_pos
func _check_reach_target_process(type):
	var target_pos = plan_map[type]["target_pos"]
	var watchdog = plan_map[type]["watchdog"]
	if (global_position.x == target_pos.x && global_position.y == target_pos.y) || watchdog > 10:
		plan_map[type] = null
		last_pos = null
	else:
		last_pos = global_position
		if (last_pos.x == global_position.x && last_pos.y == global_position.y):
			plan_map[type]["watchdog"] += 1

func _wander():
	var type = "wandering"
	if plan_map[type] == null:
		var pos = MapManager.get_random_position_near_to(global_position, 180)
		_set_target(type, pos)
	else:
		_check_reach_target_process(type)

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
