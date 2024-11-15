extends Node2D
var menu_fragezeichen = false
@onready var resume: Button = $Settings/MarginContainer/VBoxContainer/resume
@onready var start_island_cam: Camera2D = $"start island/start_island_cam"
signal camera

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		if menu_fragezeichen == false:
			camera.emit("menu")
		else:
			camera.emit("player")

func _on_camera(str) -> void:
	if str == "menu":
		Engine.time_scale = 0
		menu_fragezeichen = true
	else:
		Engine.time_scale = 1
		menu_fragezeichen = false
		
	if str == "start":
		start_island_cam.enabled = true
	else:
		start_island_cam.enabled = false
