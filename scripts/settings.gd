extends Control
@onready var settins_cam: Camera2D = $settings_cam
@onready var player_script: CharacterBody2D = $"../player/player_script"
@onready var game_ref: Node2D = $".."
@onready var fullscreen_windowed: OptionButton = $MarginContainer/VBoxContainer/Fullscreen_windowed

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)

func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))

const Window_mode_array : Array[String] = [
	"Fullscreen",
	"Window",
	"Borderless Window",
	"Borderless Fullscreen"
]
func _ready():
	fullscreen_windowed.item_selected.connect(on_window_mode_selected)
	
func on_window_mode_selected(index : int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

var dont_schow_confirmation = false
func _on_game_camera(str) -> void:
	if str == "menu":
		print(Game.save.easy_mode)
		# setting easy mode toggel to right position
		dont_schow_confirmation = true
		check_button.disabled = false
		check_button.button_pressed = Game.save.easy_mode
		check_button.disabled = Game.save.easy_mode
		dont_schow_confirmation = false
			
		settins_cam.enabled = true
	else:
		settins_cam.enabled = false
		
var on_start_island = true
func _on_resume_pressed() -> void:
	if on_start_island == true:
		game_ref.camera.emit("start")
	else:
		game_ref.camera.emit("player")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_area_2d_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	game_ref.camera.emit("menu")
	game_ref.start_island()

func _on_restart_pressed() -> void:
	game_ref.respawn()

# wenn erase butten gedrückt geht pop up auf
@onready var confirmation: ConfirmationDialog = $MarginContainer/CenterContainer/ConfirmationDialog
func _on_erase_pressed() -> void:
	confirmation.visible = true

# erase save file
func _on_confirmation_dialog_confirmed() -> void:
	#print ("Thanos snap")
	DirAccess.remove_absolute(save_game.SAVE_PATH)
	game_ref.camera.emit("start")
	Game._ready()
	game_ref.start_island()

# pop up für easy mode
@onready var easy_mode_confirmation: ConfirmationDialog = $MarginContainer/CenterContainer/easy_mode_confirmation
@onready var check_button: CheckButton = $MarginContainer/VBoxContainer/CheckButton
func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if dont_schow_confirmation:
			dont_schow_confirmation = false
		else:
			easy_mode_confirmation.visible = true
	
	
	
func _on_easy_mode_confirmation_confirmed() -> void:
	check_button.disabled = true
	Game.save.easy_mode = true
	Game.save.save()


func _on_easy_mode_confirmation_canceled() -> void:
	check_button.button_pressed = false
