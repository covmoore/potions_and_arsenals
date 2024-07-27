extends Node3D

var world = null

func _ready():
	world = get_tree().get_root().get_node("World")

func _on_body_entered(body):
	if body.name == "Player":
		world.debug_print(str(body.name + " is near the crafting table"))
