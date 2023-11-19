class_name Wall
extends Node



var collisionShapes = []

func _ready():
	for node in get_children():
		if(node is CollisionShape2D):
			collisionShapes.append(node)

func get_shape():
	return collisionShapes
