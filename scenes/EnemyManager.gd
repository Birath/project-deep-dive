extends Spatial

var enemy = preload("res://entities/enemies/enemy_sub.tscn")
var isSpawned = 0
#var p = get_parent().get_node("Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

	
func _process(_delta):
	var player_points = get_node("../goal_manager").complete_sources #Scannable nodes från scannable source?
	if player_points >= 1 && isSpawned == 0:
		spawn_e()
		isSpawned = 1

func spawn_e():
	var s = enemy.instance()
	add_child(s)
	var player = get_node("../Player")
	var posx = player.global_transform.origin.x
	var posy = player.global_transform.origin.y
	var posz = player.global_transform.origin.z
	s.translate(Vector3(posx+20, posy+10, posz))
