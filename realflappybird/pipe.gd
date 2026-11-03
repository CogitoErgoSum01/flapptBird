extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const speed = 150


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):



func _physics_process(delta):
	position.x -= speed*delta
	


func _on_pipe_area_entered(area):
	if area.is_in_group("pipek"):
		queue_free()
	pass # Replace with function body.
