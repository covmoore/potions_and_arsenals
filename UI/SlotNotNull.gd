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
				elif parent_name.begins_with("Ingredients"):
					handle_ingredients_click()

func handle_inventory_click():
	world_instance.debug_print("click came from inventory", true)
	#check if there is empty slot in the ingredients
	var ingredients_slots = self.get_tree().get_root().get_node("World/PlayerUI/CanvasLayer/AlchemyPanel/IngredientsMarginContainer/IngredientsHBoxContainer/Ingredients")
	for slot in ingredients_slots.get_children():
		#check if any of the slots are empty
		if slot.name.begins_with("Ingredient"):
			#swap the clicked slot with the ingredients slot
			var temp_slot = slot.duplicate()
			var parent_inventory = self.get_parent()
			parent_inventory.remove_child(self)
			ingredients_slots.add_child(self)
			ingredients_slots.remove_child(slot)
			parent_inventory.add_child(temp_slot)
			break

func handle_ingredients_click():
	world_instance.debug_print("click came from ingredients", true)
