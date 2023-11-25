#[compute]
#version 450

layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;

layout(r32f, set = 0, binding = 0) uniform image3D source_image;
//layout(rgba32f, set = 0, binding = 0) uniform image3D source_image;
//layout(rgba8, set = 0, binding = 0) uniform image3D source_image;

layout(r32f, set = 0, binding = 1) uniform image3D mipmap_image;
//layout(rgba32f, set = 0, binding = 1) uniform image3D mipmap_image;
//layout(rgba8, set = 0, binding = 1) uniform image3D mipmap_image;


void main() {
	ivec3 pos = ivec3(gl_GlobalInvocationID.xyz);

	float c000 = imageLoad(source_image, pos * 2 + ivec3(0, 0, 0)).r;
	float c100 = imageLoad(source_image, pos * 2 + ivec3(1, 0, 0)).r;
	float c010 = imageLoad(source_image, pos * 2 + ivec3(0, 1, 0)).r;
	float c110 = imageLoad(source_image, pos * 2 + ivec3(1, 1, 0)).r;
	float c001 = imageLoad(source_image, pos * 2 + ivec3(0, 0, 1)).r;
	float c101 = imageLoad(source_image, pos * 2 + ivec3(1, 0, 1)).r;
	float c011 = imageLoad(source_image, pos * 2 + ivec3(0, 1, 1)).r;
	float c111 = imageLoad(source_image, pos * 2 + ivec3(1, 1, 1)).r;

	float color = (c000 + c100 + c010 + c110 + c001 + c101 + c011 + c111) / 8;

	imageStore(mipmap_image, ivec3(gl_GlobalInvocationID.xyz), vec4(color.rrr, 1.0));
	
}


