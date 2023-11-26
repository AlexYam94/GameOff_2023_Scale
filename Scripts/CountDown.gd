class_name CountDown
extends Node2D

@export var animPlayer : AnimationPlayer
@export var label : Label

func _ready():
	SignalManager.connect(SignalManager.countDownSignalName, countDown)
	pass

func _process(delta):
	pass

func countDown(digit):
	label.text = str(digit)
	animPlayer.play("5")
