#[compute]
#version 450

layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;


layout(set = 0, binding = 0, std430) restrict readonly buffer MyParameterBuffer {
	float threshold;
	float scale;
	//Size of cube grid in cells
	ivec3 grid_size;
}
params;


layout(set = 0, binding = 1) uniform sampler3D density_tex;
layout(set = 0, binding = 2) uniform sampler3D gradient_tex;

layout(rgba32f, set = 0, binding = 3) uniform image1D result_points;
layout(rgba32f, set = 0, binding = 4) uniform image1D result_normals;

float calc_edge_weight(float threshold, float p0_val, float p1_val) {
	return (threshold - p0_val) / (p1_val - p0_val);
}

const float pos_infinity = 1.0 / 0.0;

const int[][15] tessellation_table = {
	// 0x00
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	// 0x01
	{0, 3, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
};

vec3 get_edge_point(int edge_idx, float[12] edge_weights) {

	switch (edge_idx) {
		case 0:
			return vec3(edge_weights[0], 0, 0);
		case 1:
			return vec3(1, 0, edge_weights[1]);
		case 2:
			return vec3(edge_weights[2], 0, 1);
		case 3:
			return vec3(0, 0, edge_weights[3]);
		case 4:
			return vec3(0, edge_weights[4], 0);
		case 5:
			return vec3(1, edge_weights[5], 0);
		case 6:
			return vec3(1, edge_weights[6], 1);
		case 7:
			return vec3(0, edge_weights[7], 1);
		case 8:
			return vec3(edge_weights[8], 1, 0);
		case 9:
			return vec3(1, 1, edge_weights[9]);
		case 10:
			return vec3(edge_weights[10], 1, 1);
		case 11:
			return vec3(0, 1, edge_weights[11]);
		default:
			return vec3(pos_infinity, pos_infinity, pos_infinity);
	}

}
/*
static func create_cube_mesh(cube_idx:int, edge_weights:Array[float])->PackedVector3Array:
	var result:PackedVector3Array
	var edge_list:Array = MarchingCubeTable.get_tessellation_table()[cube_idx]

	for edge_idx in edge_list:
		result.append(get_edge_point(edge_idx, edge_weights))
			
	return result
	*/
vec3[15] create_cube_mesh(int cube_index, float[12] edge_weights) {
	int[15] edge_list = tessellation_table[cube_index];
	vec3[15] points;
	
	for (int i = 0; i < 15; ++i)
		points[i] = get_edge_point(edge_list[i], edge_weights);
	
	return points;
}

void main() {
	//gl_NumWorkGroups * gl_WorkGroupSize;
	ivec3 pos = ivec3(gl_GlobalInvocationID.xyz);
	vec3 samp_pos = vec3(pos / params.grid_size);
	vec4 col = texture(density_tex, samp_pos);

	vec3 c000 = (pos + vec3(0, 0, 0)) / params.grid_size;
	vec3 c100 = (pos + vec3(1, 0, 0)) / params.grid_size;
	vec3 c010 = (pos + vec3(0, 1, 0)) / params.grid_size;
	vec3 c110 = (pos + vec3(1, 1, 0)) / params.grid_size;
	vec3 c001 = (pos + vec3(0, 0, 1)) / params.grid_size;
	vec3 c101 = (pos + vec3(1, 0, 1)) / params.grid_size;
	vec3 c011 = (pos + vec3(0, 1, 1)) / params.grid_size;
	vec3 c111 = (pos + vec3(1, 1, 1)) / params.grid_size;
	
	float s0 = texture(density_tex, c000).r;
	float s1 = texture(density_tex, c100).r;
	float s2 = texture(density_tex, c010).r;
	float s3 = texture(density_tex, c110).r;
	float s4 = texture(density_tex, c001).r;
	float s5 = texture(density_tex, c101).r;
	float s6 = texture(density_tex, c011).r;
	float s7 = texture(density_tex, c111).r;
	
	int cube_index = (s0 > params.threshold ? 0x1 : 0)
		| (s1 > params.threshold ? 0x2 : 0)
		| (s2 > params.threshold ? 0x4 : 0)
		| (s3 > params.threshold ? 0x8 : 0)
		| (s4 > params.threshold ? 0x10 : 0)
		| (s5 > params.threshold ? 0x20 : 0)
		| (s6 > params.threshold ? 0x40 : 0)
		| (s7 > params.threshold ? 0x80 : 0);
	
	if (cube_index == 0 || cube_index == 0xff) {
		//early exit
		return;
	}
	
	float[] edge_weights = {
		calc_edge_weight(params.threshold, s0, s1),
		calc_edge_weight(params.threshold, s1, s5),
		calc_edge_weight(params.threshold, s4, s5),
		calc_edge_weight(params.threshold, s0, s4),
		
		calc_edge_weight(params.threshold, s0, s2),
		calc_edge_weight(params.threshold, s1, s3),
		calc_edge_weight(params.threshold, s5, s7),
		calc_edge_weight(params.threshold, s4, s6),

		calc_edge_weight(params.threshold, s2, s3),
		calc_edge_weight(params.threshold, s3, s7),
		calc_edge_weight(params.threshold, s6, s7),
		calc_edge_weight(params.threshold, s2, s6),
	};

	vec3[15] points = create_cube_mesh(cube_index, edge_weights);
	for (int i = 0; i < 15; ++i) {
		vec3 local_pos = (points[i] + pos) / params.grid_size;
		imageStore(result_points, int(gl_LocalInvocationIndex) * 15 + i, vec4(local_pos, 1.0));
	}
	
}
