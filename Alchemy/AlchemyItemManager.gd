extends Node


var rngTree
@onready var alchemy_data = {}
var drop_probability = .20
var last_item_bound = 0
const RNG_RANGE = 1000.00
var world_instance = null

func _ready():
	# Use a deferred call to ensure the node is properly initialized
	call_deferred("_initialize")
	rngTree = RngSearchTree.new()

func _initialize():
	alchemy_data = load_xml("res://Alchemy/AlchemyItems.xml")
	for name in alchemy_data.keys():
		print("%s's bound: %4.2f" % [name, alchemy_data[name].upperBound])
	populate_rng_tree(alchemy_data)

	# Ensure the world instance is properly retrieved
	world_instance = get_tree().get_root().get_node("World")
	if world_instance == null:
		print("World node not found!")
	else:
		world_instance.debug_print(alchemy_data)

func load_xml(file_path: String) -> Dictionary:
	var data = {}

	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var contents = file.get_as_text()
		var xml = XMLParser.new()
		xml.open_buffer(contents.to_utf8_buffer())
		var lastUpperBound = 0
		while xml.read() == OK:
			if xml.get_node_type() == XMLParser.NODE_ELEMENT and xml.get_node_name() == "item":
				var item = {}
				var key
				while xml.read() == OK:
					if xml.get_node_type() == XMLParser.NODE_ELEMENT:
						var element_name = xml.get_node_name()
						xml.read()
						var element_value = xml.get_node_data().strip_edges()
						if element_name == "name":
							key = element_value
						if element_name == "loot_probability":
							var loot_prob = element_value.to_float()
							var actual_prob = loot_prob * drop_probability
							var range = actual_prob * RNG_RANGE
							var upperBound = range + lastUpperBound
							lastUpperBound = upperBound
							item["upperBound"] = upperBound
							continue
						item[element_name] = element_value
					elif xml.get_node_type() == XMLParser.NODE_ELEMENT_END and xml.get_node_name() == "item":
						break
				data[key] = item
				var no_item = {
					"image_path": "",
					"collider_path":"",
					"mesh_path": "",
					"upperBound": RNG_RANGE,
					"grade": "common",
					"name": "no_item"
				}
				data["no_item"] = no_item
				last_item_bound = lastUpperBound
		file.close()
	return data
	

func get_random_item(willDrop = false) -> Dictionary:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_idx
	if willDrop == true:
		random_idx = rng.randf_range(1, last_item_bound)
	random_idx = rng.randf_range(1, RNG_RANGE)
	var item = rngTree.searchItem(random_idx).name
	print("RNG Number %4.2f got %s" % [random_idx, item])
	return alchemy_data[item]

func populate_rng_tree(data):
	var count = 0
	var root = null
	for item_name in data.keys():
		var upperBound = alchemy_data[item_name].upperBound
		rngTree.insert(upperBound, item_name)
