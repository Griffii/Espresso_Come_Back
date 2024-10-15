extends RigidBody2D

var is_grabbed = false
var player = null
var original_y_position = 0.0
var grab_offset = Vector2.ZERO

# Physics checks
func _physics_process(_delta: float) -> void:
	if is_grabbed and player:
		 # Move the object only on the X-axis while keeping its original Y position
		global_position.x = player.global_position.x + grab_offset.x
		global_position.y = original_y_position  # Lock Y position to its original value
		


# Function to be called when the player grabs the object
func grab(player_instance):
	is_grabbed = true
	player = player_instance
	
	original_y_position = global_position.y  # Capture and lock the Y position
	grab_offset = (global_position - player.global_position)       # Store the initial offset between the desk
	grab_offset.x = grab_offset.x + (1 * player.facing_direction)  # Add 1 pixel to the x value (Seperates collision)
	lock_rotation = true                                           # Lock rotation

# Function to release the object
func release():
	# Optional, apply a small upward force to prevent immediate sinking into the floor
	#linear_velocity.y = -50  # Adjust as needed to counter the sudden drop
	
	lock_rotation = false     # Unlock rotation
	
	#  Reset Variables
	is_grabbed = false
	player = null
	grab_offset = Vector2.ZERO
