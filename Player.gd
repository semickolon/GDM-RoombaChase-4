extends KinematicBody2D

export var move_speed := 100.0

func _physics_process(delta):
	var move_dir = Vector2.ZERO;
	
	if Input.is_action_pressed("move_left"):
		move_dir += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		move_dir += Vector2.RIGHT
	if Input.is_action_pressed("move_up"):
		move_dir += Vector2.UP
	if Input.is_action_pressed("move_down"):
		move_dir += Vector2.DOWN
	
	if move_dir != Vector2.ZERO:
		move_and_slide(move_dir * move_speed, Vector2.UP);
		rotation += Vector2(cos(rotation), sin(rotation)).angle_to(move_dir) * 0.23
