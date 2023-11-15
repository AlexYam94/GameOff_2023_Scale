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

var allPickables = []
var countDownTimer : float
var startLoadNextLevel : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	countDownTimer = countDownTime
	find_nodes_in_group(get_tree().root)
	pass
		


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
		SignalManager.emit_signal(SignalManager.countDownSignalName, ceil(countDownTimer))
	else:
		countDownTimer = countDownTime
		
	if (countDownTimer <= 0 and !startLoadNextLevel):
		#print("load next level")
		#TODO
		#Play fade in effect
		#Next level
		startLoadNextLevel = true
		SignalManager.emit_signal(SignalManager.loadNextLevelSignalName)
		pass

func find_nodes_in_group(node):
	for n in node.get_children():
		find_nodes_in_group(n)
	if(node.is_in_group(pickableObjGroup)):
		allPickables.append(node)