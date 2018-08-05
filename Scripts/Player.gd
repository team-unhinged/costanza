extends KinematicBody

# UI-exposed variables
export (float) var gravity = -50

export (float) var MOUSE_SENSITIVITY = 0.05

export (float) var acceleration = 10
export (float) var decceleration = 10

export (float) var move_speed = 30
export (float) var jump_speed = 10
export (bool) var invert_y_look = false
export (bool) var invert_x_look = false

# Script global variables
var direction_vector
var movement_vector

var camera
var collider

# Called when the node is added to the scene for the first time.
func _ready():
	camera = $Camera
	collider = $Collider
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func process_user_input(delta):
	# We will not use the 'y' component of this vector
	movement_vector = Vector3()
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
		print("player_move_right pressed...")
	if Input.is_action_pressed("player_jump"):
		movement_vector.y += 1
		print("player_jump pressed...")

func apply_movement(delta):
	# Called every frame. Delta is time since last frame.
	direction_vector = Vector3()
	# Normalize the movement vector so speed doesn't accumulate
	movement_vector = movement_vector.normalized()
	# Alter the direction vector based on the applied rotations
	direction_vector += -self.transform.basis.z.normalized() * movement_vector.z
	direction_vector += self.transform.basis.x.normalized() * movement_vector.x
	#direction_vector.y += gravity * delta
	direction_vector = direction_vector.normalized()
	# Move the player in the direction of the direction vector
	move_and_slide(direction_vector * move_speed, Vector3(0, -1, 0))

func _physics_process(delta):
	process_user_input(delta)
	apply_movement(delta)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        camera.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * (1 if invert_y_look else -1) ))
        self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * (1 if invert_x_look else -1)))

        var camera_rot = camera.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)
        camera.rotation_degrees = camera_rot