class_name HitEffect
extends Node2D

@export var duration : float = .5

func _ready():
	# await get_tree().create_timer(duration).timeout
	# queue_free()
	get_tree().create_timer(duration).connect("timeout", queue_free)
