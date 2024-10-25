extends Node2D
var player_pos: Vector2 
var player_vel: Vector2
var crash: int

#@onready var collision_shape: CollisionShape2D = $"start island/Area2D2/CollisionShape2D2"
@onready var player_ref: CharacterBody2D = $"player/player_script"
@onready var player_cam: Camera2D = $player/player_script/Camera2D
@onready var settins_cam: Camera2D = $Settings/Camera2D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		main_menu()
		
func main_menu():
	player_vel = player_ref.velocity
	player_pos = player_ref.position
	player_ref.stop()
	player_ref.position.x = -14424
	player_ref.position.y = -130
