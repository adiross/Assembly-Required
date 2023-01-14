extends Position2D

export var socketFull = false

#func _draw():
	#draw_circle(Vector2.ZERO, 10, Color.blanchedalmond)
	
func select():
	for child in get_tree().get_nodes_in_group("armSocket"):
		child.deselect()
	socketFull = true
	
func deselect():
	socketFull = false
