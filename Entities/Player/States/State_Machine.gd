# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
extends Node
class_name StateMachine

# Emitted when transitioning to a new state.
signal transitioned(state_name)

@export var animation_player: AnimationPlayer
@export var character : CharacterBody2D
@export var initial_state : State
var current_state : State
var states : Array[State]


func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			
			child.character = character
			child.animation_player = animation_player
		else:
			push_warning("Child ", child.name, " is not a State for StateMachine.")
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state


# Call the current state and update function continously
func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
	
	if current_state.next_state != null:
		change_state(current_state.next_state)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func change_state(new_state : State):
	if new_state == current_state:
		return
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
		current_state.next_state = null
	
	current_state = new_state
	current_state.Enter()

func check_if_can_move():
	return current_state.can_move

func _input(event: InputEvent):
	current_state.state_input(event)
