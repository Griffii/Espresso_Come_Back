class_name Student extends CharacterBody2D


@onready var sprite: AnimatedSprite2D = $Student_YR1_Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var animation: String

const speed = 60.0
const jump_force = -300.0


func _ready() -> void:
	# Set which sprite to use
	if animation == "boy":
		sprite.animation = "boy_student01"
	elif animation == "girl":
		sprite.animation = "girl_student01"

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
	if is_on_floor():
		if velocity.x != 0:
			animation_player.play("walk_wiggle")
		else:
			animation_player.stop()

func update_flip(dir):
	if abs(dir) == dir:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func check_for_self(node):
	if node == self:
		return true
	else:
		return false
