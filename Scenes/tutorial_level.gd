extends Node

class_name Level

@export var player : Player
@export var level_id : int
@export var player_spawn_pos: Node2D

var level_data 

func _ready() -> void:
	pass


func _on_kill_plane_body_entered(body: Node2D) -> void:
	if body == player:
		player.fall_into_void()
