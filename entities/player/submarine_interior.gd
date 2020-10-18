extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Color) var blue
export(Color) var green
export(Color) var red
export(Color) var yellow

export(Color) var disabled

export(int) var state_left = 0
export(int) var state_right = 0

var game_manager
var map_entities_to_areas: Dictionary = {}
var draw_map := false
var time_since_sonar = 0
var ping_speed := 0.02 * 1000
var sonar_source_position: Vector2
var scanned_areas: Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	set_left(4)
	set_right(4)		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var color
	var map = get_node("sonar_map2");
	map.get_surface_material(1).set_shader_param("Time", OS.get_ticks_msec());
	var player = get_node("..");
	var coord = Vector2(player.global_transform.origin.x, player.global_transform.origin.z)
	var rot = player.rotation.y
	map.get_surface_material(1).set_shader_param("Pos", coord);
	map.get_surface_material(1).set_shader_param("angle", -rot);
	
	if OS.get_ticks_msec() / 100 % 10 < 6:
		color = yellow
	else:
		color = disabled
	if state_left == 2:
		$indicator_left2.get_surface_material(1).set_shader_param("color", color)
		$light_left.light_color = color
	if state_right == 2:
		$indicator_right2.get_surface_material(1).set_shader_param("color", color)
		$light_right.light_color = color
	
	time_since_sonar += delta
	draw_map_entities()
	game_manager = get_tree().get_root().get_node("/root/World/goal_manager")

	if game_manager != null:
		set_arrow(game_manager.get_current_goal())
	
func send_sonar(pos):
	var map = get_node("sonar_map2");
	map.get_surface_material(1).set_shader_param("time0", OS.get_ticks_msec());
	map.get_surface_material(1).set_shader_param("pos0", pos);


func set_left(color):
	state_left = color
	var c = get_color(color)
	
	$indicator_left2.get_surface_material(1).set_shader_param("color", c)
	$light_left.light_color = c
	
	
func set_right(color):
	state_right = color	
	var c = get_color(color)
	$indicator_right2.get_surface_material(1).set_shader_param("color", c)
	$light_right.light_color = c

func start_draw_map() -> void:
	draw_map = true

func set_draw_map(value: bool) -> void:
	if value && value != draw_map:
		time_since_sonar = 0
		sonar_source_position = Vector2(self.global_transform.origin.x, self.global_transform.origin.z)
		scanned_areas.clear()
	draw_map = value

func get_color(index):
	match(index):
		0: return green
		1: return blue
		2: return yellow
		3: return red
		3: return disabled
	return Color(0, 0, 0)
	
func set_screen(nodes, maxNodes):
	var label = get_node("interior_display/ViewportContainer/Viewport/Label")
	label.text = "Nodes\n" + str(nodes) + "/" + str(maxNodes)

func set_arrow(position: Vector3) -> void:
	if position == null:
		$map_viewport/Viewport/map/arrow.visible = false
		return
			
	var global = global_transform
	var origin = global.origin
	var basis = global.basis
	var pos = Vector2(position.x, position.z) 
	var d_origin = Vector2(origin.x, origin.z)
	var towards = pos.direction_to(d_origin)
	var distance = pos.distance_to(d_origin)
	if distance < 100:
		var scale = max(distance / 100, 0.75)
		$map_viewport/Viewport/map/arrow/arrow1.rect_scale = Vector2(scale, scale)
		$map_viewport/Viewport/map/arrow/arrow2.rect_scale = Vector2(scale, scale)
		
	if distance < 0: # TODO Maybe don't show when source is scanned
		$map_viewport/Viewport/map/arrow.visible = false
	else:
		$map_viewport/Viewport/map/arrow.visible = true
	var angle = Vector2(basis.z.x, basis.z.z).angle_to(towards)
	$map_viewport/Viewport/map/arrow.set_rotation(-angle + PI)

func draw_map_entities() -> void:
	for area in map_entities_to_areas:
		var entity = map_entities_to_areas[area]
		var relative_position = self.to_local(area.global_transform.origin)
		var map_x = 128 + relative_position.x / 100 * 128
		var map_y = 128 + -relative_position.z / 100 * 128
		entity.set_position(Vector2(map_x, map_y))
		
		if 2.5 < time_since_sonar && time_since_sonar < 8  && scanned_areas.find(area) != -1:
			entity.visible = true
		elif "scan_node" in area.get_groups() && area.is_scanned:
			entity.visible = true
		elif "torpedo" in area.get_groups():
			entity.visible = true
		elif time_since_sonar < 2.5 && time_since_sonar * ping_speed > sonar_source_position.distance_to(Vector2(area.global_transform.origin.x, area.global_transform.origin.z)):
			entity.visible = draw_map
			if scanned_areas.find(area) == -1:
				scanned_areas.push_back(area)
		else:
			entity.visible = false	
		
		
func _on_MapSonar_area_entered(area: Area) -> void:
	var a = area.name
	if area.name == "Sonar":
		return
	var relative_position = self.to_local(area.global_transform.origin)
	var map_x = 128 + -relative_position.x / 100 * 128
	var map_y = 128 + -relative_position.z / 100 * 128
	
	var dot = ColorRect.new()
	dot.visible = false
	dot.rect_size = Vector2(5, 5)
	set_entity_color(area, dot)
	$map_viewport/Viewport/map.add_child(dot)
	dot.set_position(Vector2(map_x, map_y))
	map_entities_to_areas[area] = dot

func set_entity_color(area: Area, entity) -> void:
	if "scan_node" in area.get_groups():
		entity.color = Color("B86D5C")
	elif "enemy" in area.get_groups():
		entity.color = Color(1, 0, 0);


func _on_MapSonar_area_exited(area: Area) -> void:
	if map_entities_to_areas.has(area):
		map_entities_to_areas[area].queue_free()
		map_entities_to_areas.erase(area)
	
