extends Control

@onready var health_text = $healthTxt
@onready var game_over_UI = $gameOverTxt


func _on_player_player_died():
	game_over_UI.visible = true

func _on_player_player_hit(dmg):
	health_text.text = "%1d" % dmg
