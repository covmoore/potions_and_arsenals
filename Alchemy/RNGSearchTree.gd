class_name RngSearchTree

var root = null

class RngNode:
	var name
	var left
	var right
	var parent
	var upperBound


func searchItem(key):
	return search(root, key)

func search(node, key):
	var previous_node = node
	while (node != null):
		if(key > node.upperBound):
			if(node.right == null):
				if(is_right_child(node)):
					return get_right_grand_father(node)
				else:
					return node.parent
			node = node.right
		elif(key < node.upperBound):
			if(node.left == null):
				return node
			node = node.left
		else:
			return node

func is_right_child(node):
	if node.parent.right == null:
		return false
	if node.parent.right.upperBound == node.upperBound:
		return true
	else:
		return false

func is_left_child(node):
	if node.parent.left == null:
		return false
	if node.parent.left.upperBound == node.upperBound:
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
			temp_node = temp_node.parent
	return node

func insert(upperBound, name):
	if root == null:
		root = create_node(root, upperBound, name)
		root.parent = root
		return root
	else:
		insert_node(root.parent, root, upperBound, name)

func insert_node(parent, node, upperBound, name):
	if node == null:
		return create_node(parent, upperBound, name)
	
	if upperBound < node.upperBound:
		node.left = insert_node(node, node.left, upperBound, name)
	elif upperBound > node.upperBound:
		node.right = insert_node(node, node.right, upperBound, name)
	return node

func create_node(parent, upperBound, name):
	var temp = RngNode.new()
	temp.upperBound = upperBound
	temp.name = name
	temp.left = null
	temp.right = null
	temp.parent = parent
	return temp


