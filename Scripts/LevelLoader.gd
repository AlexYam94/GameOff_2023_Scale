class_name LevelLoader
extends Node2D

@export var levels : Array[PackedScene]
@export var fadeShaders : Array[Shader]
@export var fadeSprite : Sprite2D
@export var fadeTime : float = 1

var currentLevelNode : Node2D

var currentLevelIdx : int = 0
var fadeTimeCounter : float
var shouldFade : bool
var isFadeIn : bool
var material : ShaderMaterial

var rng = RandomNumberGenerator.new()

func _ready():
	material = fadeSprite.material
	if get_child_count() > 0:
		currentLevelNode = get_child(0)
	if not currentLevelNode:
		currentLevelNode = levels[0].instantiate()
		add_child(currentLevelNode)
		SignalManager.connect(SignalManager.loadNextLevelSignalName, startLoadNextLevel)
	pass

func _process(delta):
	if not (shouldFade):
		return
	if(fadeTimeCounter <= 0 and isFadeIn):
		loadNextLevel()
		isFadeIn = false
		fadeTimeCounter = fadeTime
	elif not isFadeIn and fadeTimeCounter <= 0:
		shouldFade = false

	fadeTimeCounter = max(fadeTimeCounter - delta, 0)
	var fadeValue : float
	if(isFadeIn):
		fadeValue = (fadeTime - fadeTimeCounter)/fadeTime
	else:
		fadeValue = fadeTimeCounter/fadeTime
	
	material.set_shader_param("fadeValue", fadeValue)
	
func reset():
	#TODO
	#Reset count down
	pass
			
	
func startLoadNextLevel():
	var shader = pickFadeShader()
	material.shader = shader
	fadeTimeCounter = fadeTime
	shouldFade = true
	isFadeIn = true


func loadNextLevel():
	currentLevelNode.queue_free()
	currentLevelIdx+=1
	currentLevelNode = levels[currentLevelIdx].instantiate()
	add_child(currentLevelNode)
	reset()

func pickFadeShader():
	return rng.randi_range(0, fadeShaders.size())
