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
	#check if there is empty slot in the ingredients
	var ingredients_slots = self.get_tree().get_root().get_node("World/PlayerUI/CanvasLayer/AlchemyPanel/IngredientsMarginContainer/IngredientsHBoxContainer/Ingredients")
	
	for i in range(ingredients_slots.get_child_count()):
		var current_slot = ingredients_slots.get_child(i)
		#first check if there if the slot is empty
		if current_slot.name.begins_with("Ingredient"):
			#store the index of the ingredient slot
			var ingredient_slot_index = i
			#swap the slot with ingredients slot
			#get the index of self within parent
			var parent_invenotry_node = self.get_parent()
			var inventory_slot_idx = get_inventory_slot_index(parent_invenotry_node, self.name)
			if inventory_slot_idx != -1:
				#check count of inventory_item
				var item_count = int((self.get_child(0).text))
				var has_more_than_1_of_item = item_count > 1
				if not has_more_than_1_of_item:
					#remove both nodes from their parents
					parent_invenotry_node.remove_child(self)
					ingredients_slots.remove_child(current_slot)
					#add the cureent slot node to the inventory
					parent_invenotry_node.add_child(current_slot)
					parent_invenotry_node.move_child(current_slot, inventory_slot_idx)
				else:
					#remove 1 from item count
					self.get_child(0).text = str(int((self.get_child(0).text)) - 1)
					current_slot.queue_free()
				#create a control node to hold this node
				var control_node = Control.new()
				control_node.set_custom_minimum_size(Vector2(80,80))
				control_node.name = "Ingredient " + self.name
				ingredients_slots.add_child(control_node)
				control_node.add_child(self.duplicate())
				ingredients_slots.move_child(control_node, ingredient_slot_index)
				if has_more_than_1_of_item:
					control_node.get_child(0).get_child(0).text = "1"
				break

func handle_ingredients_click():
	world_instance.debug_print("click came from ingredients", true)
	#move the item back to the inventory
	var inventory_slots = self.get_tree().get_root().get_node("World/PlayerUI/CanvasLayer/AlchemyPanel/InventoryMarginContainer/InventoryHBoxContainer/InventoryVBoxContainer/Inventory")
	
	for i in range(inventory_slots.get_child_count()):
		var current_slot = inventory_slots.get_child(i)
		if current_slot.name.begins_with("Ingredient"):
			var inventory_slot_index = i
			var parent_ingredient_node = self.get_parent().get_parent()
			var ingredient_slot_idx = get_ingredient_slot_index(parent_ingredient_node, self.name)
			if ingredient_slot_idx != -1:
				#remove both nodes from their parents
				var parent = self.get_parent()
				parent_ingredient_node.remove_child(parent)
				inventory_slots.remove_child(current_slot)
				#add the current slot node to the inventory
				parent_ingredient_node.add_child(current_slot)
				parent_ingredient_node.move_child(current_slot, ingredient_slot_idx)

				parent.remove_child(self)
				inventory_slots.add_child(self)
				inventory_slots.move_child(self, inventory_slot_index)
				parent.queue_free()
				break
