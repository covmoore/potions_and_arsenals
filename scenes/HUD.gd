extends Control
@onready var health_text = $healthTxt

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setHealth(health):
	health_text.text = "%1d" % health
