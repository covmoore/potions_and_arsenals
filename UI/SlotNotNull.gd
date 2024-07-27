extends Control

var world_instance = null

func _ready():
	world_instance = get_tree().get_root().get_node("World")

func setItemTexture(item_image_path):
	self.texture = load(item_image_path)

func incrementCount():
	var count = get_child(0)
	count.text = str(int(count.text) + 1)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var msg = str(self.name + " was clicked")
			world_instance.debug_print(msg)
