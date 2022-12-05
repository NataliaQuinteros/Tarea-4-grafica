extends KinematicBody


# How fast the player moves in meters per second.
export var speed = 30
export var acceleration = 50
export var friction = 50
export var gravity = -9.8
export var terminal_velocity = 120

# The downward acceleration when in the air, in meters per second squared.
export var fall_acceleration = 75

# Initial Mouse Input vector
var mouse_movement = Vector2()
export var mouse_sensitivity = 10

var velocity = Vector3.ZERO
var velocity2d = Vector2.ZERO

onready var head = $Head
onready var camera = $Head/Camera

# Called when the node enters the scene tree for the first time.
func _ready():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Input handling Function
func _input(event):
	# When the mouse moves, the displacement is added to the vector.
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_movement += event.relative

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var input_vector = Vector3.ZERO
	input_vector += transform.basis.x * Input.get_axis("move_left", "move_right")
	input_vector += transform.basis.z * Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()
	
		# If the input vector is different from zero, accelerate toward speed in that direction
	if input_vector != Vector3.ZERO:
		velocity2d = velocity2d.move_toward(
			Vector2(input_vector.z, input_vector.x) * speed,
			acceleration * delta)
	# If the input vector is zero, decelerate toward zero
	else:
		apply_friction(delta)
			
	# The velocity2d vector is applied to the actual 3D velocity
	apply_velocity2d()
	
	# Gravity is applied to the actual 3D velocity
	apply_gravity(delta)
		
	# Apply the velocity vector to the KinematicBody
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, 0.785398, false)
	velocity2d = Vector2(velocity.z, velocity.x)
	
	
	
	rotate_view(delta)
	
func apply_gravity(delta):
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)
	
func apply_velocity2d():
	velocity.z = velocity2d.x
	velocity.x = velocity2d.y

func apply_friction(delta):
	velocity2d = velocity2d.move_toward(Vector2.ZERO, friction * delta)

# Function for receiving the mouse input and rotating the player accordingly.
func rotate_view(delta):
	# When the mouse moves, the movement is applied and the vector is reset.
	if mouse_movement != Vector2.ZERO:
		rotation_degrees.y -= mouse_movement.x * delta * mouse_sensitivity
		head.rotation_degrees.x -= mouse_movement.y * delta * mouse_sensitivity
		if head.rotation_degrees.x <= -90:
			head.rotation_degrees.x = -90
		if head.rotation_degrees.x >= 90:
			head.rotation_degrees.x = 90
		mouse_movement = Vector2.ZERO
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
