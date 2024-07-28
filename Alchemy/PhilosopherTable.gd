extends Area3D

@onready var world = $"../.."
@onready var playerUI = $"../../PlayerUI"
@onready var playerInventory = $"../../PlayerUI/CanvasLayer/Inventory"

var player = null

func _on_body_entered(body):
	if body.name == "Player":
		player = body
		player.isByPhilsopherTable = true
		playerUI.interact_text.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		if player != null:
			player.isByPhilsopherTable = false
			if player.current_state == player.PLAYER_STATE.ALCHEMY:
				player.current_state = player.PLAYER_STATE.ACTIVE
				world.debug_print(player.current_state)
		playerUI.interact_text.visible = false
		playerUI.alchemy_panel.visible = false

func setup_philosopher_table():
	#TODO setup philosopher table with current player inventory
	print("setup the table")
