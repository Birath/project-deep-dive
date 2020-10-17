extends RigidBody


export var FORWARD_SPEED = 10
export var TURNING_SPEED = 5
export var VERTICAL_SPEED = 3

export var target_position := Vector3()

var has_exploded = false

var TARGET_GOAL_DISTANCE = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	# get player position
	set_linear_velocity(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_distance = target_position.distance_to(global_transform.origin)
	if target_distance < TARGET_GOAL_DISTANCE:
		explode()


func _physics_process(delta):
		# Forward force
		add_force(get_forward_vector() * FORWARD_SPEED, get_forward_vector() * - 2)

		# Horizontal directional force
		add_force(get_horizontal_vector() * TURNING_SPEED, get_forward_vector() * - 1)

		# Vertical directional force
		add_central_force(get_vertical_vector() * VERTICAL_SPEED)


func get_forward_vector():
	return global_transform.basis.x


func get_horizontal_vector():
	var horizontal_vector = target_position - global_transform.origin
	horizontal_vector.y = 0
	return horizontal_vector.normalized() * -1


func get_vertical_vector():
	var vertical_vector = Vector3(0, target_position.y - global_transform.origin.y, 0)
	if abs(vertical_vector.y) < 0.2:
		return Vector3.ZERO
	print(vertical_vector.y)
	return vertical_vector.normalized()
	
func explode():
	if not has_exploded:
		has_exploded = true
		get_node("explosion_sound").play()
		hide()
		set_process(false)


func _on_explosion_sound_finished():
	queue_free()


func _on_torpedo_area_body_entered(body):
	print("torpedo hit something")
	if body.get_name() == "Player":
		print("hit player")
		explode()
