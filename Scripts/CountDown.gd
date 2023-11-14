class_name CountDown
extends Node2D

@export var animPlayer : AnimationPlayer

func _ready():
	SignalManager.connect(SignalManager.countDownSignalName, countDown)
	pass

func _process(delta):
	pass

func countDown(digit):
	animPlayer.play(str(digit))
