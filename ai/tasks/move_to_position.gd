extends BTAction

@export var target_pos_var := &"pos"
@export var dir_var := &"dir"

@export var speed_var = 40
@export var tolerance = 10

var obstacle_ticker = 0
@export var obstacle_tick_max = 20


func _tick(_delta: float) -> Status:
	var target_pos: Vector2 = blackboard.get_var(target_pos_var, Vector2.ZERO)
	var dir = blackboard.get_var(dir_var)
	
	# If they reach target, success
	if abs(agent.global_position.x - target_pos.x) < tolerance:
		agent.move(dir, 0)
		obstacle_ticker = 0
		return SUCCESS
	# If they stop moving (impassable object), failure
	elif agent.velocity.x == 0:
		#print("Agent stuck")
		obstacle_ticker += 1
		if obstacle_ticker >= obstacle_tick_max:
			obstacle_ticker = 0
			return FAILURE
		else:
			agent.move(dir, speed_var)
			return RUNNING
	# Else keep moving
	else:
		agent.move(dir, speed_var)
		return RUNNING
