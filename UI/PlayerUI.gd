extends Control

@onready var health_text = $CanvasLayer/healthTxt
@onready var game_over_text = $CanvasLayer/gameOverTxt
@onready var inventory_ui = $CanvasLayer/Inventory
@onready var paused_text = $CanvasLayer/pauseTxt
@onready var player = $"../Player"

func _ready():
	paused_text.visible = false
	game_over_text.visible = false
	inventory_ui.visible = false

func _on_player_player_died():
	game_over_text.visible = true

func _on_player_player_hit(dmg):
	health_text.text = "%1d" % dmg

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.physical_keycode == KEY_V and (player.current_state == player.PLAYER_STATE.ACTIVE 
																or player.current_state == player.PLAYER_STATE.INVENTORY):
			inventory_ui.visible = not inventory_ui.visible
			#show the cursor if not shown
			if inventory_ui.visible:
				player.current_state = player.PLAYER_STATE.INVENTORY
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				player.current_state = player.PLAYER_STATE.ACTIVE
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
