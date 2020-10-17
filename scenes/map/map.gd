extends Spatial

var sonarPoints = [];
var sonarTimes = [];

var chunks = [];

func _ready():
	chunks.push_back(get_node("chunk0"));
	chunks.push_back(get_node("chunk1"));
	chunks.push_back(get_node("chunk2"));
	chunks.push_back(get_node("chunk3"));
	for chunk in chunks:
		for i in range(5):
			chunk._material.set_shader_param("pos"+str(i), Vector3(10000.0,10000.0,10000.0));

func _process(delta):
	var time = OS.get_ticks_msec();
	for chunk in chunks:
		chunk._material.set_shader_param("Time", time);

func _send_sonar(var pos : Vector3):
	var time = OS.get_ticks_msec();
	sonarPoints.push_back(pos);
	sonarTimes.push_back(time);
	if sonarPoints.size() > 6:
		sonarPoints.pop_front();
		sonarTimes.pop_front();
	for chunk in chunks:
		for i in range(sonarPoints.size()):
			chunk._material.set_shader_param("pos"+str(i), sonarPoints[i]);
			chunk._material.set_shader_param("time"+str(i), sonarTimes[i]);
	
	