extends KinematicBody2D
class_name bird

# Movement
var velocity = Vector2()
var gravity = 1200
var flap_strength = -350
var max_fall_speed = 600
var is_dead = false
var fade_played = false

# Animation
onready var fade_anim = get_node("/root/main/fade/AnimationPlayer")

# Rotation settings
const FLAP_ROTATION = -30  # More dramatic upward tilt
const MAX_FALL_ROTATION = 90
const ROTATION_SPEED_UP = 25.0
const ROTATION_SPEED_DOWN = 6

# Flap rotation timing
var flap_rotation_time = 0.5
var flap_rotation_timer = 0.0

# Score
var score = 0
var game_over_scene = preload("res://script/ending.tscn")

func _ready():

	Input.set_use_accumulated_input(false)
	position.y = 300
	velocity = Vector2()
	rotation_degrees = 0
	$AnimatedSprite.rotation_degrees = 0
	Global.game_started = false

func _input(event):
	if is_dead:
		return

	if event is InputEventScreenTouch and event.pressed:
		handle_flap()
	elif Input.is_action_just_pressed("ui_up"):
		handle_flap()
	elif Input.is_action_just_pressed("click"):
		handle_flap()

func handle_flap():
	if not Global.game_started:
		Global.game_started = true
		$"../start".visible = false

	if $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stop()
	$AudioStreamPlayer.play()

	flap()

func flap():
	velocity.y = flap_strength
	flap_rotation_timer = flap_rotation_time  # ⬅️ Hold tilt timer set here

func _physics_process(delta):
	if not Global.game_started:
		position.y += sin(OS.get_ticks_msec() / 300.0) * 0.5
		return

	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, flap_strength, max_fall_speed)
	velocity = move_and_slide(velocity, Vector2.UP)

	$"../ui/CanvasLayer/Label".text = str(score)

	# Bird tilt logic
	var tilt_target = 0.0

	if flap_rotation_timer > 0:
		flap_rotation_timer -= delta
		tilt_target = FLAP_ROTATION  # ⬅️ Keep tilted upward
	else:
		if velocity.y < 0:
			tilt_target = FLAP_ROTATION
		else:
			var fall_ratio = velocity.y / max_fall_speed
			tilt_target = lerp(0.0, MAX_FALL_ROTATION, fall_ratio)

	var rotation_speed = ROTATION_SPEED_DOWN
	if velocity.y < 0:
		rotation_speed = ROTATION_SPEED_UP

	$AnimatedSprite.rotation_degrees = lerp(
		$AnimatedSprite.rotation_degrees,
		tilt_target,
		rotation_speed * delta
	)

	$AnimatedSprite.rotation_degrees = clamp(
		$AnimatedSprite.rotation_degrees,
		FLAP_ROTATION,
		MAX_FALL_ROTATION
	)

func _on_score_area_entered(area):
	if area.is_in_group("score") and Global.game_started:
		$point.play()
		score += 1
		Global.score = score

func _on_score_area_exited(area):
	if area.is_in_group("score"):
		$point.stop()

func _on_grddetect_area_entered(area):
	if area.is_in_group("ground") and Global.game_started:

		if score > Global.high_score:
			Global.high_score = score
		
		
		Global.score = score
		$dies.play()
		var game_over = game_over_scene.instance()
		get_tree().get_root().add_child(game_over)
		get_tree().paused = true
		game_over.pause_mode = Node.PAUSE_MODE_PROCESS

func _on_hitbox_area_entered(area):
	if area.is_in_group("pipe") and Global.game_started and not fade_played:
		fade_played = true
		$grnd.play()
		$"../fade".visible = true
		fade_anim.play("fade")
		velocity.y = 0
		gravity = 2000
		is_dead = true

func _on_fade_anim_animation_finished(anim_name):
	if anim_name == "fade":
		$"../fade".visible = false
