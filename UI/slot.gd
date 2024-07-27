extends Control

var world_instance = null

func _ready():
	world_instance = get_tree().get_root().get_node("World")

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var msg = str(self.name + " was clicked")
			world_instance.debug_print(msg)
