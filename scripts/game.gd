# wenn als global gecalled, kann man keine conections zu anderen noten benutzen
extends Node2D
var menu_fragezeichen = false
@onready var settings: Control = $Settings
@onready var start_island_cam: Camera2D = $"start island/start_island_cam"
@onready var player: CharacterBody2D = $player/player_script
signal camera
var save_state: save_game = save_game.new()

func _ready():
	if ResourceLoader.exists(save_game.SAVE_PATH):
		save_state = load(save_game.SAVE_PATH)
		if save_state.restart == true:
			save_state.restart = false
			go_to_checkpoint()
	else:
		save_state.respawn_cords = save_game.START_POINT
	#player.position = player.position
func save():
	save_state.save()

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
	go_to_checkpoint()
	
func respawn():
	save_state.restart = true
	save()
	get_tree().reload_current_scene()

func go_to_checkpoint():
	player.position = save_state.respawn_cords
	player.stop()
	camera.emit("player")

func start_island():
	player.position = Vector2(-14424, -130)#-14424  -130
	player.stop()
	player.rotation = 0
	settings.menu_button = true
	
func player_position():
	return player.position
