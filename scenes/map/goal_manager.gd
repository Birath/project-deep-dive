extends Spatial

var ScanSource = preload("res://scenes/map/scannable_source.tscn")

export(int) var MAP_SIZE = 512
export(int) var SCAN_SOURCES = 1
export(int) var MINIMUM_DISTANCE = 200

var rand_generate := RandomNumberGenerator.new()
var complete_sources := 0
var size_instance

var positions: Array = []
var uncompleted_sources = []
var current_goal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rand_generate.randomize()
	size_instance = ScanSource.instance()
	create_goals()
	current_goal = uncompleted_sources[randi() % uncompleted_sources.size()]
	var screen = get_node("../Player/submarine_interior");
	screen.set_screen(complete_sources, SCAN_SOURCES);

func create_goals() -> void:
	for quadrant in range(SCAN_SOURCES):
		var pos: Vector3 = calculate_goal_position(quadrant)
		
		var source = ScanSource.instance()
		source.translate(pos)
		positions.push_back(pos)
		add_child(source)
		source.connect("complete", self, "_on_source_complete")
		uncompleted_sources.push_back(source)
	

func calculate_goal_position(quadrant: int) -> Vector3:
	var size: Vector2 = size_instance.get_size()
	
	var lower_x = MAP_SIZE * (quadrant % 2) * -1 + size.x / 2
	var upper_x = MAP_SIZE * (1 if quadrant % 2 == 0 else 0) - size.x / 2
	
	var lower_z = MAP_SIZE * (quadrant / 2) * -1 + size.y / 2
	var upper_z = MAP_SIZE * (1 if quadrant / 2 == 0 else 0) - size.y / 2
	
	var x_range: Vector2 = Vector2(lower_x, upper_x)
	var z_range: Vector2 = Vector2(lower_z, upper_z)
	
	var fixed_ranges = fix_minimum_distance(quadrant, x_range, z_range)
	x_range = fixed_ranges[0]
	z_range = fixed_ranges[1]
	
	print("x: ", x_range.x, ", ", x_range.y, ", z: ", z_range.x, ", ", z_range.y)
	
	var x := rand_generate.randf_range(x_range.x, x_range.y)
	var z := rand_generate.randf_range(z_range.x, z_range.y)
	print("Quadrant ", quadrant, ": ", x, ", ", z)
	if quadrant == 0:
		return Vector3(50, 0, 50)
	return Vector3(x, 0, z)

func fix_minimum_distance(quadrant: int, x_range: Vector2, z_range: Vector2) -> Array:
	if quadrant in [1, 2]:
		var neighbour_pos: Vector3 = positions[0]
		if quadrant == 1 && abs(neighbour_pos.x - x_range.y) < MINIMUM_DISTANCE:
			x_range.y -= abs(neighbour_pos.x - x_range.y)
		if quadrant == 2 && abs(neighbour_pos.z - z_range.y) < MINIMUM_DISTANCE:
			z_range.y -= abs(neighbour_pos.z - z_range.y)

	elif quadrant == 3:
		var source_1_pos: Vector3 = positions[1]
		var source_2_pos: Vector3 = positions[2]
		if abs(source_1_pos.z - z_range.x) < MINIMUM_DISTANCE:
			z_range.x += abs(source_1_pos.z - z_range.x)
		if abs(source_2_pos.x - x_range.x) < MINIMUM_DISTANCE:
			x_range.x -= abs(source_2_pos.x - x_range.x)
	return [x_range, z_range]

func _on_source_complete(source) -> void:
	uncompleted_sources.remove(uncompleted_sources.find(source))
	if current_goal == source:
		current_goal = uncompleted_sources[randi() % uncompleted_sources.size()]
	complete_sources += 1
	var screen = get_node("../Player/submarine_interior");
	screen.set_screen(complete_sources, SCAN_SOURCES);
	if complete_sources == SCAN_SOURCES:
		get_tree().change_scene("res://menu/Victory.tscn")
		
func get_current_goal() -> Vector3:
	return current_goal.global_transform.origin
