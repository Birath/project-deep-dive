extends RigidBody


export var SINK_SPEED = 5

var target_position := Vector3()

var TARGET_GOAL_DISTANCE = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	# get player position
	set_linear_velocity(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_distance = (target_position - transform.origin).length()
	if target_distance < TARGET_GOAL_DISTANCE:
		#get_node("explosion_sound").play()
		queue_free()


func _physics_process(delta):
		# Sinking force
		add_central_force(get_vertical_vector() * SINK_SPEED)


func get_vertical_vector():
	return -global_transform.basis.y
