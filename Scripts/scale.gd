class_name scale
extends Node2D

#TODO:
#Get Weight from pan
#

@export var leftPan : Node2D
@export var rightPan : Node2D
@export var countDownText : Label
@export var countDownTime : float


var countDownTimer : float

# Called when the node enters the scene tree for the first time.
func _ready():
	countDownTimer = countDownTime
	pass
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var leftWeight : float = leftPan.totalWeight
	var rightWeight : float = rightPan.totalWeight
	
	#Count down
	if(leftWeight == rightWeight):
		countDownTimer = max(countDownTimer-delta, 0)
		#countDown Animation
		#print("count down: " + str(ceil(countDownTimer)))
	else:
		countDownTimer = countDownTime
		
	if (countDownTimer <= 0):
		#print("load next level")
		#TODO
		#Play fade in effect
		#Next level
		SignalManager.emit_signal(SignalManager.loadNextLevelSignalName)
		pass
