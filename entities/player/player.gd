extends RigidBody

const speed = 10
const rot_speed = 1

var angular_vel = 0.0
const max_angular_velocity = 0.5
const turn_force = 5

export(float) var sonar_time = 0.5
export(float) var sonar_cooldown = 5.0
var current_sonar = 0.0
var current_sonar_cooldown = 0.0
var is_dying = false
var time_till_death = INF

export(ShaderMaterial) var object_material

func _ready():
	$Sonar/Active.disabled = true

func _process(delta):
	object_material.set_shader_param("Time", OS.get_ticks_msec())
	

func _physics_process(delta):
	get_movement_input(delta)
	get_sonar_input(delta)
	process_death(delta)
	

func get_movement_input(delta):
	var left = global_transform.basis.x;
	var forward = -global_transform.basis.z;
	if Input.is_action_pressed("forward"):
		add_central_force(forward * speed)
	if Input.is_action_pressed("back"):
		add_central_force(-forward * speed)
	if Input.is_action_pressed("up"):
		add_central_force(Vector3.UP * speed)
	if Input.is_action_pressed("down"):
		add_central_force(Vector3.DOWN * speed)
	if Input.is_action_pressed("right"):
		add_force(Vector3.LEFT * turn_force, Vector3.BACK * 10)
		add_force(Vector3.RIGHT * turn_force, Vector3.FORWARD * 10)

		#angular_vel = clamp(angular_vel - rot_speed * delta,
		#-max_angular_velocity, max_angular_velocity)
	if Input.is_action_pressed("left"):
		add_force(Vector3.RIGHT * turn_force, Vector3.BACK * 10)
		add_force(Vector3.LEFT * turn_force, Vector3.FORWARD *  10)
		#angular_vel = clamp(angular_vel + rot_speed * delta,
		#-max_angular_velocity, max_angular_velocity)
	#set_angular_velocity(Vector3.UP * angular_vel)

var sonar_index = 0
const SONAR_INDEX_MAX = 6

func get_sonar_input(delta):

	if Input.is_action_just_pressed("sonar") and current_sonar_cooldown <= 0.0:
		$Sonar/Active.disabled = false
		$SonarPing.play()
		current_sonar = sonar_time
		current_sonar_cooldown = sonar_cooldown
		var map = get_node("../root")

		map._send_sonar(global_transform.origin)
		var interior = get_node("submarine_interior")
		interior.send_sonar()
		
		object_material.set_shader_param("pos" + str(sonar_index), global_transform.origin)
		object_material.set_shader_param("time" + str(sonar_index), OS.get_ticks_msec())
		sonar_index = (sonar_index + 1) % SONAR_INDEX_MAX
		
		$submarine_interior.set_draw_map(true)
		$submarine_interior.set_right(1)
	elif (current_sonar <= 0.0 && !$Sonar/Active.disabled):
		$Sonar/Active.disabled = true
		$submarine_interior.set_right(2)
		
	else:
		current_sonar -= delta
	current_sonar_cooldown -= delta
	if (current_sonar_cooldown <= 0.0):
		$submarine_interior.set_draw_map(false)
		$submarine_interior.set_right(0)

func process_death(delta):
	if Input.is_action_just_pressed("emergency"):
		damage(7.5)
	
	if !is_dying:
		return
	if time_till_death > 0.0:
		time_till_death -= delta
		$Alarm.volume_db = clamp(time_till_death * 2.5 - 10, -50, 10)
		$black_overlay.modulate = Color(1.0, 1.0, 1.0, clamp(1.0 - time_till_death / 5.0, 0.0, 1.0))
	else:
		print("DEAD")
		$Alarm.stop()
		$Alarm.volume_db = 10
		$DangerLight.enabled = false
		$black_overlay.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		get_tree().change_scene("res://menu/Dead.tscn")

func _on_Sonar_area_entered(area):
	pass

func damage(time):
	is_dying = true
	time_till_death = time
	$DangerLight.enabled = true
	$Alarm.play()

