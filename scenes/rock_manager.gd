extends Spatial


var rng = RandomNumberGenerator.new()

var rock1 = preload("res://assets/enemies/rock1.tscn")
var rock2 = preload("res://assets/enemies/rock2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	

var generate = true
func _physics_process(delta):
	if !generate:
		return
	generate = false
	
	for x in range(2):
		for y in range(2):
			spawn_rocks(20, 100, x, y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

const max_height = 100
const min_height = -100

const chunk_size = 512.0

func spawn_rocks(var grid_size, var amt, var offsetX, var offsetY):
	var grid_space = chunk_size / grid_size
	var grid = []
	for x in range (grid_size):
		for y in range (grid_size):
			grid.push_back(Vector2(x, y)) 

	for index in range (amt):
		var i = rng.randi_range(0, grid.size()-1)
		var coord = grid[i]
		grid.remove(i)
		
		#  - grid_size / 2.0
		var x = (coord.x) * grid_space + rng.randf_range(-grid_space, grid_space) + offsetX * chunk_size
		var z = (coord.y) * grid_space + rng.randf_range(-grid_space, grid_space) + offsetX * chunk_size

		var space_state = get_world().direct_space_state
		# use global coordinates, not local to node
		
		var result = space_state.intersect_ray(Vector3(x, min_height, z), Vector3(x, max_height, z))

		if (result.empty()):
			print("fail @ ", x, " - ", " # ", " - ", z)
			continue
		var y = result.position.y
		#if x > 512:
		#	print("yes, the x, ", x, " - ", y, " - ", z)
		#if z > 512:
		#	print("yes, the z, ", x, " - ", y, " - ", z)
		
		var inst = null
		if rng.randi_range(0, 1) == 0:
			inst = rock1.instance()
		else:
			inst = rock2.instance()
		inst.translate(Vector3(x, y, z))
		add_child(inst)
