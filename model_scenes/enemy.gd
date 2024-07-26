extends CharacterBody3D

var health = 5
const SPEED = 3.0
const ATTACK_RANGE = 1
var last_attacked = 0
const HIT_SPEED = 2000

var player = null

@onready var nav_agent = $NavigationAgent3D
@onready var collider = $CollisionShape3D
@onready var world = $".."

signal enemy_died

func _ready():
	pass
	
func _process(delta):
	if world.game_difficulty != world.DIFFICULTY.PEACEFUL && player != null:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		move_and_slide()
		if _target_in_range():
			var current_time = Time.get_ticks_msec()
			if abs(current_time - last_attacked) > HIT_SPEED:
				player.hit(1)
				last_attacked = Time.get_ticks_msec()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func hit(dmg):
	health -= dmg
	if(health <= 0):
		emit_signal("enemy_died")
		var alchemyItem = ResourceLoader.load("res://scenes/alchemy_item.tscn")
		if alchemyItem:
			var alchemy_item_instance = alchemyItem.instantiate()
			world.add_child(alchemy_item_instance)
			alchemy_item_instance.global_transform.origin = global_transform.origin
		queue_free()

func _on_world_player_created(player_path):
	player = get_node(player_path)
