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
	if player_instance != null && rng != null && spawn_areas != null:
		var randNum = rng.randi_range(0, enemy_spawn_areas.get_child_count()-1)
		var spawn = spawn_areas[randNum]
		
		if enemy_count <= ENEMY_NUM_TRIGGER && enemy_spawn_state == SPAWN_STATE.NO_SPAWN:
			if delay_created == false:
				spawn_delay = rng.randi_range(0.5, 2)
				delay_created = true
			enemy_spawn_state = SPAWN_STATE.SPAWN
		if enemy_spawn_state == SPAWN_STATE.SPAWN:
			timer += delta
			if timer >= spawn_delay:
				timer = 0.0
				print("create enemy!")
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
				enemy_spawn_state = SPAWN_STATE.NO_SPAWN
				delay_created = false
			
func _on_enemy_enemy_died():
	enemy_count -= 1
