extends Position2D

export var enemySocketFull = false

func select():
	for child in get_tree().get_nodes_in_group("enemySocket"):
		child.deselect()
	enemySocketFull = true
	print(enemySocketFull)
	
func deselect():
	enemySocketFull = false
