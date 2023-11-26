class_name scale
extends Node2D

#TODO:
#Get Weight from pan
#

@export var leftPan : Pan
@export var rightPan : Pan
@export var countDownText : Label
@export var countDownTime : float
@export var pickableObjGroup : String
@export var diffText : Label
@export var diffTextChangeInterval : float = .01

var allPickables = []
var countDownTimer : float
var lastCountDownDigit : int = 0
var startLoadNextLevel : bool = false

var targetDiff : int
var currentDiff : int = 0
var diffTextChangeCounter : float
var shouldChangeDiffText : bool
var leftWeightSnapshot : float
var rightWeightSnapshot : float


# Called when the node enters the scene tree for the first time.
func _ready():
	if allPickables.size() > 0:
		allPickables.clear()
	find_nodes_in_group(get_parent())
	countDownTimer = countDownTime
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var leftWeight : float = leftPan.totalWeight
	var rightWeight : float = rightPan.totalWeight
	
	var objCount : int = leftPan.get_register_obj_count() + rightPan.get_register_obj_count()

	#Count down
	if(leftWeight == rightWeight and objCount >= allPickables.size()):
		countDownTimer = max(countDownTimer-delta, 0)
		#countDown Animation
		#print("count down: " + str(ceil(countDownTimer)))
		if(countDownTimer > 0):
			if not (lastCountDownDigit == ceili(countDownTimer)):
				lastCountDownDigit = ceili(countDownTimer)
				SignalManager.emit_signal(SignalManager.countDownSignalName, lastCountDownDigit)
	else:
		countDownTimer = countDownTime
	
	cal_weight_difference(delta)
		
	if (countDownTimer <= 0 and !startLoadNextLevel):
		#print("load next level")
		#TODO
		#Play fade in effect
		#Next level
		startLoadNextLevel = true
		SignalManager.emit_signal(SignalManager.loadNextLevelSignalName)
		pass

func cal_weight_difference(delta):
	var leftWeight : float = leftPan.totalWeight
	var rightWeight : float = rightPan.totalWeight
	
	if (leftWeight != leftWeightSnapshot or rightWeight != rightWeightSnapshot):
		if(leftWeight == rightWeight and not (leftWeight == 0 or rightWeight == 0)):
			targetDiff = 0
			shouldChangeDiffText = true
			diffTextChangeCounter = diffTextChangeInterval
			currentDiff = 0
		elif (leftWeight != 0 and rightWeight != 0):
			var diff : float = abs(leftWeight - rightWeight)
			var avg : float = (leftWeight + rightWeight) / 2
			targetDiff = roundi(diff/avg * 100)
			shouldChangeDiffText = true
			diffTextChangeCounter = diffTextChangeInterval
			currentDiff = 0
		else:
			diffText.text = "∞"
			
	leftWeightSnapshot = leftWeight
	rightWeightSnapshot = rightWeight
		
	if(not shouldChangeDiffText):
		return 
	if(diffTextChangeCounter > 0):
		diffTextChangeCounter = max(diffTextChangeCounter - delta, 0)
	else:
		if(currentDiff >= targetDiff):
			diffText.text = str(currentDiff) + "%"
			shouldChangeDiffText = false
			currentDiff = 0
			return
		diffTextChangeCounter = diffTextChangeInterval
		currentDiff += 1
		diffText.text = str(currentDiff) + "%"
		
	

func find_nodes_in_group(node):
	for n in node.get_children():
		find_nodes_in_group(n)
	if(node.is_in_group(pickableObjGroup)):
		allPickables.append(node)
