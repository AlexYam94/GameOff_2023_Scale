extends RigidBody2D

@export var force : float = 10000

signal clicked

var held = false

var held_object = null

func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
		
func _physics_process(delta):
	if held:
		var mousePos = get_global_mouse_position()
		var dir = mousePos - global_transform.origin
		apply_central_force(dir * force * delta)

func pickup():
	if held:
		return
	held = true

func drop(impulse=Vector2.ZERO):
	if held:
		#apply_central_impulse(impulse)
		held = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			clicked.emit(self)


func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity())
			held_object = null		
