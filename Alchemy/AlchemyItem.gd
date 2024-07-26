extends Area3D

#simulate gravity
@export var gravity_strength = -9.8
@export var item_image_path = "res://Alchemy/images/deafult_alchemy_item.png"

signal item_picked_up
var velocity = Vector3.ZERO
var player_inventory = null
var is_on_ground = false

func _ready():
	velocity = Vector3.ZERO
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
		emit_signal("item_picked_up", body)
	else:
		if body.name == "Ground":
			is_on_ground = true

func _on_item_picked_up(player):
	var this_item_name = name
	player.item_picked_up_helper(name, item_image_path)
	queue_free()
