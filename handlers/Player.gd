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
var isAlive = true
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
@onready var gun_anim = $Head/Camera3D/TemHandGun/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/TemHandGun/RayCast3D
@onready var player_ui = $"../PlayerUI"
@onready var player_inventory = $"../PlayerUI/CanvasLayer/Inventory"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_state = PLAYER_STATE.ACTIVE

func pause_game():
	current_state = PLAYER_STATE.PAUSED
	Engine.time_scale = 0
	player_ui.paused_text.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_mode = "visible"
	if player_ui.inventory_ui.visible:
		player_ui.inventory_ui.visible = false

func resume_game():
	current_state = PLAYER_STATE.ACTIVE
	Engine.time_scale = 1
	player_ui.paused_text.visible = false
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
		
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
		
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
		check_heal()

func hit(dmg):
	health -= dmg
	time_last_hit = Time.get_ticks_msec() / 1000.0
	if health <= 0:
		health = 0
		isAlive = false
		if player_ui.inventory_ui.visible:
			player_ui.inventory_ui.visible = false
		emit_signal("player_died")
	emit_signal("player_hit", health)
	
func item_picked_up_helper(item_name, item_image):
	player_inventory.add_item(item_name, item_image)

func check_heal():
	if health < max_health:
		var time = Time.get_ticks_msec() / 1000.0
		if time > time_last_hit + hit_to_heal_delay:
			if time > last_healed + heal_delay && health < max_health:
				last_healed = Time.get_ticks_msec() / 1000.0
				health += 1
				if health >= max_health:
					health = max_health
				emit_signal("player_healed", health)
			
