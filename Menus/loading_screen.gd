extends CanvasLayer
class_name LoadingScreen

signal transition_is_complete

@export var animation_player: AnimationPlayer
@export var progress_bar: ProgressBar
@export var timer: Timer

var starting_animation_name : String

func _ready() -> void:
	progress_bar.visible = false

func start_transition(animation_name:String):
	if animation_player == null:
		push_warning("AnimationPlayer is null.")
		return
	
	if !animation_player.has_animation(animation_name):
		push_warning("Animation, ", animation_name, ", does not exist.")
		animation_name = "fade_to_black"
	
	starting_animation_name = animation_name
	animation_player.play(animation_name)
	
	# If timer runs out before finishing, show the progress bar
	timer.start()

func finish_transition():
	if timer:
		timer.stop()
	
	var ending_animation_name:String = starting_animation_name.replace("to", "from")
	
	if !animation_player.has_animation(ending_animation_name):
		push_warning("Animation, ", ending_animation_name, ", does not exist.")
		ending_animation_name = "fade_from_black"
	
	await animation_player.animation_finished
	queue_free()

func report_midpoint():
	transition_is_complete.emit()

func _on_timer_timeout() -> void:
	progress_bar.visible = true

func update_bar(val:float) -> void:
	progress_bar.value = val
