class_name Rope
extends Node2D

@export var connectedPan : Pan

var originalDistance : float

func _ready():
	originalDistance = global_position.distance_to(connectedPan.global_position)
	pass

func _process(delta):
	var currentDistance : float = global_position.distance_to(connectedPan.global_position)
	scale.x = currentDistance / originalDistance
	pass
