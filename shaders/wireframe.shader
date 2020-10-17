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

const float maxDist = 50.;
const float size = 0.5;
const float fadeSpeed = 2.;
const float fade = 1.;
const float fadeFunc = 4.;
const float lineFunc = 4.;

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

float picker(float value, float choice) {
	return max(1. - abs(value - choice), 0);
}

void fragment() {	
	vec2 coord = (CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).xz;
	
	// Compute anti-aliased world-space grid lines
	vec2 grid = abs(fract(coord - 0.5) - 0.5) / fwidth(coord);
	
	float height = (CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).y;
	height *= size;
	
	float color = 0.;
	vec3 sonar[] = {pos0, pos1, pos2, pos3, pos4, pos5};
	for (int i = 0; i < sonar.length(); i++) {
		vec2 sonarPoint = sonar[i].xy;
		float dist = length(sonarPoint-coord);
		dist *= size;
		float line1 = min(grid.x, grid.y);
		float line2 = abs(fract(height - 0.5) - 0.5) / fwidth(height);
		float line3 = min(line1, line2);
		float line4 = abs(fract(dist - 0.5) - 0.5) / fwidth(dist);
		
		float line = 0.;
		line += line1 * picker(lineFunc, 1);
		line += line2 * picker(lineFunc, 2);
		line += line3 * picker(lineFunc, 3);
		line += line4 * picker(lineFunc, 4);
		
		float fade1 = 1. - (dist / maxDist);
		float fade2 = 1. - pow(dist / maxDist, 2);
		float fade3 = 1. - pow(dist / maxDist, 0.1);
		float fade4 = exp(-dist / maxDist);
		
		float fader = 0.;
		fader += fade1 * picker(fadeFunc, 1);
		fader += fade2 * picker(fadeFunc, 2);
		fader += fade3 * picker(fadeFunc, 3);
		fader += fade4 * picker(fadeFunc, 4);
		float t = 0.001*(Time-sonar[i].z);
		float d = dist*0.1;
		float beep = pow(exp(-abs(d-t)), 2.)*(1.-step(t, d));
//		beep = exp(-abs(dist-t));
//		beep = 1. + 5.*(dist-t);
//		beep = 1. + 5.*(dist-t);
		fader *= beep;
		color +=  (1. - min(line, 1.))*fader;
	}
	ALBEDO = vec3(0., color, 0.);
}
