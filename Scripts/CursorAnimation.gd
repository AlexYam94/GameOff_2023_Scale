class_name CursorAnimation
extends Node2D

@export var idleSprite : Resource
@export var grapFrames : Array[Resource]
@export var frameDuration : float = .5

var frameCounter : float

var isGrapping : bool = false
var currentFrameIdx = 0

func _ready():
    SignalManager.connect(SignalManager.grappingObjectSignal, grapObject)
    SignalManager.connect(SignalManager.releaseObjectSignal, releaseObject)

func _process(delta):
    if not isGrapping:
        return

    frameCounter = max(frameCounter - delta, 0)
    
    if(frameCounter <= 0):
        frameCounter = frameDuration
        currentFrameIdx = (currentFrameIdx + 1) % grapFrames
        
    Input.set_custom_mouse_curosr(grapFrames[currentFrameIdx])
    

func releaseObject():
    Input.set_custom_mouse_curosr(idleSprite)
    isGrapping = false

func grapObject():
    frameCounter = frameDuration
    currentFrameIdx = 0
    isGrapping = true
    pass