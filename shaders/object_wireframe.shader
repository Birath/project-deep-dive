shader_type spatial;
render_mode specular_schlick_ggx, unshaded;

uniform bool in_editor;

uniform float width;
uniform vec4 wire_color : hint_color;
uniform vec3 ping;
uniform float max_distance;

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
const float fadeSpeed = 0.02;

// GlobalExpression:0
float fade_distance(float dist, float max_dist, float slope) {
	return 1.0;
}

void fragment() {
	// Input:2
	vec3 n_out2p0 = vec3(UV, 0.0);

// ScalarUniform:15
	float n_out15p0 = width;

// ScalarOp:17
	float n_in17p0 = 1.00000;
	float n_out17p0 = n_in17p0 - n_out15p0;

// VectorCompose:18
	float n_in18p2 = 1.00000;
	vec3 n_out18p0 = vec3(n_out17p0, n_out17p0, n_in18p2);

// Compare:10
	bool n_out10p0;
	{
		bvec3 _bv = lessThanEqual(n_out2p0, n_out18p0);
		n_out10p0 = all(_bv);
	}

// VectorCompose:16
	float n_in16p2 = 0.00000;
	vec3 n_out16p0 = vec3(n_out15p0, n_out15p0, n_in16p2);

// Compare:9
	bool n_out9p0;
	{
		bvec3 _bv = greaterThanEqual(n_out2p0, n_out16p0);
		n_out9p0 = all(_bv);
	}

// VectorOp:12
	vec3 n_out12p0 = vec3(n_out10p0 ? 1.0 : 0.0) * vec3(n_out9p0 ? 1.0 : 0.0);

// Color:7
	vec3 n_out7p0 = vec3(0.000000, 0.000000, 0.000000);
	float n_out7p1 = 1.000000;

// ColorUniform:19
	vec3 n_out19p0 = wire_color.rgb;
	float n_out19p1 = wire_color.a;

// VectorSwitch:3
	vec3 n_out3p0;
	if(all(bvec3(n_out12p0)))
	{
		n_out3p0 = n_out7p0;
	}
	else
	{
		n_out3p0 = n_out19p0;
	}

// Input:20
	mat4 n_out20p0 = CAMERA_MATRIX;

// Input:22
	vec3 n_out22p0 = VERTEX;

// TransformVectorMult:23
	vec3 n_out23p0 = (n_out20p0 * vec4(n_out22p0, 1.0)).xyz;

// VectorUniform:24
	vec3 n_out24p0 = ping;

// VectorOp:26
	vec3 n_out26p0 = n_out23p0 - n_out24p0;

// VectorLen:25
	float n_out25p0 = length(n_out26p0);

// ScalarUniform:32
	float n_out32p0 = max_distance;

// Expression:40
	float n_out40p0;
	n_out40p0 = 0.0;
	{
		n_out40p0 = fade_distance(n_out25p0, n_out32p0, 3);
	}

// Input:33
	float n_out33p0 = TIME;

// ScalarOp:39
	float n_in39p1 = 5.00000;
	float n_out39p0 = n_out33p0 * n_in39p1;

// ScalarFunc:34
	float n_out34p0 = sin(n_out39p0);

// ScalarOp:36
	float n_in36p1 = 0.25000;
	float n_out36p0 = n_out34p0 * n_in36p1;

// ScalarOp:35
	float n_in35p1 = 0.50000;
	float n_out35p0 = n_out36p0 + n_in35p1;

// ScalarOp:44
	float n_out44p0 = n_out40p0 * n_out35p0;

// VectorOp:38
	vec3 n_out38p0 = n_out3p0 * vec3(n_out44p0);

	// * WORLD_MATRIX
	vec3 coord = (CAMERA_MATRIX * vec4(VERTEX,1.)).xyz;
	float outc = 0.0;
	float color = 0.;
	vec3 sonar[] = {pos0, pos1, pos2, pos3, pos4, pos5};
	float time[] = {time0, time1, time2, time3, time4, time5};
	for (int i = 0; i < sonar.length(); i++) {
		float dist = length(sonar[i]-coord);
		
		float t = fadeSpeed*(Time-time[i]);
		//float t = fadeSpeed*1000.0;
//		float beep = exp(-pow(dist-t,2.)/10.)*(1.-step(t, dist));
		float beep = clamp(1.-abs(dist-t), 0., 1.);
		beep += clamp((t-dist), 0., 0.3);
		beep *= clamp(1.0-(t-maxDist)*fadeSpeed, 0., 1.);
		color +=  beep;
	}

if (in_editor)
	ALBEDO = n_out38p0;
else
	ALBEDO = n_out38p0 * color;

}