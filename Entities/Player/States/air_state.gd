class_name AirState extends State

# Adjustable Variables
@export var double_jump_velocity : float = -300

# State and Animation Names
@export var landing_state : State
@export var leash_state : State
@export var dash_state : State
@export var landing_animation : String = "landing"
@export var jumping_up : String = "jump_going_up"
@export var jump_start_animation : String = "jump_start"
@export var falling : String = "falling"

var has_double_jumped = false

func Update(delta):
	pass

func Physics_Update(delta):
	if character.velocity.y < 0:
		animation_player.play(jumping_up)
	elif character.velocity.y > 0:
		animation_player.play(falling)
	elif character.velocity.y == 0:
		next_state = landing_state

func state_input(event : InputEvent):
	if event.is_action_pressed("jump") && not has_double_jumped:
		#double_jump()
		pass
	
	if event.is_action_pressed("left_click"):
		next_state = leash_state
	
	if event.is_action_pressed("dash"):
		if character.dash_cooldown_timer <= 0.0:
			next_state = dash_state

func double_jump():
	character.velocity.y = double_jump_velocity
	animation_player.play(jump_start_animation)
	has_double_jumped = true

func Enter():
	setJumpCollision()

func Exit():
	setDefaultCollision()
	if next_state == landing_state:
		animation_player.play(landing_animation)
		has_double_jumped = false
	else:
		has_double_jumped = false

func setJumpCollision():
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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	# If double jump is called go back to the jumping up animation after jumping once more
	if anim_name == jump_start_animation:
		animation_player.play(jumping_up)
