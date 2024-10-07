extends CharacterBody2D
@onready var hoodie_girl: AnimatedSprite2D = $HoodieGirlSprite
@onready var collision_shape_player: CollisionShape2D = $CollisionShape_Player
@onready var rect_shape = collision_shape_player.shape as RectangleShape2D 
@onready var leash_raycast: RayCast2D = $Raycast/Leash_Raycast

# Movement and physics variables
@export var speed: float = 120.0
@export var acceleration: float = 500.0
@export var deceleration: float = 800.0 
@export var max_speed: float = 150.0
@export var jump_force: float = -400.0
@export var gravity: float = 1000.0
@export var coyote_time_duration: float = 0.1  # Time window for coyote jump
@export var jump_buffer_duration: float = 0.2  # Time window for jump buffer
@export var jump_cutoff_multiplier: float = 0.5  # Multiplier to reduce jump height if key is released early
@export var max_fall_speed: float = 800.0
@export var max_step_height: float = 5.0

# Leash Variables
@export var whip_range: float = 75.0
@export var pull_strength: float = 500.0
@export var whip_damage: int = 10

# Internal variables
var is_on_ground: bool = false
var direction: float = 0
var coyote_time: float = 0.0
var jump_buffer: float = 0.0


## Limbo State Machine Variable
var main_sm: LimboHSM



func _ready():
	# Start the Limbo State Machine
	initiate_state_machine()


func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		leash_throw()

# Called every frame
func _physics_process(delta: float) -> void:
	# Call functions for movement and jumping
	move_player(delta)
	gravity_and_jump(delta)
	update_timers(delta) # Timers for coyote time / jump buffer
	
	# Apply the movement and update the ground status
	move_and_slide()
	is_on_ground = is_on_floor()



func move_player(delta):
	# Horizontal input
	var input_direction: float = 0.0
	if Input.is_action_pressed("move_right"):
		input_direction += 1
	if Input.is_action_pressed("move_left"):
		input_direction -= 1
	
	# Handle acceleration and deceleration
	if input_direction != 0:
		direction = input_direction
		velocity.x = move_toward(velocity.x, input_direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	
		# Flip sprite horizontally when moving left or right
	if direction < 0:
		hoodie_girl.flip_h = false
	elif direction > 0:
		hoodie_girl.flip_h = true

func gravity_and_jump(delta):
		# Apply gravity and limit fall speed
	if not is_on_ground:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	
	# Coyote time: Allows jumping shortly after leaving the ground
	if is_on_ground:
		coyote_time = coyote_time_duration
	
	# Jump buffer: Allows jump input to be buffered
	if Input.is_action_just_pressed("jump"):
		jump_buffer = jump_buffer_duration
		
	# Jumping logic
	if coyote_time > 0 and jump_buffer > 0:
		velocity.y = jump_force
		coyote_time = 0.0
		jump_buffer = 0.0
	
	# Variable jump: Cut jump short if the jump button is released early
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cutoff_multiplier

func update_timers(delta: float) -> void:
	# Decrease coyote time and jump buffer over time
	if coyote_time > 0:
		coyote_time -= delta
	if jump_buffer > 0:
		jump_buffer -= delta


func initiate_state_machine():
	main_sm = LimboHSM.new()
	add_child(main_sm)
	
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var walk_state = LimboState.new().named("walk").call_on_enter(walk_start).call_on_update(walk_update)
	var jump_state = LimboState.new().named("jump").call_on_enter(jump_start).call_on_update(jump_update)
	var attack_state = LimboState.new().named("attack").call_on_enter(attack_start).call_on_update(attack_update)
	
	main_sm.add_child(idle_state)
	main_sm.add_child(walk_state)
	main_sm.add_child(jump_state)
	main_sm.add_child(attack_state)
	
	main_sm.initial_state = idle_state
	
	# Transitions between states - Must be specific in waht state can transition to what other state
	main_sm.add_transition(idle_state, walk_state, &"to_walk")
	main_sm.add_transition(main_sm.ANYSTATE, idle_state, &"state_ended")
	main_sm.add_transition(idle_state, jump_state, &"to_jump")
	main_sm.add_transition(walk_state, jump_state, &"to_jump")
	main_sm.add_transition(main_sm.ANYSTATE, attack_state, &"to_attack")
	
	main_sm.initialize(self)
	main_sm.set_active(true)


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		main_sm.dispatch(&"to_attack")
	if event.is_action_pressed("left_click"):
		main_sm.dispatch(&"to_attack")

## State machine functions - Start + Update
func idle_start():
	hoodie_girl.play("idle")
func idle_update(delta: float):
	if velocity.x != 0:
		main_sm.dispatch(&"to_walk")
	if velocity.y != 0:
		main_sm.dispatch(&"to_jump")

func walk_start():
	hoodie_girl.play("walk")
func walk_update(delta: float):
	if velocity.y != 0:
		main_sm.dispatch(&"to_jump")
	if velocity.x == 0:
		main_sm.dispatch(&"state_ended")

func jump_start():
	hoodie_girl.play("jump_full")
func jump_update(delta: float):
	if velocity.y < 0:
		hoodie_girl.play("jump_mid")
	elif velocity.y > 0:
		hoodie_girl.play("falling")
	elif velocity.y == 0 && is_on_floor():
		hoodie_girl.play("landing")
		## I call the end of state dispatch using the on_animation_finished signal function

func attack_start():
	hoodie_girl.play("interact")
	leash_throw()
	# play leash animation
func attack_update(delta: float):
	# Check if we are on the last frame of the animation called in attack_start, if so revert to idle
	if hoodie_girl.frame == hoodie_girl.sprite_frames.get_frame_count("interact") - 1:
		main_sm.dispatch(&"state_ended")





func leash_throw():
	print("Leash Throw Start")
	var target_position = Vector2(whip_range, 0).rotated(rotation)
	leash_raycast.target_position = target_position
	leash_raycast.force_raycast_update()
	
	if leash_raycast.is_colliding():
		print("Leash Collided")
		var hit_object = leash_raycast.get_collider()
		
		if hit_object.is_in_group("attachable"):
			attach_to_object(hit_object)
		elif hit_object.is_in_group("enemy"):
			attack(hit_object)
	print("Leash Throw Finish")

## Code to attach leash
func attach_to_object(target):
	if target is RigidBody2D:
		var direction = (position - target.position).normalized()
		target.apply_impulse(Vector2.ZERO, direction * pull_strength)
	print ("Leash Attached to Object")

func pull_leash():
	print("Leash pulled")
	
	## Pull object that is grabbed towards player

func attack(enemy):
	print("Enemy whipped!")



func _on_animation_finished() -> void:
	## Check what animation finished
	# On landing animation finished, call state machine to revert to idle
	if hoodie_girl.animation == "landing":
		main_sm.dispatch(&"state_ended")
