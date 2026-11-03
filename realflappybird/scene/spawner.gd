extends Node2D

func _process(delta):
	pass




var wall = preload("res://pipe.tscn")  # Make sure the path is correct

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Timer.start()  # Optional if autostart is off

func _on_Timer_timeout():
	if  Global.game_started:
		var wall_instance = wall.instance()
		wall_instance.position = Vector2(320, rand_range(-50,-150)) 
		get_parent().call_deferred("add_child", wall_instance)
