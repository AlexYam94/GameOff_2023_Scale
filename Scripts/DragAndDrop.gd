extends RigidBody2D

@export var force : float = 10000
@export var stopDistance : float = 2
@export var distanceDecayFactor : float = 200
@export var velocityDecayValue : float = .5
@export var nonFacingCursorFactor : float #make u turn, 90 degree turn faster

@export var testSprite : Sprite2D

signal clicked

var held : bool = false

var held_object : Object = null

var anchorPoint : Vector2

func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
		
func _physics_process(delta):
	if held:
		var mousePos = get_global_mouse_position()
		var distance = global_transform.origin.distance_to(mousePos)
		if(distance > stopDistance):
			var dir = (mousePos - global_transform.origin).normalized()
			apply_central_force(dir * force * delta * (distance / distanceDecayFactor))
			var predictedPosition = global_position + linear_velocity
			testSprite.look_at(predictedPosition)
			var gbPos = global_position
			var predictedDir = (mousePos - predictedPosition).normalized()
			if(predictedDir != dir):
				linear_velocity = linear_velocity/2
				apply_central_force(dir * force * delta * (distance / distanceDecayFactor) * nonFacingCursorFactor)	
			else:
				apply_central_force(dir * force * delta * (distance / distanceDecayFactor))
		else:
			linear_velocity =  lerp(linear_velocity,Vector2.ZERO,velocityDecayValue)
			

func pickup():
	if held:
		return
	gravity_scale = 0
	held = true

func drop(impulse=Vector2.ZERO):
	if held:
		gravity_scale = 1
		#apply_central_impulse(impulse)
		held = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			clicked.emit(self)
			anchorPoint = get_global_mouse_position()


func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity())
			held_object = null		
