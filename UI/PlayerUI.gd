extends Control

@onready var health_text = $CanvasLayer/healthTxt
@onready var game_over_text = $CanvasLayer/gameOverTxt
@onready var inventory_ui = $CanvasLayer/Inventory
@onready var player = $"../Player"

func _ready():
	game_over_text.visible = false
	inventory_ui.visible = false

func _on_player_player_died():
	game_over_text.visible = true

func _on_player_player_hit(dmg):
	health_text.text = "%1d" % dmg

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.physical_keycode == KEY_I and player.isAlive:
			inventory_ui.visible = not inventory_ui.visible
