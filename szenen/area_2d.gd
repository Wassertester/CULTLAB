extends Area2D

@onready var body1: CharacterBody2D = $CharacterBody2D
@onready var player: Node2D = $"../../player"

signal telepot(x, y)



func _on_body_entered(body: Node2D) -> void:
	player.position.x = -800
	player.position.y = 2
	body.stop()
	
