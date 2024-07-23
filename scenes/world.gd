extends Node3D

@onready var health_UI = $Control/healthTxt
@onready var game_over_UI = $Control/gameOverTxt

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_player_hit(dmg):
	health_UI.text = "%1d" % dmg


func _on_player_player_died():
	game_over_UI.visible = true
