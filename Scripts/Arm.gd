extends RigidBody2D

var initPos

# Called when the node enters the scene tree for the first time.
func _ready():
	initPos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = initPos
	pass
