extends Control
@onready var health_text = $healthTxt
@onready var point_text = $MarginContainer/VBoxContainer/HBoxContainer/point_text
@onready var pickup_text = $MarginContainer/VBoxContainer/HBoxContainer2/pickup_text

var time_to_show_pickup = 2.5
var time = 0
var item_picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pickup_text.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item_picked_up:
		time += delta
		if time >= time_to_show_pickup:
			disablePickupText()

func setHealth(health):
	health_text.text = "%1d" % health

func setPoints(points):
	point_text.text = "%d" % points

func setPickup(item):
	pickup_text.text = "+1 %s" % item
	pickup_text.visible = true
	time = 0.0
	item_picked_up = true

func disablePickupText():
	pickup_text.visible = false
	item_picked_up = false
	
