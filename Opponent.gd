extends Node2D

signal player_seen()

enum State {
	PATROL,
	ATTACK,
	LOST
}

const Player = preload("res://Player.gd")

export var move_speed := 100.0

onready var raycast = $RayCast2D
onready var timer = $Timer
onready var lose_timer = $LoseTimer

onready var _player = $"../Player"

var _path: PoolVector2Array
var _path_idx = -1
var _state = State.PATROL

func _ready():
	timer.connect("timeout", self, "_on_timeout")

func _process(delta):
	if _path == null or _path_idx < 0:
		return
	
	var point: Vector2 = _path[_path_idx]
	
	if point.distance_to(global_position) < 2:
		_path_idx += 1
		if _path_idx == _path.size():
			_path_idx = -1
		return
	
	var move_dir: Vector2 = global_position.direction_to(point)
	global_position += move_dir * move_speed * delta
	rotation += transform.x.angle_to(move_dir) * 0.23

func follow_path(path: PoolVector2Array):
	_path = path
	_path_idx = 0

func _on_timeout():
	if _state == State.PATROL:
		if _player and _can_raycast_to(_player):
			_state = State.ATTACK
			lose_timer.start()
			emit_signal("player_seen")
	elif _state == State.ATTACK and _player:
		if lose_timer.time_left > 0:
			if _can_raycast_to(_player):
				lose_timer.start()
			emit_signal("player_seen")
		else:
			_state = State.PATROL
	elif _state == State.LOST:
		pass

func _can_raycast_to(target: Node2D, fov: float = deg2rad(90)) -> bool:
	var cast_to = target.global_position - global_position
	var ang = abs(transform.x.angle_to(cast_to))
	if ang > fov / 2:
		return false
	
	raycast.cast_to = cast_to
	raycast.global_rotation = 0
	raycast.force_raycast_update()
	return raycast.get_collider() == target
