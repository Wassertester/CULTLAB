extends CharacterBody2D
@onready var ray_cast_2d_left: RayCast2D = $"RayCastLeft"
@onready var ray_cast_2d_right: RayCast2D = $"RayCastRight"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_untenl: RayCast2D = $RayCastUntenL
@onready var ray_cast_unten_r: RayCast2D = $RayCastUntenR
@onready var option_button: OptionButton = $"../../Settings/MarginContainer/VBoxContainer/OptionButton"
@onready var particles: CPUParticles2D = $CPUParticles2D
const move_rot = 0.00016
const SPEED = 250.0
const JUMP_VELOCITY = -250.0
const rotation_multiplier = 0.02
const head_bounce_multiplier = 0.8
const friction = 0.8667
const max_jump_multiplier = 1.9
var rotation_speed = 0.0
var velocity_last_frame
var floor_last_frame
var switched_rotation
var velocity_last_frame_x = 0
var switch_y
var switch_x
var velocity_bounce
var timer = 0.0
var jump_held = 1
var left_wall = false
var right_wall = false 

# velocity reset 
func stop():
	velocity.x = 0
	velocity.y = 0

func jump(rotation, strenth):
	animated_sprite.play("no_animation")
	animated_sprite.play("jump")
	velocity.x = SPEED * strenth * sin(rotation)
	velocity.y = JUMP_VELOCITY * strenth * cos(rotation) 
# avanced rotation switch
func rotation_switch():
	var output = rotation
	while output < -2 * PI:
		output += 2 * PI
	while output > 2 * PI:
		output -= 2 * PI
	return output
	
func bounce():
	if is_on_floor() and velocity_last_frame > 88 and (rotation <= -2.1 or rotation >= 2.1):
		animated_sprite.play("no_animation")
		animated_sprite.play("bounce")
		if rotation >= 0:
			switched_rotation = rotation - PI
		else:
			switched_rotation = rotation + PI
		velocity.y = velocity_last_frame * cos(switched_rotation) * -head_bounce_multiplier
		velocity.x += velocity_last_frame * sin(switched_rotation) * head_bounce_multiplier
		
		
	if is_on_wall() and rotation < 3.1 and rotation >0.5:
		animated_sprite.play("no_animation")
		animated_sprite.play("bounce")
		if rotation >= 0:
			switched_rotation = rotation - PI
		else:
			switched_rotation = rotation + PI
		velocity.y = velocity_last_frame * cos(switched_rotation) * -head_bounce_multiplier
		velocity.x += velocity_last_frame_x * sin(switched_rotation) * head_bounce_multiplier 
	
	if is_on_wall() and rotation > -3.1 and rotation < -0.5 and left_wall == true:
		animated_sprite.play("no_animation")
		animated_sprite.play("bounce")
		if rotation >= 0:
			switched_rotation = rotation - PI
		else:
			switched_rotation = rotation + PI
		velocity.y = velocity_last_frame * cos(switched_rotation) * -head_bounce_multiplier
		velocity.x += velocity_last_frame_x * sin(switched_rotation) * -head_bounce_multiplier
	
func _physics_process(delta: float) -> void:
	#wallcheck
	if ray_cast_2d_right.is_colliding():
		right_wall = true
	if ray_cast_2d_left.is_colliding():
		left_wall = true
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
	
	if Input.is_action_just_released("jump") and is_on_floor() and (ray_cast_untenl.is_colliding() or ray_cast_unten_r.is_colliding()):
		jump(rotation, jump_held)
	
	# rotation
	if option_button.selected == 1:
		if Input.is_action_pressed("left") and not Input.is_action_just_pressed("right"):
			rotation_speed -= rotation_multiplier
		if Input.is_action_pressed("right") and not Input.is_action_just_pressed("left"):
			rotation_speed += rotation_multiplier
		rotation_speed *= 0.8
		rotation += rotation_speed + (velocity.x * move_rot)
	elif option_button.selected == 0:
		look_at(get_global_mouse_position())
		rotation_degrees = rotation_degrees + 90
	
	if ray_cast_2d_left.is_colliding() or ray_cast_2d_right.is_colliding():
		bounce()
	
	velocity_last_frame = velocity.y
	velocity_last_frame_x = velocity.x
	# idle animation
	if is_on_floor() and rotation >= -0.8 and rotation <= 0.8:
		timer += delta
		if timer > 1:
			animated_sprite.play("idle")
			
	elif animated_sprite.animation == "idle":
		timer = 0
		animated_sprite.stop()
		
	move_and_slide()
	#print(rotation)
	#print(rotation_degrees)
	#funst dieses drecks Github jetzt endlich?

# Handle jump.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("jump") and is_on_floor():
		if not jump_held > max_jump_multiplier:
			jump_held += delta
			
	else:
		jump_held = 1.0
		
	
	# particles
	if jump_held > 1.2:
		particles.initial_velocity_max = exp(jump_held + 2) * 1.5
		particles.initial_velocity_min = exp(jump_held + 2) * 1.5
		particles.emitting = true
	else:
		particles.initial_velocity_max = 11
		particles.initial_velocity_min = 11
		particles.emitting = false
	
	
	
	
