extends CharacterBody2D

@export var speed : float = 70

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(_delta):
	
	#Get Input Direction
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	# Update velocity
	velocity = input_direction * speed
	
	# Play running animation if moving
	if velocity.length() > 0.0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
	
	# Flip sprite horizontally when moving left or right
	if input_direction.x < 0:
		animated_sprite.flip_h = true
	elif input_direction.x > 0:
		animated_sprite.flip_h = false
	
	
	# Move character on the screen
	move_and_slide()
