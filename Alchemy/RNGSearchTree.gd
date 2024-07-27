class_name RngSearchTree

var upperBound
var name
var left
var right
var parent

func searchItem(root, key):
	var previous_node = root
	while (root != null):
		if(key > root.upperBound):
			if(root.right == null):
				if(is_right_child(root)):
					return get_right_grand_father(root)
				else:
					return root.parent
			root = root.right
		elif(key < root.upperBound):
			if(root.left == null):
				if(is_right_child(root)):
					return get_right_grand_father(root)
				else:
					return root.parent
			root = root.left
		else:
			return root

func is_right_child(node):
	if node.parent.right.upperBound == node.upperBound:
		return true
	else:
		return false

func is_left_child(node):
	if node.parent.left.upperbound == node.upperBound:
		return true
	else:
		return false

func get_right_grand_father(node):
	var temp_node = node
	var right_grand_father = null
	while temp_node.parent.upperBound != node.upperBound:
		if is_left_child(temp_node.parent):
			return temp_node.parent.parent
		else:
			temp_node = node.parent
	return node

func insert(parent, root, upperBound, name):
	if root == null:
		return create_node(parent, upperBound, name)
	
	if upperBound < root.upperBound:
		root.left = insert(root, root.left, upperBound, name)
	elif upperBound > root.upperBound:
		root.right = insert(root, root.right, upperBound, name)
	return root

func create_node(parent, upperBound, name):
	var temp = RngSearchTree.new()
	temp.upperBound = upperBound
	temp.name = name
	temp.parent = parent
	temp.left = null
	temp.right = null
	return temp


