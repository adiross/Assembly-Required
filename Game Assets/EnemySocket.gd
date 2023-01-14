extends Position2D

export var EnemySocketFull = false

func select():
	for child in get_tree().get_nodes_in_group("enemySocket"):
		child.deselect()
	EnemySocketFull = true
	print(get_tree().get_nodes_in_group("enemySocket"))
	
func deselect():
	EnemySocketFull = false
