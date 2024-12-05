extends CharacterBody2D

# signal player_fired_Rocket(rocket)

const SPEED = 450.0
const CROUCH_SPEED = 350.0
const JUMP_VELOCITY = -650.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var crouch_ray_cast_1: RayCast2D = $CrouchRayCast_1
@onready var crouch_ray_cast_2: RayCast2D = $CrouchRayCast_2

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var jump_height_timer: Timer = $JumpHeightTimer

var state_jumping = false

var is_crouching = false
var under_obj = false
var coyote_timer_on = false
var jump_buffered = false

var standing_c = preload("res://resources/standing_collision.tres")
var crouching_c = preload("res://resources/crouching_collision.tres")


func _process(delta):
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump()
	
	# Movement & associated animation --------------------------
	# Get input directions: (-1, 0, 1)
	var direction := Input.get_axis("move_left", "move_right")
	
	# Character flip according to movement direction
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
	
	# Move Character
	if direction:
		velocity.x = direction * SPEED
		if is_crouching:
			velocity.x *= 0.7
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Character Actions --------------------------------------------
	# Attack
	if Input.is_action_just_pressed("attack"):
		weapon_fire()
	
	# Character crouch & crouched stuck under obj
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if able_to_uncrouch():
			stand()
		else:
			under_obj = true 
	if under_obj && able_to_uncrouch() && !Input.is_action_pressed("crouch"):
		stand()
		under_obj = false
	
	if velocity.y >= 0:
		state_jumping = false
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	
	# Walked off ledge 'if' statement
	# (Error may occur when sliding off an incline ramp: coyote timer won't start since velocity.y > 0)
	if was_on_floor and !is_on_floor() and not state_jumping:
		coyote_timer.start()
		# print("COYOTE TIMER START")
		coyote_timer_on = true
	
	# Touched Ground 'if' statement
	if !was_on_floor && is_on_floor():
		# print("LANDED")
		if jump_buffered:
			jump()
			jump_buffered = false
	
	update_animations(direction)

func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			if is_crouching:
				animation_player.play("crouch")
			else:
				animation_player.play("idle")
		else:
			if is_crouching:
				animation_player.play("crouch_walk")
			else:
				animation_player.play("run")
	else:
		if velocity.y < 0:
			animation_player.play("jump")
		else:
			animation_player.play("fall")

# timer functions-----------------------------------
func _on_coyote_timer_timeout() -> void:
	coyote_timer_on = false

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false

func _on_jump_height_timer_timeout() -> void:
	if !Input.is_action_pressed("jump"):
		if velocity.y < -200:
			velocity.y = -200
		# print("LOW JUMP")
	else:
		pass
		# print("NORMAL JUMP")

# Player Action functions--------------------------------------
func jump():
	state_jumping = true
	if (is_on_floor() or coyote_timer_on):
		velocity.y = JUMP_VELOCITY
		jump_height_timer.start()
		coyote_timer_on = false
	else:
		# print("JUMP BUFFERED")
		jump_buffer_timer.start()
		jump_buffered = true
		# print("Coyote jumped")

func crouch():
	if is_crouching:
		return
	is_crouching = true
	collision_shape_2d.shape = crouching_c
	collision_shape_2d.position.y = -12.5

func stand():
	if is_crouching == false:
		return
	is_crouching = false
	collision_shape_2d.shape = standing_c
	collision_shape_2d.position.y = -19
	
func able_to_uncrouch() -> bool:
	var result = !crouch_ray_cast_1.is_colliding() && !crouch_ray_cast_2.is_colliding()
	return result

func fire():
	pass

# Math functions
# Aim Angle
func weapon_fire():
	pass
