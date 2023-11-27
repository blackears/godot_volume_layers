#[compute]
#version 450

layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;

layout(rgba8, set = 0, binding = 0) readonly restrict uniform image3D source_image;

layout(rgba8, set = 0, binding = 1) writeonly restrict uniform image3D mipmap_image;


void main() {
	ivec3 pos = ivec3(gl_GlobalInvocationID.xyz);

	vec4 c000 = imageLoad(source_image, pos * 2 + ivec3(0, 0, 0));
	vec4 c100 = imageLoad(source_image, pos * 2 + ivec3(1, 0, 0));
	vec4 c010 = imageLoad(source_image, pos * 2 + ivec3(0, 1, 0));
	vec4 c110 = imageLoad(source_image, pos * 2 + ivec3(1, 1, 0));
	vec4 c001 = imageLoad(source_image, pos * 2 + ivec3(0, 0, 1));
	vec4 c101 = imageLoad(source_image, pos * 2 + ivec3(1, 0, 1));
	vec4 c011 = imageLoad(source_image, pos * 2 + ivec3(0, 1, 1));
	vec4 c111 = imageLoad(source_image, pos * 2 + ivec3(1, 1, 1));

	vec4 color = (c000 + c100 + c010 + c110 + c001 + c101 + c011 + c111) / 8;

	imageStore(mipmap_image, ivec3(gl_GlobalInvocationID.xyz), color);
}


