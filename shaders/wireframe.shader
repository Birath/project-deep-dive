shader_type spatial;
render_mode unshaded;

uniform sampler2D u_terrain_heightmap;
uniform mat4 u_terrain_inverse_transform;

uniform float Time;
uniform vec3 pos0 = vec3(1000000.);
uniform vec3 pos1 = vec3(1000000.);
uniform vec3 pos2 = vec3(1000000.);
uniform vec3 pos3 = vec3(1000000.);
uniform vec3 pos4 = vec3(1000000.);
uniform vec3 pos5 = vec3(1000000.);
uniform float time0;
uniform float time1;
uniform float time2;
uniform float time3;
uniform float time4;
uniform float time5;

const float maxDist = 100.;
const float size = 0.4;
const float pingSpeed = 0.02;

void vertex() {
	vec2 cell_coords = (u_terrain_inverse_transform * WORLD_MATRIX * vec4(VERTEX, 1)).xz;
	// Must add a half-offset so that we sample the center of pixels,
	// otherwise bilinear filtering of the textures will give us mixed results (#183)
	cell_coords += vec2(0.5);

	// Normalized UV
	UV = cell_coords / vec2(textureSize(u_terrain_heightmap, 0));
	// Height displacement
	float h = texture(u_terrain_heightmap, UV).r;
	VERTEX.y = h;
}

void fragment() {	
	vec3 coord = (CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).xyz;
	
	// Compute anti-aliased world-space grid lines
	
	
	float color = 0.;
	vec3 sonar[] = {pos0, pos1, pos2, pos3, pos4, pos5};
	float time[] = {time0, time1, time2, time3, time4, time5};
	for (int i = 0; i < sonar.length(); i++) {
		float dist = length(sonar[i]-coord);
		float sizeDist = dist*size;
		float line = abs(fract(sizeDist - 0.5) - 0.5) / fwidth(sizeDist);
		
		float t = pingSpeed*(Time-time[i]);
		float ping = clamp(1.-abs(dist-t), 0., 1.);
		float beep = clamp((t-dist), 0., 0.3);
		beep *= clamp(1.-(t-maxDist)*pingSpeed, 0., 1.);
		color +=  (1. - min(line, 1.))*beep + ping;
	}
	ALBEDO = vec3(0., color, 0.);
}
