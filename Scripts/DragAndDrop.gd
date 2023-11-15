class_name DragAndDrop
extends RigidBody2D

@export var force : float = 10000
@export var stopDistance : float = 2
@export var distanceDecayFactor : float = 200
@export var velocityDecayValue : float = .5
@export var nonFacingCursorFactor : float = 1
@export var collisionShape : CollisionShape2D
@export var contactEffect : PackedScene

@export var directionAndVelocityIndicator : Sprite2D
@export var directionAndVelocityIndicatorScaleFactor : float = .1

signal clicked

var held : bool = false

var held_object : Object = null

var anchorPoint : Vector2

var pan : Pan

func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
		
func _physics_process(delta):
	if held:
		var mousePos = get_global_mouse_position()
		var distance = global_position.distance_to(mousePos)
		if(distance > stopDistance):
			var dir = (mousePos - global_position).normalized()
			apply_central_force(dir * force * delta * (distance / distanceDecayFactor))
			var predictedPosition = global_position + linear_velocity
			directionAndVelocityIndicator.look_at(predictedPosition)
			directionAndVelocityIndicator.scale = new Vector2(
				1+linear_velocity.x * directionAndVelocityIndicatorScaleFactor,
				1+linear_velocity.y * directionAndVelocityIndicatorScaleFactor)
			var gbPos = global_position
			var predictedDir = (mousePos - predictedPosition).normalized()
			if(predictedDir != dir):
				apply_central_force(dir * force * delta * (distance / distanceDecayFactor) * nonFacingCursorFactor)
			else:
				apply_central_force(dir * force * delta * (distance / distanceDecayFactor))
		else:
			var newVelocity = lerp(linear_velocity,Vector2.ZERO,velocityDecayValue)
			newVelocity.x = max(0, newVelocity.x)
			newVelocity.y = max(0, newVelocity.y)
			linear_velocity = newVelocity
			

func pickup():
	if held:
		return
	SignalManager.emit_signal(SignalManager.grappingObjectSignal)
	gravity_scale = 0
	held = true

func drop(impulse=Vector2.ZERO):
	if held:
		SignalManager.emit_signal(SignalManager.releaseObjectSignal)
		gravity_scale = 1
		held = false
		
func get_shape():
	return collisionShape.shape

func _on_body_entered(body):
	if not (body is DragAndDrop):
		return
	if(body is DragAndDrop):
		pan = body.pan
		
	if(pan):
		pan.registerObj(self)
	#TODO:
	#Play hit/smoke/dust effect
	var shape = collisionShape.shape
	var otherShape = body.get_shape()
	var contactsPoints = shape.collide_and_get_contacts(transform, otherShape, body.transform)
	if(!contactsPoints):
		pass
	for point in contactsPoints:
		print(point)
		var effect : Node2D = contactEffect.instantiate();
		(effect as Node2D).global_position = point

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


func _on_body_exited(body):
	#TODO
	#if exist drag and drop or pan, unregister
	if not pan:
		return
	if (body is Pan):
		if (body as Pan) == pan:
			pan.unregisterObj(self)
			print("exit pan")
	elif (body is DragAndDrop):
		if (body as DragAndDrop).pan == pan:
			pan.unregisterObj(self)
			print("exit obj")
