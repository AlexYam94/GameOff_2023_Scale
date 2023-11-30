class_name Pan
extends RigidBody2D

@export var detectArea : Area2D
@export var detectGroup : String
@export var collisionShape : CollisionShape2D

@export var maxVelocity : float

var collisionShapes = []
var totalWeight : float
var registeredObjs = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		if(node is CollisionShape2D):
			collisionShapes.append(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if(linear_velocity.y > maxVelocity):
#		linear_velocity = Vector2(0,maxVelocity)
#	elif(linear_velocity.y < -maxVelocity):
#		linear_velocity = Vector2(0,-maxVelocity)
#	linear_velocity = Vector2(0, linear_velocity.y)
	totalWeight = 0
	for obj in registeredObjs:
		totalWeight += (obj as RigidBody2D).mass
		
#	if(totalWeight != 0):
#		print(name  + ": "+ str(totalWeight))
	
func get_register_obj_count():
	return registeredObjs.size()

func get_shape():
	return collisionShapes

func registerObj(body):
	if not (registeredObjs.has(body)):
		registeredObjs.append(body)
	
func unregisterObj(body):
	var idx : int = registeredObjs.find(body)
	if (idx >= 0):
		registeredObjs.remove_at(idx)


func _on_area_2d_body_entered(body):
		if not body.is_in_group(detectGroup):
			return
		registerObj(body)
		body.pan = self
