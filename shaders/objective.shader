shader_type spatial;
render_mode unshaded;

void fragment() {
	float n = 5.;
	float d = length(VERTEX);
	ALBEDO = vec3(d, 0., 0.);
}