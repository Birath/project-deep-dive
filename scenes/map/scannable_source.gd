extends Spatial

const ScanNode = preload("res://scenes/map/scannable_node.tscn")

export(int) var columns = 5
export(int) var rows = 5
export(int) var distance_between_nodes = 20

var completed_nodes: Array = []
var scanned_nodes := 0
var is_all_nodes_scanned := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	for col in range(columns):
		for row in range(rows):
			var new_node: ScannableNode = ScanNode.instance()
			new_node.translate(Vector3(col*distance_between_nodes, 0, row*distance_between_nodes))
			self.add_child(new_node)
			new_node.connect("fully_scanned", self, "_on_node_scanned")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_node_scanned(node: ScannableNode) -> void:
	scanned_nodes += 1
	if scanned_nodes == columns * rows:
		print("All nodes scanned")
	
