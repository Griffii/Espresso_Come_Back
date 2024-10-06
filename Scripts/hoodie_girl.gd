extends CharacterBody2D
@onready var hoodie_girl: Sprite2D = $HoodieGirlIdle01Sheet
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_shape_player: CollisionShape2D = $CollisionShape_Player
@onready var rect_shape = collision_shape_player.shape as RectangleShape2D 

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

# Internal variables
var is_on_ground: bool = false
var direction: float = 0
var coyote_time: float = 0.0
var jump_buffer: float = 0.0

# Leash Variables
var leashed_position = Vector2()
var leashed = false
var leash_length = 75
var current_leash_length

func _ready():
	animation_tree.active = true
	current_leash_length = leash_length

func _process(delta):
	update_animation_parameters()

# Called every frame
func _physics_process(delta: float) -> void:
	update_timers(delta)
	
	# Apply gravity and limit fall speed
	if not is_on_ground:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	
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
	
	# Flip sprite horizontally when moving left or right
	if direction < 0:
		hoodie_girl.flip_h = false
	elif direction > 0:
		hoodie_girl.flip_h = true
	
	# Check leash throw
	leash_throw()
	##update()
	
	
	# Apply the movement and update the ground status
	move_and_slide()
	is_on_ground = is_on_floor()


func update_timers(delta: float) -> void:
	# Decrease coyote time and jump buffer over time
	if coyote_time > 0:
		coyote_time -= delta
	if jump_buffer > 0:
		jump_buffer -= delta

func update_animation_parameters():
	if(velocity.x == 0):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
		#print("Idle True")
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		#print("Idle False")
	
	# Check for jump input
	if(Input.is_action_just_pressed("jump")):
		animation_tree["parameters/conditions/jump"] = true
		#print("Jump True")
	else:
		animation_tree["parameters/conditions/jump"] = false
	
	# Check for use/interact input
	if(Input.is_action_just_pressed("interact")):
		animation_tree["parameters/conditions/interact"] = true
		#print("Interact True")
	else:
		animation_tree["parameters/conditions/interact"] = false


# Function to check for step-up and adjust character position if necessary
func handle_step_up():
	var collision_info = move_and_collide(Vector2(velocity.x * get_physics_process_delta_time(), 0))
	
	if collision_info != null:
		# Get the collider object
		var collider = collision_info.get_collider()
		
		# Check if the collider is a StaticBody2D or another suitable body for stepping up
		if collider is StaticBody2D or collider is TileMap:
			var difference_in_height = collision_info.position.y - (position.y + rect_shape.extents.y)
			
			 # Only step up if the height difference is small enough (within max_step_height)
			if difference_in_height > 0 and difference_in_height <= max_step_height:
				# Move character upwards to simulate stepping up
				position.y -= difference_in_height
				velocity.y = 0  # Reset downward velocity after stepping up






func leash_throw():
	$Raycast.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("left_click"):
		leashed_position = get_leash_position()
		if leashed_position:
			leashed = true
			current_leash_length = global_position.distance_to(leashed_position)


func get_leash_position():
	for raycast in $Raycast.get_children():
		if raycast.is_colliding():
			return raycast.get_collision_point()

func pull_leash():
	pass
	
	## Pull object that is grabbed towards player
