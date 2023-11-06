extends Node2D

@export var levels : Array[PackedScene]

var currentLevelNode : Node

var currentLevelIdx : int = 0

func _ready():
	currentLevelNode = get_child(0)

func loadNextLevel():
	currentLevelNode.queue_free()
	currentLevelNode = levels[++currentLevelIdx].instance()
	add_child(currentLevelNode)
