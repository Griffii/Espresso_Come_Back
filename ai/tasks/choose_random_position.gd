extends BTAction

@export var range_min_in_dir = 50.0
@export var range_max_in_dir = 100.0

@export var position_var: StringName = &"pos"
@export var direction_var: StringName = &"dir"


func _tick(_delta: float) -> Status:
	#print(agent, " wandering")
	var pos: Vector2
	var dir = rando_dir()
	
	pos = rando_pos(dir)
	blackboard.set_var(position_var, pos)
	
	##print(dir," ",pos.x, " agent position: ", agent.global_position.x)
	return SUCCESS

# Randomly choose left or right 50/50
func rando_dir():
	var dir = randi_range(-2,1)
	
	if abs(dir) != dir:
		dir = -1
	else:
		dir = 1
	
	blackboard.set_var(direction_var, dir)
	return dir

# Randomly set position in a given direction
func rando_pos(dir):
	var vector: Vector2
	var distance = randi_range(range_min_in_dir, range_max_in_dir) * dir
	var final_position = (distance + agent.global_position.x)
	vector.x = final_position
	return vector
