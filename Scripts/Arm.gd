extends RigidBody2D

@export var leftPan : Node2D
@export var rightPan : Node2D
@export var armVisual : Node2D
@export var countDownText : Label
@export var countDownTime : float

var initPos : Vector2
var countDownTimer : float

# Called when the node enters the scene tree for the first time.
func _ready():
	initPos = position
	countDownTimer = countDownTime
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = initPos
	armVisual.rotation = rightPan.position.angle_to_point(leftPan.position)
	rotation = 0
	var leftWeight : float = leftPan.totalWeight
	var rightWeight : float = leftPan.totalWeight
	
	#Count down
	if(leftWeight == rightWeight):
		countDownTimer = max(countDownTimer-delta, 0)
	else:
		countDownTimer = countDownTime
		
	if (countDownTimer <= 0):
		#TODO
		#Next level
		pass
		
	pass
