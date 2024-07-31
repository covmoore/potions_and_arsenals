extends Node

@onready var player = $".."


func _ready():
	player.connect("boon_activated", _on_boon_activated)
	
func _on_boon_activated(boonName):
	print("BOON ACTIVATED MOTHERFreaker uWuWuWuWuwuwuwuwuwuw lets flipping uwuwuwuweuw IM GONNA SQUUUUUUUUUUUUUUUUUUIIIIIIIIIIIII REEEEEEEEEEEEE")
	if boonName == "faun-hoof":
		player.speed += 3
	elif boonName == "golden-bullet":
		player.damage += 2
	elif boonName == "ferret":
		player.health += 1
	else:
		pass
