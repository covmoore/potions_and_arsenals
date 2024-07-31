extends CharacterBody3D

enum PLAYER_STATE {
	ACTIVE,
	INVENTORY,
	ALCHEMY,
	PAUSED,
	DEAD
}

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
var max_health = 5

var original_camera_position = Vector3.ZERO
var isAlive = true
var isByPhilsopherTable = false
var isByPhilsopherTable = false
var health = max_health
var mouse_mode = "captured"
var current_state = PLAYER_STATE.ACTIVE
var time_last_hit = 0
var hit_to_heal_delay = 15
var heal_delay = 5
var last_healed = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bullet = load("res://model_scenes/handgun_projectile.tscn")
var bullet_instance

signal player_hit
signal player_died
signal player_healed

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var gun = $Head/Camera3D/TemHandGun
@onready var gun_anim = $Head/Camera3D/TemHandGun/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/TemHandGun/RayCast3D
@onready var player_ui = $"../PlayerUI"
@onready var player_inventory = $"../PlayerUI/CanvasLayer/Inventory"
@onready var stairs_below_raycast = $StairsBelowRaycast

func _ready():
	camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_state = PLAYER_STATE.ACTIVE

func pause_game():
	current_state = PLAYER_STATE.PAUSED
	Engine.time_scale = 0
	player_ui.setPaused(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_mode = "visible"

func resume_game():
	current_state = PLAYER_STATE.ACTIVE
	Engine.time_scale = 1
	player_ui.setPaused(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_mode = "captured"

func toggle_pause():
	if current_state == PLAYER_STATE.PAUSED:
		resume_game()
	else:
		pause_game()

func _unhandled_input(event):
	if event is InputEventMouseMotion and isAlive == true and current_state == PLAYER_STATE.ACTIVE:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-45), deg_to_rad(60))
		
	if Input.is_action_just_pressed("pause") and current_state != PLAYER_STATE.DEAD:
		toggle_pause()

var _was_on_floor_last_frame = false
var _snapped_to_stairs_last_frame = false
#func _snap_down_to_stairs_check():
	#var did_snap = false
	#if not is_on_floor() and velocity.y <= 0 and (_was_on_floor_last_frame or _snapped_to_stairs_last_frame) and stairs_below_raycast.is_colliding():
		#var body_test_result = PhysicsTestMotionResult3D.new()
		#var params = PhysicsTestMotionParameters3D.new()
		#var max_step_down = -0.5
		#params.from = global_transform
		#params.motion = Vector3(0,max_step_down,0)
		#if PhysicsServer3D.body_test_motion(get_rid(), params, body_test_result):
			#var translate_y = body_test_result.get_travel().y
			#position.y += translate_y
			#apply_floor_snap()
			#did_snap = true
	#_was_on_floor_last_frame = is_on_floor()
	#_snapped_to_stairs_last_frame = did_snap
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if isAlive == true and current_state == PLAYER_STATE.ACTIVE:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if Input.is_action_just_pressed("shoot") and current_state == PLAYER_STATE.ACTIVE:
			if !gun_anim.is_playing():
				gun_anim.play("Shoot")
				bullet_instance = bullet.instantiate()
				bullet_instance.position = gun_barrel.global_position
				bullet_instance.basis = gun_barrel.global_transform.basis
				get_parent().add_child(bullet_instance)
				
		move_and_slide()
		#_snap_down_to_stairs_check()
		check_heal()

func hit(dmg):
	health -= dmg
	time_last_hit = Time.get_ticks_msec() / 1000.0
	if health <= 0:
		health = 0
		player_dead()
	emit_signal("player_hit", health)
	
func item_picked_up_helper(item_name, item_image):
	player_inventory.add_item(item_name, item_image)

func player_dead():
	isAlive = false
	current_state = PLAYER_STATE.DEAD
	if player_ui.inventory_ui.visible:
		player_ui.inventory_ui.visible = false
	emit_signal("player_died")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func check_heal():
	if health < max_health:
		var time = Time.get_ticks_msec() / 1000.0
		if time > time_last_hit + hit_to_heal_delay:
			if time > last_healed + heal_delay:
				last_healed = Time.get_ticks_msec() / 1000.0
				health += 1
				if health >= max_health:
					health = max_health
				emit_signal("player_healed", health)
			
