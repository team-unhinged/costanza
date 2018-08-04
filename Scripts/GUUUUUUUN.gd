extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (float) var MOUSE_SENSITIVITY = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			$Camera.rotate(Vector3(1,0,0), deg2rad(event.relative.y) * MOUSE_SENSITIVITY * -1)
			self.rotate(Vector3(0,1,0), deg2rad(event.relative.x) * MOUSE_SENSITIVITY * -1)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	# rotate the game object
	