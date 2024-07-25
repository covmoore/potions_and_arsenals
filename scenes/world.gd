extends Node3D

enum DIFFICULTY {
	PEACEFUL,
	NORMAL
}

var game_difficulty = DIFFICULTY.NORMAL


func _ready():
	game_difficulty = DIFFICULTY.PEACEFUL
@onready var player_spawn_point = $PlayerSpawnPoint
@onready var enemy_spawn_areas = $enemy_spawn_areas

var player = load("res://model_scenes/player.tscn")
var player_instance = null
var enemy = load("res://model_scenes/temp_enemy.tscn")
var rng = null
var spawn_areas = null
var timer = 0.0

signal player_created
# Called when the node enters the scene tree for the first time.
func _ready():
	player_spawn_point.visible = false
	player_instance = player.instantiate()
	player_instance.position = player_spawn_point.global_position
	player_instance.basis = player_spawn_point.global_transform.basis
	add_child(player_instance)
	emit_signal("player_created", player_instance.get_path())
	spawn_areas = enemy_spawn_areas.get_children()
	rng = RandomNumberGenerator.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_instance != null && rng != null && spawn_areas != null:
		var randNum = rng.randi_range(0, enemy_spawn_areas.get_child_count()-1)
		var spawn = spawn_areas[randNum]
		timer += delta
		if timer >= 2.0:
			timer = 0.0
			var enemy_instance = enemy.instantiate()
			var halfHeightX = ((spawn.scale.x) * sqrt(2)) / 4
			var halfHeightZ = ((spawn.scale.z) * sqrt(2)) / 4
			enemy_instance.position = Vector3(
				rng.randi_range(spawn.global_position.x - halfHeightX, spawn.global_position.x + halfHeightX), 
				spawn.global_position.y + (enemy_instance.scale.y / 2),
				rng.randi_range(spawn.global_position.z - halfHeightZ, spawn.global_position.z + halfHeightZ)
			)
			enemy_instance.basis = player_instance.transform.basis
			enemy_instance.player = player_instance
			add_child(enemy_instance)
		#enemy.postion = Vector3(spawn.get_child_node($MeshInstance3D).shape.radius)
