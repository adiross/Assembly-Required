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
	randomize()
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
		#global_position = lerp(global_position, rest_point, 5 * delta)
		global_position = _quadratic_bezier(startPoint, midPoint, rest_point, 0 + delta)
		#global_position = fall(delta)

	if rest_point == rest_nodes[0].global_position and Input.is_action_just_pressed("Left_Arm"):
		animationState.travel("Punch")

	if rest_point == rest_nodes[1].global_position and Input.is_action_just_pressed("Right_Arm"):
		animationState.travel("Punch")

# if left mouse button is not pressed, unselect and do this:
# check the distance from the arm position to each child position
# if the distance is less then the shortest distance variable
# select the child and make the rest point = the child position
# else set the rest point to the current position
var startPoint = Vector2.ZERO
var midPoint = Vector2.ZERO

func _input(event):
	if Input.is_action_just_released("click"):
		startPoint = global_position
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
					attached = true
					return
				else:
					child.deselect()
					detach()

var t = 0.0
var duration = 1.0

func detach():
	z_index = 1
	rest_point = Vector2(rand_range(16, 150), ground)
	midPoint = Vector2((startPoint.x + rest_point.x)/2, startPoint.y -40)
	animationState.travel("Idle_Detatched")
	attached = false

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, delta: float):
	if global_position != rest_point:
		t += delta
		var q0 = p0.linear_interpolate(p1, t)
		var q1 = p1.linear_interpolate(p2, t)
		var r = q0.linear_interpolate(q1, t)
		return r
	else:
		t = 0.0
		return rest_point

# when punched the arm should come off, it should achieve this by:
# 

func _on_BasicEnemyArmFront_enemyPunch():
	var distance = global_position.distance_to(rest_nodes[1].global_position)
	if distance < 10 :
		rest_nodes[1].deselect()
		startPoint = global_position
		print("LEFT")
		detach()

func _on_BasicEnemyArmBack_enemyPunch():
	var distance = global_position.distance_to(rest_nodes[0].global_position)
	if distance < 10 :
		rest_nodes[0].deselect()
		startPoint = global_position
		print("RIGHT")
		detach()
