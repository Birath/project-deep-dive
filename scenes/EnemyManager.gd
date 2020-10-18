extends Spatial

var enemy = preload("res://entities/enemies/enemy_sub.tscn")
var mine = preload("res://entities/enemies/mine.tscn")
var boat = preload("res://assets/enemies/attack_boat.tscn") #Flytta attack_boat till entities?
var isSpawned = 0
var rng = RandomNumberGenerator.new()




# Called when the node enters the scene tree for the first time.
func _ready():
	var node = get_node("../goal_manager").positions
	rng.randomize()
	var length = node.size()
	for n in range(length):
		spawn_mine(n,5)
		spawn_boat(n)
	

	
func _process(_delta):
	var player_points = get_node("../goal_manager").complete_sources 
	if player_points >= 1 && isSpawned == 0:
		spawn_e()
		isSpawned = 1

func spawn_e():
	var s = enemy.instance()
	var player = get_node("../Player")
	var posx = player.global_transform.origin.x
	var posy = player.global_transform.origin.y
	var posz = player.global_transform.origin.z
	s.translate(Vector3(posx+20, posy+10, posz))
	add_child(s)
	
	
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
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
