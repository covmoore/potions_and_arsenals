extends Area3D

#simulate gravity
@export var gravity_strength = -1080
var velocity = Vector3.ZERO
var is_on_ground = false

func _ready():
	velocity = Vector3.ZERO
	

func _physics_process(delta):
	if not is_on_ground:
		 # Apply gravity to the velocity
		velocity.y += gravity_strength * delta

		# Update the position of the Area3D
		translate(velocity * delta)
	velocity.y = 0

func _on_body_entered(body):
	if body is CharacterBody3D or body is RigidBody3D:
		print("Collision detected with: ", body.name)
	else:
		if body.name == "Ground":
			is_on_ground = true
