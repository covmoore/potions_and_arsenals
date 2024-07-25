extends Control

@onready var health_text = $CanvasLayer/healthTxt
@onready var game_over_text = $CanvasLayer/gameOverTxt

func _ready():
	game_over_text.visible = false

func _on_player_player_died():
	game_over_text.visible = true

func _on_player_player_hit(health):
	health_text.text = "%1d" % health
