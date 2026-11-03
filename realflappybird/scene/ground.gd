extends Node2D
class_name Ground

signal bird_crashed

var speed = -150

onready var sprite1 = $Ground1/Sprite1
onready var sprite2 = $Ground2/Sprite2

func _ready():
	# Position sprites side by side
	sprite1.position = Vector2(0, sprite1.position.y)
	sprite2.position = Vector2(sprite1.texture.get_width(), sprite2.position.y)

func _process(delta):
	sprite1.position.x += speed * delta
	sprite2.position.x += speed * delta

	var width = sprite1.texture.get_width()

	# When sprite1 moves fully off left, reposition it after sprite2
	if sprite1.position.x <= -width:
		sprite1.position.x = sprite2.position.x + width

	# When sprite2 moves fully off left, reposition it after sprite1
	if sprite2.position.x <= -width:
		sprite2.position.x = sprite1.position.x + width


func _on_Ground1_area_entered(area):
	if area.is_in_group("player"):
		speed = 0
	pass # Replace with function body.
