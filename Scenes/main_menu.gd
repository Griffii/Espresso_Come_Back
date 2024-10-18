extends Control

class_name MainMenu

func _on_play_pressed() -> void:
	# Switch to main scene
	get_tree().change_scene_to_file("res://Scenes/tutorial_level.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	# Close the .exe
	get_tree().quit()
