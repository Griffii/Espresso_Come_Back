extends State

class_name DashState

# State and Animation Names
@export var air_state : State
@export var ground_state : State
#@export var dash_animation : String = "dash"

var gravity

func Enter():
	if character.dash_cooldown_timer > 0.0:
		return
	
	character.is_dashing = true                              # is_dashing true
	character.dash_timer = character.dash_duration           # Set dash timer
	character.dash_cooldown_timer = character.dash_cooldown  # Set cooldown
	character.set_player_speed(character.dash_speed)         # Make character fast
	# Turn OFF Gravity
	gravity = character.gravity
	character.gravity = 0.0
	character.dash_direction = character.get_dash_direction()

func Exit():
	character.gravity = gravity            # Turn ON gravity
	character.is_dashing = false           # Reset is_dashing
	character.set_player_speed(character.normal_speed) # make them slow again
	character.halt_movement()              # Set velocity to ZER), stop all movement

func Physics_Update(_delta):
	# Change state if timer is over
	if character.dash_timer <= 0.0:
		if character.is_on_floor():
			next_state = ground_state
		else:
			next_state = air_state

##### Decided to remove dash from gameplay, leaving the state incase I change my mind later ####
