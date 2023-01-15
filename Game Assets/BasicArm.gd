extends Node2D

var moving = false
var attached = false
var rest_point
var rest_nodes = []
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
export var ground = 154
var landingSpot = 0.0

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
	elif attached:
		global_position = lerp(global_position, rest_point, 5 * delta)
#		rotation = lerp_angle(rotation, 0, 10 * delta)
	else:
		global_position = fall(delta)

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
	if event is InputEventMouseButton and moving == true:
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
					attached = true
					return
				else:
					child.deselect()
					z_index = 1
					animationState.travel("Idle_Detatched")
					attached = false

var t = 0.0
var duration = 1.0

func fall(delta):
	landingSpot = 16
	t += delta / duration
	var positionA = rest_point
	var positionB = Vector2(landingSpot, ground)
	var positionC = Vector2(32, 64)
	var q0 = positionA.linear_interpolate(positionC, min(t, 1.0))
	var q1 = positionC.linear_interpolate(positionB, min(t, 1.0))
	var pos = q0.linear_interpolate(q1, min(t, 1.0))
	print(pos)
	return pos
