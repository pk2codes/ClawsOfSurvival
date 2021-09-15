extends Node2D

onready var hungry = $Hungry
onready var thursty = $Thursty
onready var tired = $Tired



func hide_all():
	var all = [hungry, thursty, tired]
	for e in all:
		e.visible = false

func _ready():
	hide_all()

func show_hungry():
	hungry.visible = true

func show_thursty():
	thursty.visible = true
	
func show_tired():
	tired.visible = true
	

