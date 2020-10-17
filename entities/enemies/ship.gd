extends RigidBody


export var FORWARD_SPEED = 5
export var TURNING_SPEED = 3

var TARGET_GOAL_DISTANCE = 10

var rng = RandomNumberGenerator.new()

export (PackedScene) var Depth_charge

var target_pos := Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	randomize_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_distance = target_pos - transform.origin
	target_distance.y = 0
	if target_distance.length() < TARGET_GOAL_DISTANCE:
		print("Reached target")
		randomize_target()
		print("New target: ", target_pos)
		
		#TODO move
		var depth_charge = Depth_charge.instance()
		owner.add_child(depth_charge)
		depth_charge.transform = global_transform
		get_node("depth_charge_drop").play()


func _physics_process(delta):
		# Forward force
		add_force(get_forward_vector() * FORWARD_SPEED, get_forward_vector() * - 20)

		# Horizontal directional force
		add_force(get_horizontal_vector() * TURNING_SPEED, get_forward_vector() * - 20)


func get_forward_vector():
	return global_transform.basis.x


func get_horizontal_vector():
	var horizontal_vector = target_pos - transform.origin
	horizontal_vector.y = 0
	return horizontal_vector.normalized() * -1


func randomize_target():
	#target_pos.x = rng.randf_range(-512, 512)
	target_pos.x = rng.randf_range(-100, 100)
	#target_pos.z = rng.randf_range(-512, 512)
	target_pos.z = rng.randf_range(-100, 100)


func _on_sonar_detection_area_entered(area):
	if "sonar" in area.get_groups():
		print("sub detected sonar")
		target_pos = area.transform.origin
