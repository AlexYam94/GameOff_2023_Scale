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
	if(linear_velocity.x > maxVelocity):
		linear_velocity = Vector2(maxVelocity,0)
	totalWeight = 0
	for obj in registeredObjs:
		totalWeight += (obj as RigidBody2D).mass
		
#	print(totalWeight)
	
func get_register_obj_count():
	return registeredObjs.size()

func get_shape():
	return collisionShapes

func registerObj(body):
	if not (registeredObjs.has(body)):
		registeredObjs.append(body)
	
func unregisterObj(body):
	if (registeredObjs.has(body)):
		registeredObjs.erase(body)


func _on_area_2d_body_entered(body):
		if not body.is_in_group(detectGroup):
			return
		registerObj(body)
		body.pan = self
