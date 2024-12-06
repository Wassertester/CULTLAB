extends Area2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var game: Node2D = $"../.."
@onready var checkpoints: Node2D = $"."
func _on_body_entered(body: Node2D) -> void:
	if game.save.respawn_cords != global_position + Vector2(0, 50):
		print(global_position)
		print(game.save.respawn_cords)
		cpu_particles_2d.emitting = true
