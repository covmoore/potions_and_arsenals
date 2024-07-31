extends Node3D

enum DIFFICULTY {
	PEACEFUL,
	NORMAL
}

enum DEBUG_LEVEL {
	PRODUCTION,
	DEBUG,
	OBNOXIOUS
}

enum SPAWN_STATE {
	NO_SPAWN,
	SPAWN
}

var game_difficulty = DIFFICULTY.NORMAL
var debug_level = DEBUG_LEVEL.PRODUCTION
var enemy_spawn_state = SPAWN_STATE.NO_SPAWN 
	
@onready var player_spawn_point = $PlayerSpawnPoint
@onready var enemy_spawn_areas = $enemy_spawn_areas

var player = load("res://model_scenes/player.tscn")
var player_instance = null
var enemy = load("res://model_scenes/temp_enemy.tscn")
var game_timer = 0
var rng = null
var spawn_areas = null
var spawn_timer = 0.0
var wave_timer = 0.0
var max_enemies = 5
var enemy_increment = 3
const min_enemies = 0
var enemy_count = 0
var spawn_delay = 2.0
var wave_spawn_delay = 12.0
var delay_created = false

var enemies_killed = 0
var points = 0


signal player_created
# Called when the node enters the scene tree for the first time.
func _ready():
	game_timer = 0
	Engine.time_scale = 1
	delay_created = false
	enemy_spawn_state = SPAWN_STATE.NO_SPAWN
	game_difficulty = DIFFICULTY.NORMAL
	debug_level = DEBUG_LEVEL.DEBUG
	player_spawn_point.visible = false
	player_instance = player.instantiate()
	player_instance.connect("player_received_points", _on_player_received_points)
	player_instance.position = player_spawn_point.global_position
	player_instance.basis = player_spawn_point.global_transform.basis
	add_child(player_instance)
	emit_signal("player_created", player_instance.get_path())
	spawn_areas = enemy_spawn_areas.get_children()
	rng = RandomNumberGenerator.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	game_timer = Time.get_ticks_msec() / 1000.00
	if player_instance != null && rng != null && spawn_areas != null:
		var randNum = rng.randi_range(0, enemy_spawn_areas.get_child_count()-1)
		var spawn = spawn_areas[randNum]
		if enemy_count <= min_enemies && enemy_spawn_state == SPAWN_STATE.NO_SPAWN:
			if delay_created == false:
				spawn_delay = rng.randf_range(1, 3)
				delay_created = true
				max_enemies += enemy_increment
			enemy_spawn_state = SPAWN_STATE.SPAWN
		if enemy_spawn_state == SPAWN_STATE.SPAWN && delay_created == true:
			spawn_timer += delta
			wave_timer += delta
			if spawn_timer >= spawn_delay and wave_timer >= wave_spawn_delay:
				spawn_timer = 0.0
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
				enemy_instance.connect("enemy_died", _on_enemy_enemy_died)
				enemy_count += 1
			if enemy_count >= max_enemies:
				wave_timer = 0.0
				enemy_spawn_state = SPAWN_STATE.NO_SPAWN
				delay_created = false
			
func _on_enemy_enemy_died():
	enemy_count -= 1
	enemies_killed += 1

func _on_player_received_points(cur_points):
	points = cur_points

#Prints a message based on debug level
func debug_print(msg, obnoxious_print:bool = false):
	if debug_level == DEBUG_LEVEL.DEBUG:
		if not obnoxious_print:
			print(msg)
	elif debug_level == DEBUG_LEVEL.OBNOXIOUS:
		print(msg)
