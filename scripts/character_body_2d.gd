extends CharacterBody2D
@onready var ray_cast_2d_left: RayCast2D = $"rays/RayCastLeft"
@onready var ray_cast_2d_right: RayCast2D = $"rays/RayCastRight"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_untenl: RayCast2D = $rays/RayCastUntenL
@onready var ray_cast_unten_r: RayCast2D = $rays/RayCastUntenR
@onready var option_button: OptionButton = $"../../Settings/MarginContainer/VBoxContainer/OptionButton"
const move_rot = 0.00016
const SPEED = 250.0
const JUMP_VELOCITY = -250.0
const rotation_multiplier = 0.02
const head_bounce_multiplier = 0.8
const friction = 0.8667
const max_jump_multiplier = 1.8
var rotation_speed = 0.0
var velocity_last_frame
var floor_last_frame
var velocity_last_frame_x = 0
var switch_y
var switch_x
var velocity_bounce
var timer = 0.0
var jump_held = 1
var switched_rotation

# velocity reset 
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
	if is_on_floor() and rotation >= -0.8 and rotation <= 0.8:
		timer += delta
		if timer > 1:
			animated_sprite.play("idle") 
	elif animated_sprite.animation == "idle":
		timer = 0
		animated_sprite.stop()
	
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
	if is_on_floor() and velocity_last_frame > 88 and (rotation <= -2.1 or rotation >= 2.1):
		bounce()
		
	if is_on_wall() and rotation < 3.1 and rotation >0.5:
		bounce()
			
	if is_on_wall() and rotation > -3.1 and rotation < -0.5:
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
	
	velocity_last_frame = velocity.y
	velocity_last_frame_x = velocity.x
		
	move_and_slide()
