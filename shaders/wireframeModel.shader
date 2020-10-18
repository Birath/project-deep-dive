shader_type spatial;
render_mode unshaded;

uniform float maxDist = 10.;
uniform float size = 0.5;
uniform float fadeSpeed = 2.;
uniform float fade : hint_range(0., 1., 1.);
uniform float fadeFunc : hint_range(1., 4., 1.);
uniform float lineFunc : hint_range(1., 4., 1.);

float picker(float value, float choice) {
	return max(1. - abs(value - choice), 0);
}

void fragment() {	
	vec2 coord = (CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).xz;
	coord = UV;
	coord *= size;
	
	// Compute anti-aliased world-space grid lines
	vec2 grid = abs(fract(coord - 0.5) - 0.5) / fwidth(coord);
	
	float height = (CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).y;
	height *= size;
	
	float dist = length((CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).xz);
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
	fader *= mix(1., sin(-fadeSpeed*TIME+0.1*dist), fade);
	ALBEDO = vec3(0., (1. - min(line, 1.))*fader, 0.);
}

