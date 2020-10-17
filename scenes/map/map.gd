extends Spatial

var sonarPoints = [];

var chunks = [];

func _ready():
	chunks.push_back(get_node("chunk0"));
	chunks.push_back(get_node("chunk1"));
	chunks.push_back(get_node("chunk2"));
	chunks.push_back(get_node("chunk3"));
	for chunk in chunks:
		for i in range(5):
			chunk._material.set_shader_param("pos"+str(i), Vector2(10000.0, 10000.0));

func _process(delta):
	var time = OS.get_ticks_msec();
	for chunk in chunks:
		chunk._material.set_shader_param("Time", time);

func _send_sonar(var pos : Vector2):
	var time = OS.get_ticks_msec();
	var v = Vector3(pos.x, pos.y, time);
	sonarPoints.push_back(v);
	if sonarPoints.size() > 6:
		sonarPoints.pop_front();
	for chunk in chunks:
		for i in range(sonarPoints.size()):
			chunk._material.set_shader_param("pos"+str(i), sonarPoints[i]);
	
	
