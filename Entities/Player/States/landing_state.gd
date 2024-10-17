extends State

class_name LandingState

@export var landing_animation : String = "landing"
@export var ground_state : State

func Enter():
	character.plat_vel = Vector2.ZERO  # Reset stored plat velocity upon landing
	character.deceleration = 600.0     # Reset deceleration
	character.acceleration = 800.0     # Reset acceleration

func Physics_Update(delta):
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == landing_animation:
		next_state = ground_state
