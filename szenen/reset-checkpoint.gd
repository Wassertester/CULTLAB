extends Area2D
@onready var flag: Sprite2D = $flag
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D


func _on_area_entered(area: Area2D) -> void:
	DirAccess.remove_absolute(save_game.SAVE_PATH)
	Game.save.respawn_cords = save_game.START_POINT
	animation_player.play("get checkpoint")
	cpu_particles_2d.emitting = true
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if Game.save.respawn_cords == global_position + Vector2(0, 50):
		flag.position = Vector2(0, -32)
	else:
		flag.position = Vector2(0, 16)
