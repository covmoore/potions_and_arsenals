extends Node3D

@onready var world = $"../.."
@onready var playerUI = $"../../PlayerUI"
@onready var playerInventory = $"../../PlayerUI/CanvasLayer/Inventory"
@onready var philosopherTableInventory = $"../../PlayerUI/CanvasLayer/PhilosopherMenu/PhilosopherPanel/Inventory"
@onready var philosopherCamera = $PhilosopherCamera
var player = null

func _ready():
	world.debug_print("Trying to access philosopherCamera", true)
	if philosopherCamera:
		world.debug_print("philosopherCamera found")
		philosopherCamera.current = false
	else:
		world.debug_print("philosopherCamera not found")

func match_player_inevntory(items: Array):
	for item in items:
		if item.get_child(0).name == "Null Item":
			var nil_slot = ResourceLoader.load("res://scenes/slot.tscn")
			if nil_slot:
				var nil_slot_instance = nil_slot.instantiate()
				philosopherTableInventory.add_child(nil_slot_instance)
		else:
			var slot_not_null = ResourceLoader.load("res://scenes/SlotNotNull.tscn")
			if slot_not_null:
				var item_name = item.get_child(0).name
				var item_count = item.get_child(0).get_child(0).text
				var item_texture = item.get_child(0).texture
				var slot_not_null_instance = slot_not_null.instantiate()
				if item_texture:
					slot_not_null_instance.setItemTexture(item_texture.resource_path)
				slot_not_null_instance.name = item_name
				slot_not_null_instance.get_child(0).text = item_count
				philosopherTableInventory.add_child(slot_not_null_instance)

func setup_philosopher_table():
	# Clear the philosopher table inventory by removing all children
	for child in philosopherTableInventory.get_children():
		child.queue_free()
	
	var player_items = playerInventory.get_items()
	match_player_inevntory(player_items)

func end_alchemy_session():
	#wipe the ingredients if any are left in ingredients table
	for slot in $Ingredients.get_children():
		if slot.get_child(0).name != "IngredientMeshEmpty":
			slot.get_child(0).mesh = null
			slot.get_child(0).name = "IngredientMeshEmpty"


func _on_area_3d_body_entered(body):
	if body.name == "Player":
		player = body
		player.isByPhilsopherTable = true
		playerUI.interact_text.visible = true


func _on_area_3d_body_exited(body):
	if body.name == "Player":
		if player != null:
			player.isByPhilsopherTable = false
			if player.current_state == player.PLAYER_STATE.ALCHEMY:
				player.current_state = player.PLAYER_STATE.ACTIVE
				world.debug_print(player.current_state)
		playerUI.interact_text.visible = false
