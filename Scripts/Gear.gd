class_name Gear
extends Node2D

@export var pan : Pan
@export var rotationAmountPerFrame : float

var lastDiff : float

# Called when the node enters the scene tree for the first time.
func _ready():
	lastDiff = abs(global_position.y - pan.global_position.y)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var diff = abs(global_position.y - pan.global_position.y)
	print("diff: " + str(diff))
	print("last diff: " + str(lastDiff))
	var newRotation = rotation
#	if(lastDiff < diff):
#		#Rotate right
#		newRotation = fmod(rotation + rotationAmountPerFrame, PI) * lastDiff * delta
#	elif(lastDiff > diff):
#		#Rotate left
#		newRotation = fmod(rotation - rotationAmountPerFrame, PI) * lastDiff * delta
		
#	rotation = newRotation

	if(lastDiff < diff):
		#Rotate right
		rotate(-diff * delta * rotationAmountPerFrame)
	elif(lastDiff > diff):
#		#Rotate left
		rotate(diff * delta * rotationAmountPerFrame)

	lastDiff = diff
	pass
