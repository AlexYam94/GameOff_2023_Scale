extends RigidBody2D

@export var leftPan : Node2D

@export var rightPan : Node2D

@export var armVisual : Node2D

@export var countDownText : Label

@export var countDownTime : float

var initPos

# Called when the node enters the scene tree for the first time.
func _ready():
	initPos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = initPos
	armVisual.rotation = rightPan.position.angle_to_point(leftPan.position)

	pass
