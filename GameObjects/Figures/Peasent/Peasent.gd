extends Node2D

onready var character_select_box = $CharacterSelectBox
onready var area = $Area2D
onready var animation_player = $KinematicBody2D/AnimationPlayer
onready var movable = $Movable
onready var selectable = $Selectable
onready var mind = $Mind

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

enum STATE {
	ALIVE, DEAD
}

var state


func _ready():
	self.state = STATE.ALIVE 
	movable.character = self
	movable.speed = self.info["stats"]["speed"]
	

			
func _handle_animation():
	if self.state == STATE.DEAD:
		animation_player.play("Dead")
	

func _update_state():
	if self.info["stats"]["hunger"] <= 0:
		self.state = STATE.DEAD


var update_interval = 1

func _update_needs(delta):
	self.info["stats"]["hunger"] -= (delta * 3)
	self.info["stats"]["thurst"] -= (delta / 10 )
	self.info["stats"]["energy"] -= (delta / 90 )
	if update_interval <= 0:
		emit_signal("on_update_stats", info)
		update_interval = 2
		mind.think(self.info["stats"])
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




func _on_Mind_new_target(target):
	movable.move_to_pos(target)
