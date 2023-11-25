#[compute]
#version 450

layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;


layout(set = 0, binding = 0, std430) restrict readonly buffer MyParameterBuffer {
	ivec3 kernel_radius;
	int not_used;  //Not used - pad to 4x4 byte boundary
	float[] kernel;
}
params;

//layout(rgba32f, set = 0, binding = 1) uniform image3D source_image;
layout(rgba8, set = 0, binding = 1) uniform image3D source_image;

//layout(rgba32f, set = 0, binding = 2) uniform image3D result_image;
layout(rgba8, set = 0, binding = 2) uniform image3D result_image;

void main() {
	ivec3 pos = ivec3(gl_GlobalInvocationID.xyz);
	ivec3 offset = -params.kernel_radius;
	ivec3 kernel_size = params.kernel_radius * 2 + 1;

	vec4 value;
	for (int k = 0; k < kernel_size.z; ++k) {
		for (int j = 0; j < kernel_size.y; ++j) {
			for (int i = 0; i < kernel_size.x; ++i) {
				vec4 samp = imageLoad(source_image, pos + offset + ivec3(i, j, k));
				int kernel_index = (k * kernel_size.y + j) * kernel_size.x + i;
				value += params.kernel[kernel_index] * samp;
			}
		}
	}
	
	imageStore(result_image, ivec3(gl_GlobalInvocationID.xyz), value);
}
