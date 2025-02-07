extends Area2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var flag: Sprite2D = $flag
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game = $"../.."
@onready var player = $"../../player/player_script"

func _on_body_entered(body: Node2D) -> void:
	player.heal()
	if game.save_state.respawn_cords != global_position + Vector2(0, 50):
		game.save_state.respawn_cords = global_position + Vector2(0, 50)
		game.save()
		animation_player.play("get checkpoint")
		cpu_particles_2d.emitting = true
	

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if game.save_state.respawn_cords == global_position + Vector2(0, 50):
		flag.position = Vector2(0, -32)
	else:
		flag.position = Vector2(0, 16)
