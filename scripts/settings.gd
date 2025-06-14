extends Control
@onready var settins_cam: Camera2D = $settings_cam
@onready var player_script: CharacterBody2D = $"../player/player_script"
@onready var fullscreen_windowed: OptionButton = $MarginContainer/VBoxContainer/Fullscreen_windowed
@onready var game: Node2D = $".."
var menu_button = false
signal setting_changed

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)
	setting_changed.emit()

func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
	setting_changed.emit()

func _on_resolution_item_selected(index: int) -> void:
	setting_changed.emit()
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
	setting_changed.emit()
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

func _on_game_camera(str) -> void:
	if str == "menu":
		settins_cam.enabled = true
	else:
		settins_cam.enabled = false

func _on_resume_pressed() -> void:
	if menu_button == true:
		game.camera.emit("start")
	else:
		game.camera.emit("player")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_area_2d_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	game.camera.emit("menu")
	game.start_island()

func _on_restart_pressed() -> void:
	game.respawn()

# wenn erase butten gedrückt geht pop up auf
@onready var confirmation: ConfirmationDialog = $MarginContainer/CenterContainer/ConfirmationDialog
func _on_erase_pressed() -> void:
	confirmation.visible = true

# erase save file
func _on_confirmation_dialog_confirmed() -> void:
	#print ("Thanos snap")
	DirAccess.remove_absolute(save_game.SAVE_PATH)
	game.camera.emit("start")
	game.save_state.respawn_cords = save_game.START_POINT
	game.start_island()

func _on_control_mode_item_selected(index: int) -> void:
	setting_changed.emit()
