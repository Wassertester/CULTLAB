extends Control
@onready var settins_cam: Camera2D = $settings_cam
@onready var player_script: CharacterBody2D = $"../player/player_script"
@onready var game_ref: Node2D = $".."
@onready var fullscreen_windowed: OptionButton = $MarginContainer/VBoxContainer/Fullscreen_windowed
var menu_button = false

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

func _on_game_camera(str) -> void:
	if str == "menu":
		settins_cam.enabled = true
	else:
		settins_cam.enabled = false

func _on_resume_pressed() -> void:
	if menu_button == true:
		game_ref.camera.emit("start")
	else:
		game_ref.camera.emit("player")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_area_2d_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	game_ref.camera.emit("menu")
	player_script.position = Vector2(-14424, -130)
	player_script.stop()
	player_script.rotation = 0
	menu_button = true
