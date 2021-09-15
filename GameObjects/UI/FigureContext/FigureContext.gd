extends MarginContainer

onready var health_bar = $VBoxContainer/stats/HealthBar
onready var hunger_bar = $VBoxContainer/stats/HungerBar
onready var thurst_bar = $VBoxContainer/stats/ThurstBar
onready var energy_bar = $VBoxContainer/stats/Energybar
onready var stats = $VBoxContainer/stats
onready var name_label = $VBoxContainer/Name
onready var description_label = $VBoxContainer/Description
func _ready():
	self.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_stats(info):
	print("update stats")
	var name = info["name"]
	var description = info["description"]
	name_label.text = name
	description_label.text = description
	
	if !info.has("stats"):
		print("no stats")
		stats.visible = false
	else:
		stats.visible = true
		print("show stats", info)
		var stats = info["stats"]
		var health = stats["health"]
		var thurst = stats["thurst"]
		var hunger = stats["hunger"]
		var energy = stats["energy"]
		health_bar.value = health
		thurst_bar.value = thurst
		hunger_bar.value = hunger
		energy_bar.value = energy
	

