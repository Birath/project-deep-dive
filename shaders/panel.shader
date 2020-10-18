shader_type spatial;
render_mode unshaded;

uniform float maxDist = 10.;
uniform float pingSpeed = 1.;
uniform float size = 16.;
uniform float panelSize = 1.;
uniform sampler2D tex;

uniform float time0;
uniform float Time;

void fragment() {	
	float dist = length(UV - vec2(0.5, 0.5));
	float sizeDist = dist * size;
	
	float line = abs(fract(sizeDist - 0.5) - 0.5) / fwidth(sizeDist);
	
	float t = pingSpeed*(Time-time0);
	float beep = clamp(1.-abs(dist*(maxDist/panelSize)-t), 0., 1.);
	beep += clamp((t-dist*(maxDist/panelSize)), 0., 0.3);
	beep *= clamp(1.-(t-maxDist)*pingSpeed, 0., 1.);
	vec3 sonarCol =  vec3(0., (1. - min(line, 1.))*beep, 0.);
	
	vec3 col = texture(tex, UV).xyz;
//	float fade = sin(-pingSpeed*TIME + dist/spread);
//	vec3 sonar = vec3(0., (1. - min(line, 1.))*fade, 0.);
	ALBEDO = col + sonarCol * (1.-step(vec3(0.01), col));

}

