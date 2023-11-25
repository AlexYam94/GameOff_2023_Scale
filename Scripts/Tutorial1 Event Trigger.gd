extends Node2D


@export var nextEventInterval : float
@export var totalEvent : int = 8
@export var light1 : Node2D
@export var light2 : Node2D
@export var light3 : Node2D


var nextEventCounter : float = 0
var startEvent : bool
var eventCount : int = 0

func _process(delta):
	if not startEvent or eventCount > totalEvent:
		return
	nextEventCounter = max(nextEventCounter - delta, 0)
	if(nextEventCounter <= 0):
		process_event()
		nextEventCounter = nextEventInterval
	
func process_event():
	match eventCount:
		1:
			light2.visible = true
		2: 
			light3.visible = true
	eventCount += 1
	

func _on_weight_1_kg_clicked(body):
	light1.visible = true
	nextEventCounter = nextEventInterval
	startEvent = true
	eventCount = 1
