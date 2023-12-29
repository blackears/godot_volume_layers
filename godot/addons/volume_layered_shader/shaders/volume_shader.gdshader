/*
* MIT License
*
* Copyright (c) 2023 Mark McKay
* https://github.com/blackears/godot_volume_layers
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

shader_type spatial;
render_mode unshaded, cull_front;

const int MAX_EXCLUSION_PLANES = 4;

uniform sampler3D texture_volume : source_color,filter_linear_mipmap,repeat_disable;
uniform sampler2D gradient: filter_linear_mipmap,repeat_disable;
uniform float zoom = 2;
uniform int layers = 2;
uniform float opacity = 1;
uniform float gamma = 1;
uniform float color_scalar = 1;
uniform int num_exclusion_planes = 0;
uniform vec4[MAX_EXCLUSION_PLANES] exclusion_planes;

varying vec3 pos_local;
varying vec3 pos_world;


void vertex() {
	pos_local = VERTEX;
	pos_world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

vec3 isect_plane(vec3 view_origin, vec3 view_dir, vec3 plane_point, vec3 plane_dir)
{
	float s = dot((plane_point - view_origin), plane_dir) / dot(view_dir, plane_dir);
	return s * view_dir + view_origin;
}


void fragment() {
	vec3 model_origin_world = MODEL_MATRIX[3].xyz;
	vec3 plane_norm = normalize(CAMERA_POSITION_WORLD - model_origin_world);
	
	vec4 col;
	
	for (int layer_idx = 0; layer_idx < layers; ++layer_idx)
	{
		float layer_frac = float(layer_idx + 1) / float(layers + 1);
		vec3 plane_origin = model_origin_world + plane_norm * (layer_frac - .5) * 2.0;
		
		vec3 p_world = isect_plane(CAMERA_POSITION_WORLD, pos_world - CAMERA_POSITION_WORLD, plane_origin, plane_norm);
		
		bool plane_test_passed = true;
		for (int i = 0; i < min(num_exclusion_planes, MAX_EXCLUSION_PLANES); ++i)
		{
			if (dot(vec4(p_world, -1.0), exclusion_planes[i]) > 0.0) {
				plane_test_passed = false;
				break;
			}
		}
		if (!plane_test_passed)
			continue;
		
		mat4 inv_model_mtx = inverse(MODEL_MATRIX);
		vec3 p_local = (inv_model_mtx * vec4(p_world, 1.0)).xyz;

		
		vec3 tex_sample_pt = ((p_local * zoom) / 2.0 + vec3(.5, .5, .5));
		vec4 layer_col = texture(texture_volume, tex_sample_pt);
		if (tex_sample_pt.x < 0.0 || tex_sample_pt.x > 1.0 
			|| tex_sample_pt.y < 0.0 || tex_sample_pt.y > 1.0 
			|| tex_sample_pt.z < 0.0 || tex_sample_pt.z > 1.0)
			continue;
		
		layer_col = texture(gradient, vec2(pow(layer_col.r, gamma), 0));
		layer_col.a *= opacity;
		layer_col *= color_scalar;

		col = mix(col, layer_col, layer_col.a);
	}
	
	ALBEDO = col.xyz;
	ALPHA = col.a;
}
