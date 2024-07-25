extends Node3D

enum DIFFICULTY {
	PEACEFUL,
	NORMAL
}

var game_difficulty = DIFFICULTY.NORMAL


func _ready():
	game_difficulty = DIFFICULTY.PEACEFUL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
