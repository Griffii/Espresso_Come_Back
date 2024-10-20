extends BTAction

@export var target_var := &"target"

@export var speed_var = 80
@export var distance_tolerance = 100

func _tick(_delta: float) -> Status:
	#print("Starting move_from_target")
	var target: CharacterBody2D = blackboard.get_var(target_var)
	
	if target != null:
		var target_pos = target.global_position
		# Return the negative of the direction to target
		var dir = -(agent.global_position.direction_to(target_pos))
		
		var distance_to_target = abs(target_pos - agent.global_position)
		#print("Distance from player: ", distance_to_target.x)
		if distance_to_target.x <= distance_tolerance:
			##print(dir.x, " ", dir)
			agent.move(dir.x, speed_var) # Run away
			return RUNNING
		else:
			agent.move(dir.x, 0) # Stop moving
			return SUCCESS
	
	return FAILURE
