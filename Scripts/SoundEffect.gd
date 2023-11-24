class_name SoundEffect
extends AudioStreamPlayer2D

@export var decayTime : float = .5


var decayCounter : float
var shouldStop : bool = true
var originalVol : float

func _ready():
	originalVol = volume_db

func _process(delta):
	if(not shouldStop):
		return
	if(decayCounter > 0):
		decayCounter = max(decayCounter - delta, 0)
	
	
func Start():
	shouldStop = false
	
func Stop():
	decayCounter = decayTime
	shouldStop = true
