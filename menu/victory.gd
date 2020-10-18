extends Control


func _ready():
	pass # Replace with function body.


var time_in_screen = 0.0

func _process(delta):
	time_in_screen += delta
	
	if (time_in_screen > 10.0):
		get_tree().change_scene("res://menu/MainMenu.tscn")
