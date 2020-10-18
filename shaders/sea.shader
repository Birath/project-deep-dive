shader_type spatial;
render_mode unshaded, cull_front;

uniform sampler2D u_terrain_heightmap;
uniform mat4 u_terrain_inverse_transform;

uniform float size = 0.5;

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
	
	vec2 offset = vec2(0);
	offset.x = cos(TIME + coord.x + coord.y) * 0.1;
	offset.y = sin(TIME + coord.x + coord.y) * 0.1;
	coord += offset;
	
	// Compute anti-aliased world-space grid lines
	vec2 grid = abs(fract(coord - 0.5) - 0.5) / fwidth(coord);
	
	float height = (CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).y;
	height *= size*50.;
	
	float dist = length((CAMERA_MATRIX * vec4(VERTEX,1.) * WORLD_MATRIX).xz);
	dist *= size;
	float line = min(grid.x, grid.y);
	
	float col =  (1. - min(line, 1.));
	col *= smoothstep(1., 0., (1./200.)*(length(VERTEX)-800.));
	ALBEDO = vec3(0., 0., col);
}