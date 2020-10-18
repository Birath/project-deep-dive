extends RigidBody


export var FORWARD_SPEED = 3
export var TURNING_SPEED = 1
export var VERTICAL_SPEED = 1

var TARGET_GOAL_DISTANCE = 4
var TORPEDO_LAUNCH_DISTANCE = 50

var rng = RandomNumberGenerator.new()

export (PackedScene) var Torpedo

var target_position := Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	randomize_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_distance = target_position.distance_to(global_transform.origin)
	if target_distance < TARGET_GOAL_DISTANCE:
		print("Reached target")
		randomize_target()
		print("New target: ", target_position)


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
	var horizontal_vector = target_position - global_transform.origin
	horizontal_vector.y = 0
	return horizontal_vector.normalized() * -1


func get_vertical_vector():
	var vertical_vector = Vector3(0, target_position.y - global_transform.origin.y, 0)
	if abs(vertical_vector.y) < 0.1:
		return Vector3.ZERO
	return vertical_vector.normalized()


func randomize_target():
	#target_position.x = rng.randf_range(-512, 512)
	target_position.x = rng.randf_range(-100, 100)
	target_position.y = rng.randf_range(0, 100)
	#target_pos.z = rng.randf_range(-512, 512)
	target_position.z = rng.randf_range(-100, 100)


func launch_torpedo():
	var torpedo = Torpedo.instance()
	torpedo.transform = global_transform
	get_parent().add_child(torpedo)
	torpedo.target_position = target_position
	get_node("torpedo_launch").play()
	

func should_launch_torpedo(sonar_position):
	# TODO add angle check?
	return sonar_position.distance_to(global_transform.origin) < TORPEDO_LAUNCH_DISTANCE


func _on_sonar_detection_area_entered(area):
	if "sonar" in area.get_groups():
		print("sub detected sonar")
		target_position = area.global_transform.origin
		
		if should_launch_torpedo(target_position):
			launch_torpedo()
			pass
