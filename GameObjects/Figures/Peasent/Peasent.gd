extends Node2D

onready var character_select_box = $CharacterSelectBox
onready var area = $Area2D
onready var animation_player = $KinematicBody2D/AnimationPlayer
onready var movable = $Movable
onready var status = $Status
onready var selectable = $Selectable

signal on_update_stats

var peasentName = "Ulrich"

var info = {
	"id": "123543543543543",
	"name": "Ulrich",
	"description": "An ugly humanoid",
	"stats": {
		"health": 100,
		"thurst": 100,
		"hunger": 100,
		"energy": 100,
		"speed": 130
	}
}

var needs = {
	"hungry": false,
	"thursty": false,
	"tired": false
}

enum STATE {
	ALIVE, DEAD
}

var state


func _ready():
	self.state = STATE.ALIVE 
	movable.character = self
	movable.speed = self.info["stats"]["speed"]
func _show_needs(): 
	for need in self.needs:
		if needs["thursty"]:
			status.show_thursty()
		elif needs["hungry"]:
			status.show_hungry()
		elif needs["tired"]:
			status.show_tired()
		else:
			status.hide_all()
			
func _handle_animation():
	if self.state == STATE.DEAD:
		animation_player.play("Dead")
		status.hide_all()
	_show_needs()
	

func _update_state():
	if self.info["stats"]["hunger"] <= 0:
		self.state = STATE.DEAD

func _update_status():
	if self.info["stats"]["hunger"] < 50:
		needs["hungry"] = true
	if self.info["stats"]["thurst"] < 40:
		needs["thurst"] = true
	if self.info["stats"]["energy"] < 20:
		needs["tired"] = true

var update_interval = 2

func _update_needs(delta):
	self.info["stats"]["hunger"] -= (delta / 30 )
	self.info["stats"]["thurst"] -= (delta / 10 )
	self.info["stats"]["energy"] -= (delta / 90 )
	if update_interval <= 0:
		emit_signal("on_update_stats", info)
		update_interval = 2
		_update_status()
	else: 
		update_interval = update_interval - delta
	
func _process(delta):
	_update_needs(delta)
	_update_state()
	_handle_animation()
	
# set the position of this char (currently used by movable)
func set_position(pos):
	if self.state == STATE.ALIVE:
		self.position = pos


