extends Spatial

var ScanSource = preload("res://scenes/map/scannable_source.tscn")

export(int) var MAP_SIZE = 512
export(int) var SCAN_SOURCES = 4

var rand_generate := RandomNumberGenerator.new()
var complete_sources := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rand_generate.randomize()
	create_goals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func create_goals() -> void:
	for quadrant in range(SCAN_SOURCES):
		var lower_x = MAP_SIZE * (quadrant % 2) * -1
		var upper_x = MAP_SIZE * (1 if quadrant % 2 == 0 else 0)
		# print(lower_x, ", ", upper_x)
		
		var x := rand_generate.randf_range(lower_x, upper_x)
		var lower_z = MAP_SIZE * (quadrant / 2) * -1
		var upper_z = MAP_SIZE * (1 if quadrant / 2 == 0 else 0)
		#print(lower_z, ", ", upper_z)
		var z := rand_generate.randf_range(lower_z, upper_z)
		var source = ScanSource.instance()
		source.translate(Vector3(x, 0, z))
		add_child(source)
		
		source.connect("complete", self, "_on_source_complete")
		
func _on_node_complete() -> void:
	complete_sources += 1
	if complete_sources == SCAN_SOURCES:
		print("You won!!!!!!")
