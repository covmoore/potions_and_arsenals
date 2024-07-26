extends GridContainer

var inventory = []

func _ready():
	for child in get_children():
		inventory.append(child)

func add_item(item_name, item_image):
	var item_added = false
	
	#check if item already exist in inventory
	for slot in inventory:
		if slot.get_child_count() > 0:
			var child = slot.get_child(0)
			if child.name == item_name:
				child.incrementCount()
				item_added = true
				break
	#if not check for an empty slot
	if not item_added:
		for i in range(inventory.size()):
			var slot = inventory[i]
			if slot.get_child_count() > 0 and slot.get_child(0).name == "Null Item":
				# Load the new slot scene
				var new_slot = load("res://scenes/SlotNotNull.tscn")
				if new_slot:
					var new_slot_instance = new_slot.instantiate()
					# Replace the empty slot with the new slot instance
					slot.remove_child(slot.get_child(0))  # Remove the empty slot's child
					slot.add_child(new_slot_instance)  # Add the new slot instance
					# Set the new slot properties
					new_slot_instance.name = item_name
					new_slot_instance.setItemTexture(item_image)
					
					# Update the inventory array
					inventory[i] = slot
					break  # Exit the loop after adding the item
