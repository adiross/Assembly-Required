extends Node2D

var moving = false
var attatched = false
var rest_point
var rest_nodes = []
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
export var ground = 154

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("armSocket")
	rest_point = global_position

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		moving = true
		
func _physics_process(delta):
	if moving:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
#		look_at(get_global_mouse_position())
	else:
		global_position = lerp(global_position, rest_point, 5 * delta)
#		rotation = lerp_angle(rotation, 0, 10 * delta)

	if rest_point == rest_nodes[0].global_position and Input.is_action_just_pressed("Left_Arm"):
		animationState.travel("Punch")

	if rest_point == rest_nodes[1].global_position and Input.is_action_just_pressed("Right_Arm"):
		animationState.travel("Punch")

# if left mouse button is not pressed, unselect and do this:
# check the distance from the arm position to each child position
# if the distance is less then the shortest distance variable
# select the child and make the rest point = the child position
# else set the rest point to the current position

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			moving = false
			var shortest_dist = 10
			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position)
				if distance < shortest_dist and child.socketFull == false:
					child.select()
					z_index = child.z_index
					rest_point = child.global_position
					shortest_dist = distance
					animationState.travel("Idle_Attached")
					print(child)
					return
				else:
					child.deselect()
					z_index = 1
					rest_point = Vector2(position.x, ground)
					animationState.travel("Idle_Detatched")

