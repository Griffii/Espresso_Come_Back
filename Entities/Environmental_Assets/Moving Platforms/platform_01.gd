extends AnimatableBody2D

# Reference to the AnimationPlayer node
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Exported variables for controlling position at different keyframes
@export var animation_name = "move_LR_100_3sec"


func _ready():
	# Play the animation
	animation_player.play(animation_name)
