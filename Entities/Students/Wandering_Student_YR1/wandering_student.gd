extends CharacterBody2D

@onready var student_yr_1_sprite: AnimatedSprite2D = $Student_YR1_Sprite

const speed = 60.0
const jump_force = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_on_wall() and is_on_floor():
		velocity.y = jump_force
	else:
		velocity += get_gravity() * delta
	
	move_and_slide()



func move(dir, move_speed):
	velocity.x = dir * move_speed
	handle_animation()
	update_flip(dir)


func handle_animation():
	pass
	## When you have animations:
	#if !is_on_floor():
		#animation_sprite.play("fall")
	#if velocity.x != 0:
		#animation_sprite.play("walk")
	#else:
		#animation_sprite.play("idle")

func update_flip(dir):
	if abs(dir) == dir:
		student_yr_1_sprite.flip_h = false
	else:
		student_yr_1_sprite.flip_h = true

func check_for_self(node):
	if node == self:
		return true
	else:
		return false
	
	
