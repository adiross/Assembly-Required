extends Node2D

var moving = false
var attatched = false
var rest_point
var rest_nodes = []
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
export var ground = 154
const punch = "Punch"
var punching = false
signal enemyPunch

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("enemySocket")
	rest_point = global_position
	checkSocket()

func _physics_process(delta):
	if moving:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
#		look_at(get_global_mouse_position())
	else:
		global_position = lerp(global_position, rest_point, 5 * delta)
#		rotation = lerp_angle(rotation, 0, 10 * delta)
	
	if animationState.get_current_node() != punch and punching == false:
		punching = true
		punch()



# if left mouse button is not pressed, unselect and do this:
# check the distance from the arm position to each child position
# if the distance is less then the shortest distance variable
# select the child and make the rest point = the child position
# else set the rest point to the current position

#Happens when mouse is released and checkSocket()
func punch():
	var timerRange = rand_range(1, 5)
	yield(get_tree().create_timer(timerRange), "timeout")
	animationState.travel("Punch")
	emit_signal("enemyPunch")
	punching = false
	return

func checkSocket():
	moving = false
	var shortest_dist = 10
	for child in rest_nodes:
		var distance = global_position.distance_to(child.global_position)
		if distance < shortest_dist and child.enemySocketFull == false:
			child.select()
			z_index = child.z_index
			rest_point = child.global_position
			shortest_dist = distance
			animationState.travel("Idle_Attached")
			return
		else:
			child.deselect()
			z_index = 1
			rest_point = Vector2(position.x, ground)
			animationState.travel("Idle_Detatched")

