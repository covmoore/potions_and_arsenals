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
				elif parent_name.begins_with("Ingredient"):
					handle_ingredients_click()
				else:
					print(parent_name)

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

func handle_inventory_click():
	world_instance.debug_print("click came from inventory")
	

func handle_ingredients_click():
	world_instance.debug_print("click came from ingredients")
