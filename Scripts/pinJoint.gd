extends PinJoint2D

var initSoftness
# Called when the node enters the scene tree for the first time.
func _ready():
	initSoftness = softness


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	softness = initSoftness
