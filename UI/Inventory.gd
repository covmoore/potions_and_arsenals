extends GridContainer

var inventory = []

signal item_picked_up

func _ready():
	for child in get_children():
		inventory.append(child)

func get_items() -> Array:
	var items = []
	for item in inventory:
		items.append(item)
	return items

func remove_item(item_image):
	for i in range (get_child_count()):
		print(get_child(i).name)
		if get_child(i).get_child(0).has_node("TextureRect"):
			if get_child(i).get_child(0).texture.resource_path == item_image:
				var empty_slot = ResourceLoader.load("res://scenes/slot.tscn")
				if empty_slot:
					var empty_slot_instance = empty_slot.instantiate()
					get_child(i).remove_child(get_child(i).get_child(0))
					get_child(i).add_child(empty_slot_instance)
					inventory[i] = empty_slot_instance
					break

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
