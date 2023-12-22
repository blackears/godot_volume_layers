#[compute]

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


