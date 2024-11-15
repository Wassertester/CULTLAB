extends Node2D
@onready var player_cam: Camera2D = $player_script/player_cam


func _on_game_camera(str) -> void:
	if str == "player":
		player_cam.enabled = true
	else:
		player_cam.enabled = false
