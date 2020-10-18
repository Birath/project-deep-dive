extends Spatial

var enemy = preload("res://entities/enemies/enemy_sub.tscn")
var mine = preload("res://entities/enemies/mine.tscn")
var boat = preload("res://entities/enemies/ship.tscn")
var isSpawned = 0
var rng = RandomNumberGenerator.new()
var player
#var p = get_parent().get_node("Player")



# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var node = get_node("../goal_manager").positions
	get_node("../goal_manager").connect("scan_complete", self, "_on_scan_complete")
	player = get_node("../Player")
	var length = node.size()
	for n in range(length):
		spawn_mine(n,5)
		spawn_boat(n)
	

	
func _process(_delta):
	pass
	# var player_points = get_node("../goal_manager").complete_sources #Scannable nodes från scannable source?
	# if player_points >= 1 && isSpawned == 0:
	# 	spawn_e()
	# 	isSpawned = 1

func _on_scan_complete(scans_left: int, next_goal) -> void:
	var towards_next_goal = player.global_transform.origin.direction_to(next_goal.global_transform.origin)
	var distance = player.global_transform.origin.distance_to(next_goal.global_transform.origin)
	if scans_left == 3:
		var spawn_pos = player.global_transform.origin + towards_next_goal * distance * 0.5
		spawn_pos.y += 10
		spawn_uboat(spawn_pos)
		spawn_pos = player.global_transform.origin + Vector3(rng.randf_range(50, 100), 5, rng.randf_range(50, 100))
		spawn_uboat(spawn_pos)
		
	if scans_left == 2:
		var spawn_pos = player.global_transform.origin + towards_next_goal * distance * 0.2
		spawn_pos.y += 10
		spawn_uboat(spawn_pos)
		spawn_pos = player.global_transform.origin + towards_next_goal * distance * 0.9
		spawn_uboat(spawn_pos)
	if scans_left == 1:
		var spawn_pos = player.global_transform.origin + Vector3(rng.randf_range(50, 100), 5, rng.randf_range(50, 100))
		spawn_uboat(spawn_pos)
		spawn_pos = player.global_transform.origin + Vector3(rng.randf_range(50, 100), 5, rng.randf_range(50, 100))
		spawn_uboat(spawn_pos)
		spawn_uboat(next_goal.global_transform.origin)
		spawn_uboat(next_goal.global_transform.origin + Vector3(30, 0, 30))


func spawn_uboat(pos: Vector3):
	var s = enemy.instance()
	add_child(s)
	s.global_translate(pos)
	
	
const grid_space = 20
func spawn_mine(var i, var grid_size):
	var grid = []
	for x in range (grid_size):
		for y in range (grid_size):
			grid.push_back(Vector2(x, y)) 
	print (grid)
	var node = get_node("../goal_manager").positions
	var posx = node[i].x + (grid_space/2)
	var posy = node[i].y
	var posz = node[i].z + (grid_space/2)
		
	for index in range (5):
		var x = rng.randi_range(0, grid.size()-1)
		var cor = grid[x]
		grid.remove(x)
		var s = mine.instance()

		s.translate(Vector3(
			posx+ (cor.x - grid_size/2.0) *grid_space + rng.randf_range(-5, 5), 
			posy + 10 + rng.randf_range(-5, 5),
			posz+ (cor.y-grid_size/2.0) *grid_space + rng.randf_range(-5, 5)
		))
		add_child(s)
		
func spawn_boat(var i):
	
	var node = get_node("../goal_manager").positions
	var posx = node[i].x + rng.randf_range(35, 120)
	var posy = 155 #?
	var posz = node[i].z + rng.randf_range(35, 120)
	for index in range (3): #Kaotisk spawning av båtar
		var s = boat.instance()

		s.translate(Vector3(posx+(index*rng.randf_range(70, 220)), posy, posz+(index*rng.randf_range(70, 220))))
		add_child(s)
		s.transform.basis = transform.basis.rotated(Vector3(0, 1, 0), PI/(index+1))
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
