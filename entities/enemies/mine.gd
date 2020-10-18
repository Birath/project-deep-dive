extends Spatial


var has_exploded = false


func _ready():
	pass # Replace with function body.


func explode():
	if not has_exploded:
		has_exploded = true
		get_node("explosion_sound").play()
		set_process(false)


func _on_mine_area_area_entered(area):
	if area.get_name() == "hit_area":
		explode()


func _on_explosion_sound_finished():
	queue_free()
