extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var velocity = Vector2()
var gravity = 800  # pixels per second squared
var flap_strength = -300  # negative because up is negative y
var score = 0
func _physics_process(delta):
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_up"):
		velocity.y = flap_strength  # reset Y velocity on flap

	velocity = move_and_slide(velocity, Vector2.UP)

	$CanvasLayer/Label.text = str(score)
	pass # Replace with function body.extends Node2D
func _input(event):
	if event is InputEventScreenTouch:
		velocity.y = flap_strength
