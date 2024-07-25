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

func _ready():
	pass
	
func _process(delta):
	if world.game_difficulty != world.DIFFICULTY.PEACEFUL:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
	if player != null:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		move_and_slide()
		if _target_in_range():
			print("IS IN RANGE")
			var current_time = Time.get_ticks_msec()
			if abs(current_time - last_attacked) > HIT_SPEED:
				player.hit(1)
				last_attacked = Time.get_ticks_msec()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func hit(dmg):
	health -= dmg
	if(health <= 0):
		queue_free()


func _on_world_player_created(player_path):
	player = get_node(player_path)
