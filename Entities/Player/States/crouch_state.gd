extends State

class_name CrouchState

# State and Animation Names
@export var air_state : State
@export var ground_state : State
@export var dash_state : State
@export var jump_animation : String = "jump_start"
@export var idle_animation : String = "crouch_idle"
@export var walk_animation : String = "crouch_walk"

# Raycast References
@onready var crouch_raycast_left: RayCast2D = $"../../Crouch_Raycast_Left"
@onready var crouch_raycast_right: RayCast2D = $"../../Crouch_Raycast_Right"


var is_holding_crouch = false

func Enter():
	is_holding_crouch = true
	character.set_player_speed(character.drag_speed)
	setCrouchCollision()
	
	crouch_raycast_left.enabled = true
	crouch_raycast_right.enabled = true

func Exit():
	character.set_player_speed(character.normal_speed)
	setDefaultCollision()
	
	crouch_raycast_left.enabled = false
	crouch_raycast_right.enabled = false

# Handle input
func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		next_state = air_state
	
	if event.is_action_pressed("dash"):
		if character.dash_cooldown_timer <= 0.0:
			next_state = dash_state
	
	if event.is_action_released("move_down"):
		is_holding_crouch = false
		if crouch_raycast_left.is_colliding() or crouch_raycast_right.is_colliding():
			return
		next_state = ground_state

func Update(_delta):
	if Input.is_action_pressed("move_down"):
		is_holding_crouch = true
	
	if character.is_on_ground:
		# Check for movement and call animations
		if character.velocity.x == 0:
			animation_player.play(idle_animation)
		else:
			animation_player.play(walk_animation)
	# If falling, change states
	else:
		next_state = air_state
	# Check if crouch was released
	if is_holding_crouch == false and (!crouch_raycast_left.is_colliding() and !crouch_raycast_right.is_colliding()):
		next_state = ground_state

func setCrouchCollision():
	var new_shape = CapsuleShape2D.new()
	var position = Vector2(0,-22)
	new_shape.radius = 6.5
	new_shape.height = 44
	character.collision_shape_player.shape = new_shape
	character.collision_shape_player.position = position

func setDefaultCollision():
	var new_shape = CapsuleShape2D.new()
	var position = Vector2(0,-27)
	new_shape.radius = 6.5
	new_shape.height = 54
	character.collision_shape_player.shape = new_shape
	character.collision_shape_player.position = position
