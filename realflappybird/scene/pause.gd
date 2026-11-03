extends Node2D

var is_paused = false

func _on_Pauses_pressed():
	is_paused = !is_paused  # Toggle pause

	get_tree().paused = is_paused
