extends Node

var rngTree
@onready var alchemy_data = []

var world_instance = null

func _ready():
	# Use a deferred call to ensure the node is properly initialized
	call_deferred("_initialize")
	rngTree = RngSearchTree.new()

func _initialize():
	alchemy_data = load_xml("res://Alchemy/AlchemyItems.xml")
	
	# Ensure the world instance is properly retrieved
	world_instance = get_tree().get_root().get_node("World")
	if world_instance == null:
		print("World node not found!")
	else:
		world_instance.debug_print(alchemy_data)

func load_xml(file_path: String) -> Array:
	var data = []

	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var contents = file.get_as_text()
		var xml = XMLParser.new()
		xml.open_buffer(contents.to_utf8_buffer())

		while xml.read() == OK:
			if xml.get_node_type() == XMLParser.NODE_ELEMENT and xml.get_node_name() == "item":
				var item = {}
				while xml.read() == OK:
					if xml.get_node_type() == XMLParser.NODE_ELEMENT:
						var element_name = xml.get_node_name()
						xml.read()
						var element_value = xml.get_node_data().strip_edges()
						item[element_name] = element_value
					elif xml.get_node_type() == XMLParser.NODE_ELEMENT_END and xml.get_node_name() == "item":
						break
				data.append(item)
		file.close()
	return data
	

func get_random_item() -> Dictionary:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_idx = rng.randi_range(0, alchemy_data.size() - 1)
	return alchemy_data[random_idx]
