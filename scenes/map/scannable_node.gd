extends Area
class_name ScannableNode

signal fully_scanned

export(int) var scans_required = 3

var is_scanned := false
var times_scanned := 0

func _ready() -> void:
	pass

#func _process(delta: float) -> void:
#	pass

func scan() -> void:
	times_scanned += 1
	if !is_scanned && times_scanned == scans_required:
		emit_signal("fully_scanned", self)
		is_scanned = true
	

func _on_node_area_entered(area: Area) -> void:
	if "sonar" in area.get_groups():
		scan()
		
