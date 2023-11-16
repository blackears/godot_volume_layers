shader_type spatial;

uniform sampler2D texture_flat : source_color,filter_linear_mipmap,repeat_disable;
uniform sampler3D texture_volume : source_color,filter_linear_mipmap,repeat_disable;
varying vec3 pos;

void vertex() {
	pos = VERTEX + vec3(.5, .5, .5);
}

void fragment() {
//	vec3 ttt = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 ttt = pos.xyz;
	
	ALBEDO = texture(texture_volume, ttt.xyz).xyz;
//	ALBEDO = texture(texture_flat, ttt.xz).xyz;
//	ALBEDO = pos;
}
