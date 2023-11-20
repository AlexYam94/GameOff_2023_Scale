class_name Gear
extends Node2D

@export var pan : Pan
@export var rotationAmountPerFrame : float

var lastFramePos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	lastFramePos = pan.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var currentFramePos = pan.global_position
	var diff = abs(currentFramePos.y - lastFramePos.y)
	if(currentFramePos.y < lastFramePos.y):
		#Rotate right
		rotation = fmod(rotation + rotationAmountPerFrame, PI) * diff * delta
	elif(currentFramePos.y > lastFramePos.y):
		#Rotate left
		rotation = fmod(rotation - rotationAmountPerFrame, PI) * diff * delta

	lastFramePos = currentFramePos
	pass
