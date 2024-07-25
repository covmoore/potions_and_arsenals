extends Control

@onready var health_text = $CanvasLayer/healthTxt
@onready var game_over_text = $CanvasLayer/gameOverTxt
@onready var inventory_ui = $CanvasLayer/Inventory
@onready var paused_text = $CanvasLayer/pauseTxt
@onready var player = null

func _ready():
	paused_text.visible = false
	game_over_text.visible = false
	inventory_ui.visible = false

func _on_player_player_died():
	game_over_text.visible = true

func _on_player_player_hit(health):
	health_text.text = "%1d" % health
