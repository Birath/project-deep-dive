extends Area
class_name ScannableNode

signal fully_scanned

export(int) var scans_required = 1

var ping_speed = 20

var is_scanned := false
var times_scanned := 0
var time_since_scan_start: float = 0.0
var scanning := false

var scan_source_distance: float

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !scanning: 
		return
	time_since_scan_start += delta
	if time_since_scan_start * ping_speed >= scan_source_distance:
		scan()

func scan() -> void:
	times_scanned += 1
	if !is_scanned && times_scanned >= scans_required:
		emit_signal("fully_scanned", self)
		is_scanned = true
	scanning = false
	
func start_scan(dist: float) -> void:
	time_since_scan_start = 0
	scanning = true
	scan_source_distance = dist

func _on_node_area_entered(area: Area) -> void:
	if "sonar" in area.get_groups():
		start_scan(self.to_local(area.global_transform.origin).length())
		
