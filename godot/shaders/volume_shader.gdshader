shader_type spatial;
render_mode unshaded, cull_front;

uniform sampler3D texture_volume : source_color,filter_linear_mipmap,repeat_disable;
uniform sampler2D gradient: filter_linear_mipmap,repeat_disable;
uniform float zoom = 2;
uniform int layers = 2;
uniform float opacity = 1;
//uniform int layer_index = 0;

varying vec3 pos_local;
varying vec3 pos_world;


void vertex() {
	pos_local = VERTEX;
	pos_world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
//	pos = VERTEX + vec3(.5, .5, .5);
}

vec3 isect_plane(vec3 view_origin, vec3 view_dir, vec3 plane_point, vec3 plane_dir)
{
	float s = dot((plane_point - view_origin), plane_dir) / dot(view_dir, plane_dir);
	return s * view_dir + view_origin;
}


void fragment() {
	// Place fragment code here.
	vec3 model_origin_world = MODEL_MATRIX[3].xyz;
	vec3 plane_norm = normalize(CAMERA_POSITION_WORLD - model_origin_world);
	
//	vec3 p_world = isect_plane(CAMERA_POSITION_WORLD, CAMERA_DIRECTION_WORLD, model_origin_world, plane_norm);
	vec4 col;
	for (int layer_idx = 0; layer_idx < layers; ++layer_idx)
//	int layer_idx = layer_index;
	{
		float layer_frac = float(layer_idx + 1) / float(layers + 1);
		vec3 plane_origin = model_origin_world + plane_norm * (layer_frac - .5) * 2.0;
//		vec3 plane_origin = model_origin_world + plane_norm * 200.0;
		
		vec3 p_world = isect_plane(CAMERA_POSITION_WORLD, pos_world - CAMERA_POSITION_WORLD, plane_origin, plane_norm);
		mat4 inv_model_mtx = inverse(MODEL_MATRIX);
		vec3 p_local = (inv_model_mtx * vec4(p_world, 1.0)).xyz;

		
	//	vec4 col = vec4(plane_norm, 1.0);
	//	vec4 col = vec4(p_world, 1.0);
		
		vec3 tex_sample_pt = ((p_local * zoom) / 2.0 + vec3(.5, .5, .5));
		vec4 layer_col = texture(texture_volume, tex_sample_pt);
		if (tex_sample_pt.x < 0.0 || tex_sample_pt.x > 1.0 
			|| tex_sample_pt.y < 0.0 || tex_sample_pt.y > 1.0 
			|| tex_sample_pt.z < 0.0 || tex_sample_pt.z > 1.0)
			layer_col = vec4(0.0, 0.0, 0.0, 0.0);
		
		layer_col = texture(gradient, vec2(layer_col.r, 0));
		//layer_col = vec4(1.0, 1.0, 1.0, layer_col.r);

		col = layer_col * layer_col.a + col * (1.0 - layer_col.a);
	}
	
	ALBEDO = col.xyz;
//	ALBEDO = col.xyz;
	//ALBEDO = vec3(1, 0 ,0);
	ALPHA = col.a;
}
