extends Area3D

#simulate gravity
@export var gravity_strength = -9.8
@export var item_image_path = "res://Alchemy/images/deafult_alchemy_item.png"
@export var item_name = "Alchemy Item"

signal item_picked_up

var world_instance = null
var velocity = Vector3.ZERO
var player_inventory = null
var is_on_ground = false

func _ready():
	world_instance = get_tree().get_root().get_node("World")
	velocity = Vector3.ZERO
	self.name = item_name
	item_picked_up.connect(_on_item_picked_up)
	

func _physics_process(delta):
	if not is_on_ground:
		 # Apply gravity to the velocity
		velocity.y += gravity_strength * delta

		# Update the position of the Area3D
		translate(velocity * delta)
	velocity.y = 0

func _on_body_entered(body):
	if body.name == "Player":
		world_instance.debug_print(str("player picked up " + item_name))
		emit_signal("item_picked_up", body)
	else:
		if body.name == "Ground":
			is_on_ground = true

func _on_item_picked_up(player):
	player.item_picked_up_helper(item_name, item_image_path)
	queue_free()
