extends Node2D

onready var nav = $Navigation2D
onready var player = $Player
onready var opponent = $Opponent
onready var line = $Line2D

func _ready():
	opponent.connect("player_seen", self, "_on_player_seen")

func _on_player_seen():
	var path = nav.get_simple_path(opponent.global_position, player.global_position, false)
	line.points = path
	opponent.follow_path(path)
