extends RigidBody


export var FORWARD_SPEED = 10
export var TURNING_SPEED = 1
export var VERTICAL_SPEED = 1

var target_position := Vector3()

var TARGET_GOAL_DISTANCE = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	# get player position
	set_linear_velocity(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_distance = (target_position - transform.origin).length()
	if target_distance < TARGET_GOAL_DISTANCE:
		get_node("explosion_sound").play()
		queue_free()


func _physics_process(delta):
		# Forward force
		add_force(get_forward_vector() * FORWARD_SPEED, get_forward_vector() * -10)

		# Horizontal directional force
		add_force(get_horizontal_vector() * TURNING_SPEED, get_forward_vector() * -10)

		# Vertical directional force
		add_central_force(get_vertical_vector() * VERTICAL_SPEED)


func get_forward_vector():
	return global_transform.basis.x


func get_horizontal_vector():
	var horizontal_vector = target_position - transform.origin
	horizontal_vector.y = 0
	return horizontal_vector.normalized() * -1


func get_vertical_vector():
	var vertical_vector = Vector3(0, target_position.y - transform.origin.y, 0)
	if vertical_vector.y < 0.1:
		return Vector3.ZERO
	return vertical_vector.normalized()
