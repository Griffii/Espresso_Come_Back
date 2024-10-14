extends State

class_name PushState

# State and Animation Names
@export var air_state : State
@export var crouch_state : State
@export var leash_state : State
@export var ground_state : State
@export var jump_animation : String = "jump_start"
@export var idle_animation : String = "idle"
@export var walk_animation : String = "walk"


func Update(_delta):
	if not character.is_on_wall():
		if character.is_on_floor():
			next_state = ground_state
		else:
			next_state = air_state
	
	# Check for movement and call animations
		if character.velocity.x == 0:
			animation_player.play(idle_animation)
		else:
			animation_player.play(walk_animation)

func Physics_Update(delta):
	pass

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		next_state = air_state
	
	if event.is_action_pressed("move_down"):
		next_state = crouch_state
