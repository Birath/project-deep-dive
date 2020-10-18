extends RigidBody


export var SINK_SPEED = 3

var has_exploded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_linear_velocity(Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
		# Sinking force
		add_central_force(get_vertical_vector() * SINK_SPEED)


func get_vertical_vector():
	return -global_transform.basis.y


func explode():
	if not has_exploded:
		has_exploded = true
		get_node("explosion_sound").play()
		set_process(false)


func _on_collision_area_body_entered(body):
	explode()


func _on_explosion_sound_finished():
	queue_free()
