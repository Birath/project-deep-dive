extends RigidBody


export var FORWARD_SPEED = 5
export var TURNING_SPEED = 3

var TARGET_GOAL_DISTANCE = 10

var rng = RandomNumberGenerator.new()

export (PackedScene) var Depth_charge

var target_position := Vector3()

var should_drop_charge = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	randomize_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_distance = Vector3(0, global_transform.origin.y, 0)
	target_distance = target_position.distance_to(global_transform.origin)
	if target_distance < TARGET_GOAL_DISTANCE:
		if should_drop_charge:
			drop_depth_charge()
			
		print("Reached target")
		randomize_target()
		print("New target: ", target_position)


func _physics_process(delta):
		# Forward force
		add_force(get_forward_vector() * FORWARD_SPEED, get_forward_vector() * - 20)

		# Horizontal directional force
		add_force(get_horizontal_vector() * TURNING_SPEED, get_forward_vector() * - 20)


func get_forward_vector():
	return global_transform.basis.x


func get_horizontal_vector():
	var horizontal_vector = target_position - global_transform.origin
	horizontal_vector.y = 0
	return horizontal_vector.normalized() * -1


func randomize_target():
	should_drop_charge = false
	#target_position.x = rng.randf_range(-512, 512)
	target_position.x = rng.randf_range(-100, 100)
	#target_position.z = rng.randf_range(-512, 512)
	target_position.z = rng.randf_range(-100, 100)


func drop_depth_charge():
	var depth_charge = Depth_charge.instance()
	owner.add_child(depth_charge)
	depth_charge.transform = global_transform
	get_node("depth_charge_drop").play()


func _on_sonar_detection_area_entered(area):
	if "sonar" in area.get_groups():
		print("ship detected sonar")
		should_drop_charge = true
		target_position = area.global_transform.origin
