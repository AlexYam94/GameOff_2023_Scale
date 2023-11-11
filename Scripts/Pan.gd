class_name Pan
extends RigidBody2D

@export var detectArea : Area2D
@export var detectGroup : String

var totalWeight : float
var registeredObjs = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bodies = detectArea.get_overlapping_bodies()
	totalWeight = 0
	for body in bodies:
		if not body.is_in_group(detectGroup):
			continue
		registerObj(body)
		body.pan = self
		
	for obj in registeredObjs:
		totalWeight += (obj as RigidBody2D).mass
		
	print(totalWeight)

func registerObj(body):
	if not (registeredObjs.has(body)):
		registeredObjs.append(body)
	
func unregisterObj(body):
	if (registeredObjs.has(body)):
		registeredObjs.erase(body)
