extends BTAction

@export var group: StringName
@export var target_var: StringName = &"target"

var target

func _tick(_delta: float) -> Status:
	if group == "student_yr1":
		target = get_student_node()
	elif group == "player":
		target = get_player_node()
	
	##print(agent, " moving to ", target)
	blackboard.set_var(target_var, target)
	return SUCCESS


func get_student_node():
	# Get all nodes of Group student_yr1
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	
	# Make sure there is at least 2 students present
	if nodes.size() >= 2:
		# Check if the value selected is the node calling the function, if so shuffle the array
		while agent.check_for_self(nodes.front()):
			nodes.shuffle()
		# Return a random student node
		return nodes.front()

func get_player_node():
	# Gather all nodes in Group player, put it in an array, return the first entry
	# Should only be one entry, the player
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	return nodes[0]
