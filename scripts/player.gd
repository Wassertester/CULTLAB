extends Node2D
@onready var player_cam: Camera2D = $player_script/player_cam
@onready var player: CharacterBody2D = $player_script

func _on_game_camera(camera) -> void:
	if camera == "player":
		player_cam.enabled = true
	else:
		player_cam.enabled = false
		print("gsfzj")
	if camera == "menu":
		player.do_rotation = false
	else:
		player.do_rotation = true
	
