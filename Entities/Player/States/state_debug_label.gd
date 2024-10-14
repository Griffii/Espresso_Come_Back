extends Label

@onready var state_machine: StateMachine = $"../CharacterStateMachine"


func _process(delta: float) -> void:
	text = "State: " + state_machine.current_state.name
