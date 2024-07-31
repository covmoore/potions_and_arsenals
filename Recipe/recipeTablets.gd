extends Node3D

@export var recipeText: String
@export var pointsToUnlock: int
@onready var world = $"../../.."
@onready var textMesh = $MeshInstance3D/MeshInstance3D
var recipe_displayed = false


func _ready():
	textMesh.mesh.text = "Get %d points to show recipe" % pointsToUnlock

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if world.points >= pointsToUnlock and !recipe_displayed:
		changeText()
		recipe_displayed = true

func changeText():
	textMesh.mesh.text = recipeText
