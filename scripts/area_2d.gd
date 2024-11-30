extends Area2D
@onready var game: Node2D = $"../.."
@onready var player: CharacterBody2D = $"../../player/player_script"

func _on_body_entered(body: Node2D) -> void:
	player.position.x = -800
	player.position.y = 2
	player.stop()
	game.camera.emit("player")
