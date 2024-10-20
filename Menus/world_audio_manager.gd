extends Node

@export var bg_music_player: AudioStreamPlayer
@export var bg_ambi_player: AudioStreamPlayer

var current_area : String

func _ready() -> void:
	current_area = AudioGlobal.current_area

func _process(delta: float) -> void:
	if current_area != AudioGlobal.current_area:
		current_area = AudioGlobal.current_area
		update_music_for_scene()


func update_music_for_scene():
	var current_area_ambience = str(current_area + " Ambience")
	bg_ambi_player["parameters/switch_to_clip"] = current_area_ambience
	
	var current_area_music = str(current_area + " Music")
	bg_music_player["parameters/switch_to_clip"] = current_area_music
	
