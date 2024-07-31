extends GridContainer

var inventory = []

signal item_picked_up

func _ready():
	for child in get_children():
		inventory.append(child)
	#TODO delete the following lines once philosopher table works
	add_item("Hourglass", "res://Alchemy/images/hourglass.png")
	#add_item("Hourglass", "res://Alchemy/images/hourglass.png")
	add_item("Fairy Wings", "res://Alchemy/images/fairy_wings.png")

func get_items() -> Array:
	var items = []
	for item in inventory:
		items.append(item)
	return items

func add_item(item_name, item_image):
	var item_added = false
	emit_signal("item_picked_up", item_name)
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
					slot.remove_child(slot.get_child(0)) 
					slot.add_child(new_slot_instance) 
					# Set the new slot properties
					new_slot_instance.name = item_name
					new_slot_instance.setItemTexture(item_image)
					
					# Update the inventory array
					inventory[i] = slot
					break  
