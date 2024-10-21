extends Node
class_name State

@export var can_move : bool = true

var animation_player : AnimationPlayer
var character : CharacterBody2D
var next_state : State

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func state_input(_event):
	pass
