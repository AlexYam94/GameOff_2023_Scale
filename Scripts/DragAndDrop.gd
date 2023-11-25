class_name DragAndDrop
extends RigidBody2D

@export var force : float = 10000
@export var stopDistance : float = 2
@export var distanceDecayFactor : float = 200
@export var velocityDecayValue : float = .5
@export var nonFacingCursorFactor : float = 1
@export var contactEffect : PackedScene

@export var directionAndVelocityIndicator : Node2D
@export var directionAndVelocityIndicatorScaleDivider : float = 3000
@export var maxDirectionAndVelocityIndicatorScale : float = .8

@export var playContactSoundEffect : bool = true

@export var detectArea : Area2D

signal clicked

var collisionShapes = []

var held : bool = false

var held_object : Object = null

var anchorPoint : Vector2

var pan : Pan
var originScale : Vector2

var pickupDir : Vector2
var contactSound : AudioStreamPlayer2D

func _ready():
	directionAndVelocityIndicator.visible = false
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
	originScale = directionAndVelocityIndicator.scale
	for node in get_children():
		if(node is CollisionShape2D):
			collisionShapes.append(node)
		if(node is AudioStreamPlayer2D):
			contactSound = node

		
func _physics_process(delta):
	detectPan()
	if held:
		var mousePos = get_global_mouse_position()
		var distance = global_position.distance_to(mousePos)
		if(distance > stopDistance):
			var dir = (mousePos - global_position).normalized()
			apply_central_force(dir * force * delta * (distance / distanceDecayFactor))
			var predictedPosition = global_position + linear_velocity
			directionAndVelocityIndicator.look_at(predictedPosition)
			#directionAndVelocityIndicator.scale.y = originScale.y + linear_velocity.y * directionAndVelocityIndicatorScaleFactor
			var gbPos = global_position
			var predictedDir = (mousePos - predictedPosition).normalized()
			if(predictedDir != dir):
				apply_force(dir * force * delta * (distance / distanceDecayFactor) * nonFacingCursorFactor, pickupDir)
			else:
				apply_force(dir * force * delta * (distance / distanceDecayFactor), pickupDir)
		else:
			var newVelocity = lerp(linear_velocity,Vector2.ZERO,velocityDecayValue)
			newVelocity.x = max(0, newVelocity.x)
			newVelocity.y = max(0, newVelocity.y)
			linear_velocity = newVelocity
		
		
	directionAndVelocityIndicator.scale.x = min(maxDirectionAndVelocityIndicatorScale, max(originScale.x, originScale.x + abs(linear_velocity.x + linear_velocity.y) / directionAndVelocityIndicatorScaleDivider))
			

func pickup():
	if held:
		return
	SignalManager.emit_signal(SignalManager.grappingObjectSignal)
	directionAndVelocityIndicator.visible = true
	gravity_scale = 0
	held = true
	pickupDir = get_global_mouse_position() - global_position

func drop(impulse=Vector2.ZERO):
	if held:
		SignalManager.emit_signal(SignalManager.releaseObjectSignal)
		directionAndVelocityIndicator.visible = false
		gravity_scale = 1
		held = false
		
func get_shape():
	return collisionShapes
	
func detectPan():
	var isCollidingWithWall : bool = false
	var isPanFound : bool = false
	var bodies = detectArea.get_overlapping_bodies()
	for body in bodies:
		if body == self:
			continue
		if(body.is_in_group("Wall")):
			isCollidingWithWall = true
		if not (body is DragAndDrop) and not (body is Pan):
			continue		
		if(body is DragAndDrop):
			pan = body.pan
			isPanFound = true
		if(body is Pan):
			pan = pan
			isPanFound = true
		if(pan and (body is Pan or body is DragAndDrop )):
			pan.registerObj(self)
	
	if(pan) and (isCollidingWithWall or not isPanFound):
		pan.unregisterObj(self)
		pan = null

func _on_body_entered(body):
#	if(body is DragAndDrop):
#		pan = body.pan
#	if(body is Pan):
#		pan = pan
#
#	if(pan and (body is Pan or body is DragAndDrop )):
#		pan.registerObj(self)

	#TODO:
	#Play hit/smoke/dust effect
	if playContactSoundEffect:
		contactSound.play()
#	var otherShapes = body.get_shape()
#	if(body is DragAndDrop):
#		if((body as RigidBody2D).linear_velocity == Vector2.ZERO):
#			return
#	for collisionShape in collisionShapes:
#		for otherCollisionShape in otherShapes:
#			var shape = collisionShape.shape
#			var otherShape = otherCollisionShape.shape
#			var contactsPoints = shape.collide_and_get_contacts(transform, otherShape, body.transform)
#			for point in contactsPoints:
##				print(point)
#				var effect : Node2D = contactEffect.instantiate();
#				(effect as Node2D).global_position = point
#				get_parent().add_child(effect)

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
			
func _on_mouse_entered():
	if !held_object:
		SignalManager.emit_signal(SignalManager.hoverOverSignal)


func _on_mouse_exited():
	if !held_object:
		SignalManager.emit_signal(SignalManager.releaseObjectSignal)


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


