extends Node3D

@onready var player_spawn_point = $PlayerSpawnPoint

var player = load("res://model_scenes/player.tscn")
signal player_created
# Called when the node enters the scene tree for the first time.
func _ready():
	var player_instance = player.instantiate()
	player_instance.position = player_spawn_point.global_position
	player_instance.basis = player_spawn_point.global_transform.basis
	add_child(player_instance)
	emit_signal("player_created")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
