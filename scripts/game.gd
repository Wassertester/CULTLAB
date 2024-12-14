extends Node2D
var menu_fragezeichen = false
@onready var settings: Control = $Settings
@onready var start_island_cam: Camera2D = $"start island/start_island_cam"
@onready var player: Node2D = $player/player_script
signal camera
var save: save_game = save_game.new()

func _ready():
	if ResourceLoader.exists(save_game.SAVE_PATH):
		save = load(save_game.SAVE_PATH)
	else:
		save.respawn_cords = save_game.START_POINT
		save.easy_mode = false
		# für wenn es zu kompliziert ist den defold per hand zu setzen:
		#load(res://new_save)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		if menu_fragezeichen == false:
			camera.emit("menu")
		else:
			camera.emit("player")
# pauses game and hides menu bc sonst kannst du es immernoch mit Pfeiltasten steuern
func _on_camera(camera) -> void:
	if camera == "menu":
		Engine.time_scale = 0
		menu_fragezeichen = true
		settings.visible = true
	else:
		Engine.time_scale = 1
		menu_fragezeichen = false
		settings.visible = false
	if camera == "start":
		start_island_cam.enabled = true
	else:
		start_island_cam.enabled = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	respawn()
	
func respawn():
	player.position = save.respawn_cords
	player.stop()
	camera.emit("player")
	settings.on_start_island = false
	
func start_island():
	player.position = Vector2(-14424, -130)
	player.stop()
	player.rotation = 0
	settings.on_start_island = true
