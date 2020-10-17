extends Camera

const MOUSE_SENSITIVITY = 0.002
const MIN_MAX_ANGLE_Y = PI / 2
const MIN_ANGLE_X = -PI / 2 + PI / 8
const MAX_ANGLE_X = PI / 2 - PI / 8


var freelook = false

func _ready():
	pass # Replace with function body.
#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("freelook"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		freelook = true
	if event.is_action_released("freelook"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		freelook = false
	
	
	# Horizontal mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation.y = clamp(rotation.y - event.relative.x * MOUSE_SENSITIVITY, 
			-MIN_MAX_ANGLE_Y, MIN_MAX_ANGLE_Y)
	
	# Vertical mouse look, clamped to -90..90 degrees
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation.x = clamp(rotation.x - event.relative.y * MOUSE_SENSITIVITY, 
			MIN_ANGLE_X, MAX_ANGLE_X)

func _process(delta):
	if (freelook):
		return
	rotation.y = lerp(rotation.y, 0, 0.1)
	rotation.x = lerp(rotation.x, 0, 0.1)
