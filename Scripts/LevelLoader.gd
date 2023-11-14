class_name LevelLoader
extends Node2D

@export var levels : Array[PackedScene]

var currentLevelNode : Node2D

var currentLevelIdx : int = 0


func _ready():
	if get_child_count() > 0:
		currentLevelNode = get_child(0)
	if not currentLevelNode:
		currentLevelNode = levels[0].instantiate()
		add_child(currentLevelNode)
		SignalManager.connect(SignalManager.loadNextLevelSignalName, loadNextLevel)
	pass

func loadNextLevel():
	currentLevelNode.queue_free()
	currentLevelIdx+=1
	currentLevelNode = levels[currentLevelIdx].instantiate()
	add_child(currentLevelNode)
