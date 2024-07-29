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

func get_inventory_slot_index(inventory_parnet_node, slot_node_name) -> int:
	var idx = -1
	for i in range(inventory_parnet_node.get_child_count()):
		if inventory_parnet_node.get_child(i).name == slot_node_name:
			idx = i
			return idx
	return idx

func handle_inventory_click():
	world_instance.debug_print("click came from inventory", true)
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
				#remove both nodes from their parents
				parent_invenotry_node.remove_child(self)
				ingredients_slots.remove_child(current_slot)
				#add the cureent slot node to the inventory
				parent_invenotry_node.add_child(current_slot)
				parent_invenotry_node.move_child(current_slot, inventory_slot_idx)
				#create a control node to hold this node
				var control_node = Control.new()
				control_node.set_custom_minimum_size(Vector2(80,80))
				control_node.name = "Ingredient" + self.name
				ingredients_slots.add_child(control_node)
				control_node.add_child(self)
				ingredients_slots.move_child(control_node, ingredient_slot_index)
				break
		
	#for slot in ingredients_slots.get_children():
		##check if any of the slots are empty
		#if slot.name.begins_with("Ingredient"):
			##swap the clicked slot with the ingredients slot
			#var temp_slot = slot.duplicate()
			#var parent_inventory = self.get_parent()
			#parent_inventory.remove_child(self)
			#ingredients_slots.add_child(self)
			#ingredients_slots.remove_child(slot)
			#parent_inventory.add_child(temp_slot)
			#break

func handle_ingredients_click():
	world_instance.debug_print("click came from ingredients")
