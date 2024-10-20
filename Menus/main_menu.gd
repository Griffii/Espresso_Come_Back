class_name MainMenu extends Control

@onready var sfx_click: AudioStreamPlayer = $Audio_Controller/sfx_click


func _ready() -> void:
	AudioGlobal.current_area = "MainMenu"


func _on_play_pressed() -> void:
	# Switch to main scene
	sfx_click.play()
	#get_tree().change_scene_to_file("res://Levels/tutorial_level.tscn")
	SceneManager.swap_scenes("res://Levels/tutorial_level.tscn", null, self, "fade_to_black")

func _on_options_pressed() -> void:
	sfx_click.play()

func _on_quit_pressed() -> void:
	# Close the .exe
	sfx_click.play()
	get_tree().quit()
