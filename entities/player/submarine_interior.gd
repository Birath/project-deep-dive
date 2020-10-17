extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Color) var blue
export(Color) var green
export(Color) var red
export(Color) var yellow

export(Color) var disabled

export(int) var state_left = 0
export(int) var state_right = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_left(4)
	set_right(4)	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var color
	
	if OS.get_ticks_msec() / 100 % 10 < 6:
		color = yellow
	else:
		color = disabled
	if state_left == 2:
		$indicator_left2.get_surface_material(1).set_shader_param("color", color)
		$light_left.light_color = color
	if state_right == 2:
		$indicator_right2.get_surface_material(1).set_shader_param("color", color)
		$light_right.light_color = color

func set_left(color):
	state_left = color
	var c = get_color(color)
	
	$indicator_left2.get_surface_material(1).set_shader_param("color", c)
	$light_left.light_color = c
	
	
func set_right(color):
	state_right = color	
	var c = get_color(color)
	$indicator_right2.get_surface_material(1).set_shader_param("color", c)
	$light_right.light_color = c

func get_color(index):
	match(index):
		0: return green
		1: return blue
		2: return yellow
		3: return red
		3: return disabled
	return Color(0, 0, 0)
