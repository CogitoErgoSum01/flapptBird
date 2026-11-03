extends CanvasLayer

func _ready():
	if Global.score >= 50:
		$Silveraward.visible = true
	if Global.score >= 100:
		$Goldaward.visible = true
	update_score_labels()

func update_score_labels():
	$score.text =  str(Global.score)
	$highscore.text = str(Global.high_score)

func _on_Button_pressed():
	Global.score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()
