extends RigidBody


export var FORWARD_SPEED = 5
export var TURNING_SPEED = 1
export var VERTICAL_SPEED = 1

var TARGET_GOAL_DISTANCE = 10

var rng = RandomNumberGenerator.new()

export (PackedScene) var Torpedo

var target_pos = Vector3(60, 50, 90)
#var target_pos := Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	#randomize_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_distance = (target_pos - transform.origin).length()
	if target_distance < TARGET_GOAL_DISTANCE:
		print("Reached target")
		randomize_target()
		print("New target: ", target_pos)
		
		# TODO move
		var torpedo = Torpedo.instance()
		owner.add_child(torpedo)
		torpedo.transform = global_transform


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
	var horizontal_vector = target_pos - transform.origin
	horizontal_vector.y = 0
	return horizontal_vector.normalized() * -1


func get_vertical_vector():
	var vertical_vector = Vector3(0, target_pos.y - transform.origin.y, 0)
	if vertical_vector.y < 0.1:
		return Vector3.ZERO
	return vertical_vector.normalized()


func randomize_target():
	target_pos.x = rng.randf_range(-100, 100)
	target_pos.y = rng.randf_range(-50, 50)
	target_pos.z = rng.randf_range(-100, 100)


func _on_sonar_detection_area_entered(area):
	if "sonar" in area.get_groups():
		target_pos = area.transform.origin
