extends Node2D
var menu_fragezeichen = false
@onready var resume: Button = $Settings/MarginContainer/VBoxContainer/resume
@onready var start_island_cam: Camera2D = $"start island/start_island_cam"
@onready var player: Node2D = $player/player_script
signal camera
var respawn_cords = Vector2(-800, 2)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		if menu_fragezeichen == false:
			camera.emit("menu")
		else:
			camera.emit("player")
# pauses game when menu is opened
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

func _on_checkpoints_checkpoint_reached(Position: Vector2) -> void:
	respawn_cords = Position

func _on_area_2d_body_entered(body: Node2D) -> void:
	camera.emit("player")
	respawn()
	
func respawn():
	player.position = respawn_cords
	player.stop()
