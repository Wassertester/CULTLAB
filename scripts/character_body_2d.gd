extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_untenl: RayCast2D = $RayCastUntenL
@onready var ray_cast_unten_r: RayCast2D = $RayCastUntenR
@onready var option_button: OptionButton = $"../../Settings/MarginContainer/VBoxContainer/OptionButton"
@onready var ray_cast_left: RayCast2D = $"../RayCastLeft"
@onready var ray_cast_right: RayCast2D = $"../RayCastRight"
@onready var super_bounce_particles: CPUParticles2D = $"../super_bounce_particles"

const move_rot = 0.00016
const SPEED = 200.0
const JUMP_VELOCITY = -200.0
const rotation_multiplier = 0.02
const head_bounce_multiplier = 0.8
const friction = 0.816667
const max_jump_multiplier = 1.8
enum {floor, wall, ceiling}

var rotation_speed = 0.0
var velocity_last_frame = 0.0
var floor_last_frame
var velocity_last_frame_x = 0.0
var switch_y
var switch_x
var velocity_bounce
var jump_held = 1
var switched_rotation
var idle_timer = 0.0

var superness: float = 0.0
var do_rotation = true
var super_bounce: bool = false
var you_can_su_bounce: bool = true
var velocety_after_bounce: Vector2 = Vector2(0, 0)

func stop():
	velocity.x = 0
	velocity.y = 0
	velocity_last_frame = 0
	velocity_last_frame_x = 0

func jump(strenth):
	#animated_sprite.play("no_animation")
	velocity.x = SPEED * strenth * sin(rotation)
	velocity.y = JUMP_VELOCITY * strenth * cos(rotation) 

func make_positive(n):
	if n < 0:
		return n * -1
	else:
		return n
		
func super_bounce_calc(vel):
	if not super_bounce:
		return vel
	elif vel > 0.0:
		return superness * log(vel + 1) + vel
	else:
		return -superness * log(-vel + 1) + vel
func super_bounce_particles_():
	var speed = sqrt(make_positive(velocity.x ** 2) + make_positive(velocity.y ** 2))
	super_bounce_particles.position = position + Vector2(-sin(rotation), cos(rotation))
	super_bounce_particles.direction = Vector2(-sin(rotation), cos(rotation))
	super_bounce_particles.initial_velocity_min = speed * 0.25
	super_bounce_particles.initial_velocity_max = speed * 0.3
	super_bounce_particles.lifetime = 55 / speed + 0.3
	super_bounce_particles.amount = int(speed / 5)
	super_bounce_particles.emitting =  true
	
func bounce(collision):
	var positive_rotation
	if collision == floor:
		velocity.y = -super_bounce_calc(velocity_last_frame) * make_positive(cos(rotation)) * head_bounce_multiplier
		velocity.x -= super_bounce_calc(velocity_last_frame) * sin(rotation) * head_bounce_multiplier
		
	elif collision == ceiling:
		velocity.y = -super_bounce_calc(velocity_last_frame) * make_positive(cos(rotation)) * head_bounce_multiplier
		velocity.x += super_bounce_calc(velocity_last_frame) * sin(rotation) * head_bounce_multiplier
		
	elif collision == wall:
		if rotation < 0:
			positive_rotation = rotation + PI
		else:
			positive_rotation = rotation
		velocity.y += super_bounce_calc(velocity_last_frame_x) * cos(positive_rotation) * head_bounce_multiplier
		velocity.x = -super_bounce_calc(velocity_last_frame_x) * sin(positive_rotation) * head_bounce_multiplier
	
	if super_bounce:
		super_bounce_particles_()
		
	animated_sprite.play("bounce")
	super_bounce = false
	velocety_after_bounce = velocity
	superness = 45
	
func _physics_process(delta: float) -> void:
	# auf Boden verlangsamen
	# erst nach einem frame verlangsamen wegen Hut jump
	if is_on_floor() and floor_last_frame:
		velocity.x *= friction
	
	
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# idle animation only of you stand up
	if is_on_floor() and rotation >= -0.8 and rotation <= 0.8 and not Input.is_action_pressed("jump"):
		idle_timer += delta
		if idle_timer > 1.5:
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
	
	# super bounce handling
	if superness > 8:
		superness -= 1.8
	else:
		super_bounce = false
	
	if Input.is_action_just_pressed("super_bounce") and you_can_su_bounce:
		super_bounce = true
		you_can_su_bounce = false
		if superness > 33:
			if velocety_after_bounce.x > 0.0:
				velocity.x += superness * log(velocety_after_bounce.x + 1)
			else:
				velocity.x += -superness * log(-velocety_after_bounce.x + 1)
			if velocety_after_bounce.y > 0.0:
				velocity.y += superness * log(velocety_after_bounce.y + 1)
			else:
				velocity.y += -superness * log(-velocety_after_bounce.y + 1)
			super_bounce_particles_()
		superness = 40
		
	if is_on_floor() and floor_last_frame:
		you_can_su_bounce = true
		
	if is_on_floor() and (velocity_last_frame < -77 or velocity_last_frame > 77) and (rotation <= -2.1 or rotation >= 2.1):
		bounce(floor)
	elif is_on_wall() and ((velocity_last_frame_x > 77 and rotation < 3.1 and rotation >0.5) or (velocity_last_frame_x < -77 and rotation > -3.1 and rotation < -0.5)):
		bounce(wall)
	elif is_on_ceiling() and (velocity_last_frame < -77 or velocity_last_frame > 77) and rotation < 1 and rotation > -1:
		bounce(ceiling)
	
	# call jump funktion when button released
	if Input.is_action_just_released("jump"):
		animated_sprite.play("jump")
		if is_on_floor() and (ray_cast_untenl.is_colliding() or ray_cast_unten_r.is_colliding()):
			jump(jump_held)
	# charge jump
	if Input.is_action_pressed("jump"):
		if not jump_held > max_jump_multiplier and is_on_floor():
			jump_held += delta
	else:
		jump_held = 1.0

	# pushing you away from wall
	if is_on_floor():
		ray_cast_left.position = position
		if ray_cast_left.is_colliding():
			velocity.x += 4
		ray_cast_right.position = position
		if ray_cast_right.is_colliding():
			velocity.x -= 4
		
	
	velocity_last_frame = velocity.y
	velocity_last_frame_x = velocity.x
		
	if is_on_floor():
		floor_last_frame = true
	else:
		floor_last_frame = false
		
	move_and_slide()
	
# health / damage system
const max_health = 3
var health: int = max_health
@onready var death_timer: Timer = $"../health_system/death_Timer"
@onready var imunity_timer: Timer = $"../health_system/imunity_timer"
var imunity_frame = false
signal update_HUD
func take_damage(amount):
	if imunity_frame:
		return
	health -= amount
	imunity_frame = true
	imunity_timer.start()
	if health <= 0:
		health = 0
		death_timer.start()
		Engine.time_scale = 0.2
	update_HUD.emit(health, 1.0)
			
@onready var game: Node2D = $"../.."
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	game.respawn()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "DEATH":
		take_damage(999)
	else:
		take_damage(1)

func _on_imunity_timer_timeout() -> void:
	imunity_frame = false
func heal():
	if health == max_health:
		return
	health = max_health
	update_HUD.emit(max_health, 0.2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	take_damage(1)
