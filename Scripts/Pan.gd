extends RigidBody2D

@export var detectArea : Area2D
@export var detectGroup : String

var totalWeight : float
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
		totalWeight += (body as RigidBody2D).mass
		
	print(totalWeight)

func test():
	print("pan")
