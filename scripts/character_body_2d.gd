extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_untenl: RayCast2D = $rays/RayCastUntenL
@onready var ray_cast_unten_r: RayCast2D = $rays/RayCastUntenR
@onready var option_button: OptionButton = $"../../Settings/MarginContainer/VBoxContainer/OptionButton"
@onready var ray_cast_left: RayCast2D = $"../RayCastLeft"
@onready var ray_cast_right: RayCast2D = $"../RayCastRight"

const move_rot = 0.00016
const SPEED = 250.0
const JUMP_VELOCITY = -250.0
const rotation_multiplier = 0.02
const head_bounce_multiplier = 0.8
const friction = 0.8667
const max_jump_multiplier = 1.8

var rotation_speed = 0.0
var velocity_last_frame = 0.0
var floor_last_frame
var velocity_last_frame_x = 0.0
var switch_y
var switch_x
var velocity_bounce
var jump_held = 1
var switched_rotation

var health: int = 3
var do_rotation = true

func stop():
	velocity.x = 0
	velocity.y = 0
	velocity_last_frame = 0
	velocity_last_frame_x = 0

func jump(rotation, strenth):
	#animated_sprite.play("no_animation")
	velocity.x = SPEED * strenth * sin(rotation)
	velocity.y = JUMP_VELOCITY * strenth * cos(rotation) 

func make_positive(n):
	if n < 0:
		return n * -1
	else:
		return n

func bounce():
	var positive_rotation
	if is_on_floor() and (velocity_last_frame < -66 or velocity_last_frame > 66):
		velocity.y = -velocity_last_frame * make_positive(cos(rotation)) * head_bounce_multiplier
		velocity.x -= velocity_last_frame * sin(rotation) * head_bounce_multiplier
		#animated_sprite.play("no_animation")
		animated_sprite.play("bounce")
		
	if is_on_ceiling() and (velocity_last_frame < -66 or velocity_last_frame > 66):
		velocity.y = -velocity_last_frame * make_positive(cos(rotation)) * head_bounce_multiplier
		velocity.x += velocity_last_frame * sin(rotation) * head_bounce_multiplier
		#animated_sprite.play("no_animation")
		animated_sprite.play("bounce")
		
	elif is_on_wall() and (velocity_last_frame_x < -66 or velocity_last_frame_x > 66):
		if rotation < 0:
			positive_rotation = rotation + PI
		else:
			positive_rotation = rotation
		velocity.y += velocity_last_frame_x * cos(positive_rotation) * head_bounce_multiplier
		velocity.x = -velocity_last_frame_x * sin(positive_rotation) * head_bounce_multiplier
		#animated_sprite.play("no_animation")
		animated_sprite.play("bounce")
	
func _physics_process(delta: float) -> void:
	 # auf Boden verlangsamen
	if is_on_floor() and floor_last_frame:
		velocity.x *= friction
	#erst nach einem frame verlangsamen wegen Hut jump
	if is_on_floor():
		floor_last_frame = true
	else:
		floor_last_frame = false
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# idle animation only of you stand up
	var idle_timer = 0.0
	if is_on_floor() and rotation >= -0.8 and rotation <= 0.8 and not Input.  is_action_pressed("jump"):
		idle_timer += delta
		if idle_timer > 1:
			animated_sprite.play("idle") 
	elif animated_sprite.animation == "idle":
		idle_timer = 0
		animated_sprite.stop()
	
	# rotation
	if option_button.selected == 1:
		if Input.is_action_pressed("left") and not Input.is_action_just_pressed("right"):
			rotation_speed -= rotation_multiplier
		if Input.is_action_pressed("right") and not Input.is_action_just_pressed("left"):
			rotation_speed += rotation_multiplier
		rotation_speed *= 0.8
		rotation += rotation_speed + (velocity.x * move_rot)
	elif option_button.selected == 0 and do_rotation:
		look_at(get_global_mouse_position())
		rotation_degrees = rotation_degrees + 90
	if is_on_floor() and rotation <= -2.1 or rotation >= 2.1 and velocity_last_frame > 88:
		bounce()
	elif is_on_wall() and not velocity.x < 66 and rotation < 3.1 and rotation >0.5:
		bounce()
	elif is_on_wall() and not velocity.x < -66 and rotation > -3.1 and rotation < -0.5:
		bounce()
	elif is_on_ceiling() and rotation < 1 and rotation > -1:
		bounce()
	# call jump funktion when button released
	if Input.is_action_just_released("jump"):
		animated_sprite.play("jump")
		if is_on_floor() and (ray_cast_untenl.is_colliding() or ray_cast_unten_r.is_colliding()):
			jump(rotation, jump_held)
	# charge jump
	if Input.is_action_pressed("jump"):
		if not jump_held > max_jump_multiplier and is_on_floor():
			jump_held += delta
	else:
		jump_held = 1.0

	if is_on_floor():
		ray_cast_left.position = position
		if ray_cast_left.is_colliding():
			velocity.x += 4
		ray_cast_right.position = position
		if ray_cast_right.is_colliding():
			velocity.x -= 4
		
	
	velocity_last_frame = velocity.y
	velocity_last_frame_x = velocity.x
		
	move_and_slide()

func _process(delta: float) -> void:
	pass
	
@onready var damage_detector: Area2D = $"../damage_detector"
@onready var timer: Timer = $"../damage_detector/Timer"

func _on_damage_detector_area_entered(area: Area2D) -> void:
	take_damage(1)
	
func take_damage(amount):
	health -= amount
	if health <= 0:
		timer.start()
		Engine.time_scale = 0.3
			
@onready var game: Node2D = $"."
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	game.respawn()
	
