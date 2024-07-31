extends Control

var world_instance = null

func _ready():
	world_instance = get_tree().get_root().get_node("World")

func setItemTexture(item_image_path):
	self.texture = load(item_image_path)

func incrementCount():
	var count = get_child(0)
	count.text = str(int(count.text) + 1)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			world_instance.debug_print(str(self.name + " was clicked"), true)
			var player = world_instance.player_instance
			if player.current_state == player.PLAYER_STATE.ALCHEMY:
				#First check if the click is coming from the inventory or the ingredients
				var parent_name = self.get_parent().name
				if parent_name.begins_with("Inventory"):
					handle_inventory_click()

func get_inventory_slot_index(parnet_node, slot_node_name) -> int:
	var idx = -1
	for i in range(parnet_node.get_child_count()):
		if parnet_node.get_child(i).name == slot_node_name:
			idx = i
			return idx
	return idx

func get_ingredient_slot_index(parent_node, slot_node_name) -> int:
	var idx = -1
	for i in range(parent_node.get_child_count()):
		if parent_node.get_child(i).name.split(" ").size() == 2:
			if parent_node.get_child(i).name.split(" ")[1] == slot_node_name:
				idx = i
				return idx
	return idx
	
func fit_mesh_in_collider(mesh_instance: MeshInstance3D, collider: CollisionShape3D):
	# Get the AABB (Axis-Aligned Bounding Box) of the mesh
	var mesh_aabb = mesh_instance.get_aabb()
	var mesh_size = mesh_aabb.size

	# Get the extents of the collider shape
	var collider_shape = collider.shape
	var collider_size: Vector3

	if collider_shape is BoxShape3D:
		collider_size = (collider_shape as BoxShape3D).extents * 2  # BoxShape3D uses extents, which are half-sizes
	elif collider_shape is SphereShape3D:
		var radius = (collider_shape as SphereShape3D).radius
		collider_size = Vector3(radius * 2, radius * 2, radius * 2)
	elif collider_shape is CapsuleShape3D:
		var capsule_shape = collider_shape as CapsuleShape3D
		collider_size = Vector3(
			capsule_shape.radius * 2, 
			capsule_shape.height, 
			capsule_shape.radius * 2
		)
	else:
		print("Unsupported collider shape")
		return

	# Calculate the scale factor for each axis
	var scale_factor = Vector3(
		collider_size.x / mesh_size.x,
		collider_size.y / mesh_size.y,
		collider_size.z / mesh_size.z
	)

	# Use the smallest scale factor to ensure the mesh fits within the collider
	var min_scale = min(scale_factor.x, scale_factor.y, scale_factor.z)

	# Apply the scale factor to the mesh
	mesh_instance.scale = Vector3(min_scale, min_scale, min_scale)

	# Optionally, center the mesh within the collider
	var mesh_center = mesh_aabb.position + mesh_aabb.size / 2
	var collider_center = collider.global_transform.origin  # Adjust based on your scene hierarchy
	mesh_instance.global_transform.origin = collider_center - mesh_center * min_scale

	
func add_mesh_to_table(mesh_path, ingredient_slot):
	var mesh = ResourceLoader.load(mesh_path)
	if mesh:
		ingredient_slot.get_child(0).mesh = mesh
		fit_mesh_in_collider(ingredient_slot.get_child(0), ingredient_slot)
		ingredient_slot.get_child(0).name = mesh_path.split("/")[4].split(".")[0]
		
	
func get_item_mesh_path(item) -> String:
	var item_texture = item.texture
	var texture_path = item_texture.resource_path
	var mesh_path_prefix = "res://Alchemy/meshes/"
	var item_name = texture_path.split("/")[4].split(".")[0]
	var mesh_path_suffix = ".tres"
	return str(mesh_path_prefix + item_name + mesh_path_suffix)
	
func can_add_item(item_name, item_count, slots) -> bool:
	#count how many of current item on table
	var count = 0
	for slot in slots:
		if slot.get_child(0).name == item_name:
			count += 1
	return count < item_count

func handle_inventory_click():
	#check if empty ingredients slot on table
	var ingredients_slots = get_tree().get_root().get_node("World/Map/PhilosopherTable/Ingredients")
	for slot in ingredients_slots.get_children():
		if slot.get_child(0).name == "IngredientMeshEmpty":
			var item_mesh_path = get_item_mesh_path(self)
			#check if player has enough in inventory to add item
			var item_name = item_mesh_path.split("/")[4].split(".")[0]
			var item_count = int(self.get_child(0).text)
			if can_add_item(item_name, item_count, ingredients_slots.get_children()):
				add_mesh_to_table(item_mesh_path, slot)
			break
	
func handle_ingredients_click():
	world_instance.debug_print("click came from ingredients")
