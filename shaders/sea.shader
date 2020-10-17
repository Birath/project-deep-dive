shader_type spatial;
render_mode unshaded, cull_front;

uniform sampler2D u_terrain_heightmap;
uniform mat4 u_terrain_inverse_transform;

uniform float size = 0.5;
uniform float lineFunc : hint_range(1., 3, 1.);

float picker(float value, float choice) {
	return max(1. - abs(value - choice), 0);
}

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
	vec2 coord = (CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).xz;
	coord *= size*0.2;
	
	// Compute anti-aliased world-space grid lines
	vec2 grid = abs(fract(coord - 0.5) - 0.5) / fwidth(coord);
	
	float height = (CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).y;
	height *= size*50.;
	
	float dist = length((CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).xz);
	dist *= size;
	float line1 = min(grid.x, grid.y);
	float line2 = abs(fract(height - 0.5) - 0.5) / fwidth(height);
	float line3 = min(line1, line2);
	
	float line = 0.;
	line += line1 * picker(lineFunc, 1);
	line += line2 * picker(lineFunc, 2);
	line += line3 * picker(lineFunc, 3);
	
	float col =  (1. - min(line, 1.));
	col *= smoothstep(1., 0., (1./200.)*(length(VERTEX)-800.));
	ALBEDO = vec3(0., col, 0.);
}