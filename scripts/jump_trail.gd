extends Node2D
@onready var particles_1: Sprite2D = $Sprite2D
@onready var particles_2: Sprite2D = $Sprite2D2
@onready var particles_3: Sprite2D = $Sprite2D3
@onready var particles_4: Sprite2D = $Sprite2D4
@onready var particles_5: Sprite2D = $Sprite2D5
@onready var particles_6: Sprite2D = $Sprite2D6
@onready var particles_7: Sprite2D = $Sprite2D7
@onready var particles_8: Sprite2D = $Sprite2D8
@onready var player: CharacterBody2D = $".."
var particles = [$CPUParticles2D, $CPUParticles2D2, $CPUParticles2D3, $CPUParticles2D4, $CPUParticles2D5, $CPUParticles2D6, $CPUParticles2D7, $CPUParticles2D8]
const TIME_MULTY = 0.02
var velocity_x
var velocity_y
var velocety_
var position_: Vector2 = Vector2(0, 0)
var timer = 1
func set_position_ (n, t):
	if t == 1:
		particles_1.global_position = n
	elif t == 2:
		particles_2.global_position = n
	elif t == 3:
		particles_3.global_position = n
	elif t == 4:
		particles_4.global_position = n
	elif t == 5:
		particles_5.global_position = n
	elif t == 6:
		particles_6.global_position = n
	elif t == 7:
		particles_7.global_position = n
	elif t == 8:
		particles_8.global_position = n

func _process(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		if player.is_on_floor() and (player.ray_cast_untenl.is_colliding() or player.ray_cast_unten_r.is_colliding()):
			modulate = Color(1, 1, 1, 1)
		else:
			modulate = Color(1, 1, 1, 0.4)
		visible = true
		
		velocity_x = player.SPEED * player.jump_held * sin(player.rotation)
		velocity_y = player.JUMP_VELOCITY * player.jump_held * cos(player.rotation)
		velocety_ = Vector2(velocity_x * TIME_MULTY, velocity_y * TIME_MULTY)
		while timer <= 8:
			position_ += velocety_
			set_position_(position_ + player.position, timer)
			velocety_ += player.get_gravity() * TIME_MULTY * TIME_MULTY
			timer += 1
		timer = 1
		position_ = Vector2(0, 0)
		
	
	else:
		visible = false
	
