extends KinematicBody

var MOUSE_SENSITIVITY = 0.05

export var move_speed = 10

var direction = Vector3()

var camera
var collider

func _ready():
	# Called when the node is added to the scene for the first time.
	camera = $Camera
	collider = $Collider
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	direction = Vector3()
	# We will not use the 'y' component of this vector
	var movement_vector = Vector3()
	if Input.is_action_pressed("player_move_forward"):
		movement_vector.z += 1
		print("player_move_forward pressed...")
	if Input.is_action_pressed("player_move_backward"):
		movement_vector.z += -1
		print("player_move_backward pressed...")
	if Input.is_action_pressed("player_move_left"):
		movement_vector.x += -1
		print("player_move_left pressed...")
	if Input.is_action_pressed("player_move_right"):
		movement_vector.x += 1
		print("player_move_right pressed")
	if Input.is_action_pressed("player_rotate_left"):
		self.rotate_y(deg2rad(90 * 0.05))
		print("player_rotate_left pressed...")
	if Input.is_action_pressed("player_rotate_right"):
		self.rotate_y(deg2rad(90 * 0.05 * -1))
		print("player_rotate_right pressed... - Basis: ", transform.basis)

	# Normalize the movement vector so speed doesn't accumulate
	movement_vector = movement_vector.normalized()

	# Alter the direction vector based on the applied rotations
	direction += -self.transform.basis.z.normalized() * movement_vector.z
	direction += self.transform.basis.x.normalized() * movement_vector.x
	
	direction.y = 0
	direction = direction.normalized()

	# Move the player in the direction of the direction vector
	move_and_slide(direction * move_speed, Vector3(0, 1, 0))
	
func _input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        camera.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
        self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

        var camera_rot = camera.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)
        camera.rotation_degrees = camera_rot