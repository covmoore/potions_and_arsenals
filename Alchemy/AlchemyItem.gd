extends Area3D

@export var gravity_strength = -9.8

signal item_picked_up

var world_instance = null

var velocity = Vector3.ZERO
var player_inventory = null
var is_on_ground = false
var elapsed_time: float = 0.0

#Dynamic properties
var item_name : String
var item_image_path : String
var item_collider_path : String
var item_mesh_path: String

func rotation_helper(r: Vector3, mesh):
	var rotation_degrees = r
	var rotation_radians = rotation_degrees * deg_to_rad(1.0)
	mesh.transform.basis = Basis().rotated(
		Vector3(1, 0, 0), rotation_radians.x) * Basis().rotated(Vector3(0, 1, 0), 
		rotation_radians.y) * Basis().rotated(Vector3(0, 0, 1), 
		rotation_radians.z)
		
func scale_helper(s: Vector3, mesh):
	var scaled_basis = mesh.transform.basis.scaled(s)
	mesh.transform.basis = scaled_basis

func initialize_properties(item_name: String, item_image_path: String, item_collider_path : String, item_mesh_path: String):
	self.item_name = item_name
	self.item_image_path = item_image_path
	self.item_collider_path = item_collider_path
	self.item_mesh_path = item_mesh_path
	
	world_instance.debug_print(str(self.item_name))
	world_instance.debug_print(str(self.item_image_path))
	world_instance.debug_print(str(self.item_collider_path))
	world_instance.debug_print(str(self.item_mesh_path))
	
	var collider_instance = $CollisionShape3D
	if collider_instance:
		if item_collider_path != "":
			var collider = ResourceLoader.load(item_collider_path)
			if collider:
				collider_instance.shape = collider
		else:
			world_instance.debug_print(str("Error: Failed to load mesh from path: " + item_mesh_path))
	else:
		world_instance.debug_print(str("Error: MeshInstance3D node not found or item_mesh_path is empty."))
	
	var mesh_instance = $MeshInstance3D
	if mesh_instance:
		if item_mesh_path != "":
			var mesh = ResourceLoader.load(item_mesh_path)
			if mesh:
				mesh_instance.mesh = mesh
				#Edit specific meshes sizes and scales
				if item_name == "Hourglass":
					mesh_instance.transform.origin = Vector3(0, .5, 0)
					scale_helper(Vector3(0.25, 0.25, 0.25), mesh_instance)
				elif item_name == "Sea Shell":
					mesh_instance.transform.origin = Vector3(.33,-.5,0)
					rotation_helper(Vector3(90,-90,0), mesh_instance)
					scale_helper(Vector3(0.05,0.05,0.05), mesh_instance)
				elif item_name == "Sugar Water":
					mesh_instance.transform.origin = Vector3(0,0.5,0)
					rotation_helper(Vector3(90,0,0), mesh_instance)
					scale_helper(Vector3(0.125, 0.125, 0.125), mesh_instance)
				elif item_name == "Amethyst":
					rotation_helper(Vector3(90,0,0), mesh_instance)
					scale_helper(Vector3(0.33, 0.33, 0.33), mesh_instance)
				elif item_name == "Diamond":
					rotation_helper(Vector3(180,0,0), mesh_instance)
					scale_helper(Vector3(0.25, 0.25, 0.25), mesh_instance)
				elif item_name == "Fairy Wings":
					rotation_helper(Vector3(90,90,0), mesh_instance)
					scale_helper(Vector3(0.075, 1, 0.075), mesh_instance)
				elif item_name == "Burning Flower":
					rotation_helper(Vector3(90,0,0), mesh_instance)
					scale_helper(Vector3(.9,.129,.129), mesh_instance)
				elif item_name == "Pegasus Horn":
					scale_helper(Vector3(0.025,0.025,0.025), mesh_instance)
				elif item_name == "Toxic Sludge":
					mesh_instance.transform.origin = Vector3(0,-0.75,0)
				elif item_name == "Ether Crystal":
					rotation_helper(Vector3(90,0,0), mesh_instance)
					scale_helper(Vector3(.5,.5,.5), mesh_instance)
		else:
			world_instance.debug_print(str("Error: Failed to load mesh from path: " + item_mesh_path))
	else:
		world_instance.debug_print(str("Error: MeshInstance3D node not found or item_mesh_path is empty."))

func _ready():
	world_instance = get_tree().get_root().get_node("World")
	velocity = Vector3.ZERO
	self.name = item_name
	item_picked_up.connect(_on_item_picked_up)
	
func _process(delta):
	elapsed_time += delta
	if $MeshInstance3D.material_override is ShaderMaterial and item_name in ["Pegasus Horn", "Void Dust", "Ether Crystal", "Demon Blood"]:
			$MeshInstance3D.material_override.set_shader_param("time", elapsed_time)

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
