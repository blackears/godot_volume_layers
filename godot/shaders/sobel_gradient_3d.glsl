#[compute]
#version 450

layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;

layout(r32f, set = 0, binding = 0) uniform image3D source_image;

layout(rgba32f, set = 0, binding = 1) uniform image3D result_image;

//Sobel kernel for gradient calculations
vec3[] sobel_kernel = {
	vec3(-1.0, -1.0, -1.0), vec3(0.0, -2.0, -2.0), vec3(1.0, -1.0, -1.0),
	vec3(-2.0, 0.0, -2.0), vec3(0.0, 0.0, -4.0), vec3(2.0, 0.0, -2.0),
	vec3(-1.0, 1.0, -1.0), vec3(0.0, 2.0, -2.0), vec3(1.0, 1.0, -1.0),
	vec3(-2.0, -2.0, 0.0), vec3(0.0, -4.0, 0.0), vec3(2.0, -2.0, 0.0),
	vec3(-4.0, 0.0, 0.0), vec3(0.0, 0.0, 0.0), vec3(4.0, 0.0, 0.0),
	vec3(-2.0, 2.0, 0.0), vec3(0.0, 4.0, 0.0), vec3(2.0, 2.0, 0.0),
	vec3(-1.0, -1.0, 1.0), vec3(0.0, -2.0, 2.0), vec3(1.0, -1.0, 1.0),
	vec3(-2.0, 0.0, 2.0), vec3(0.0, 0.0, 4.0), vec3(2.0, 0.0, 2.0),
	vec3(-1.0, 1.0, 1.0), vec3(0.0, 2.0, 2.0), vec3(1.0, 1.0, 1.0),	
};

void main() {
	ivec3 pos = ivec3(gl_GlobalInvocationID.xyz);

	vec4 value;
	for (int k = 0; k < 3; ++k) {
		for (int j = 0; j < 3; ++j) {
			for (int i = 0; i < 3; ++i) {
				float samp = imageLoad(source_image, pos + ivec3(i - 1, j - 1, k - 1)).r;
				int kernel_index = (k * 3 + j) * 3 + i;
				value += vec4(sobel_kernel[kernel_index] * samp, 0);
			}
		}
	}
	
	value.a = 1.0;
	imageStore(result_image, ivec3(gl_GlobalInvocationID.xyz), value);
}


