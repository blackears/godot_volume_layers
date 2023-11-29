#[compute]

/**
* MIT License
*
* Copyright (c) 2023 Mark McKay
* https://github.com/blackears/mri_marching_cubes
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


layout(set = 0, binding = 0, std430) restrict readonly buffer ParamBufferRO {
	float threshold;
	//float scale;
	//Size of cube grid in cells
	ivec3 grid_size;
}
params;

layout(set = 0, binding = 1, std430) restrict buffer ParamBufferRW {
	int num_vertices;
}
params_rw;


layout(set = 0, binding = 2) uniform sampler3D density_tex;
layout(set = 0, binding = 3) uniform sampler3D gradient_tex;

layout(set = 0, binding = 4, std430) restrict writeonly buffer ParamBufferWPoint {
	float[] values;
}
params_w_point;

layout(set = 0, binding = 5, std430) restrict writeonly buffer ParamBufferWNormal {
	float[] values;
}
params_w_normal;

//layout(rgba32f, set = 0, binding = 4) writeonly restrict uniform image1D result_points;
//layout(rgba32f, set = 0, binding = 5) writeonly restrict uniform image1D result_normals;

//layout(r32f, set = 0, binding = 4) writeonly restrict uniform image1D result_points;
//layout(r32f, set = 0, binding = 5) writeonly restrict uniform image1D result_normals;

const float pos_infinity = 1.0 / 0.0;

const int[] tessellation_offsets = {
	0, 0, 3, 6, 12, 15, 21, 27, 36, 39, 45, 51, 60, 66, 75, 84, 
	90, 93, 99, 105, 114, 120, 129, 138, 150, 156, 165, 174, 186, 195, 207, 219, 
	228, 231, 237, 243, 252, 258, 267, 276, 288, 294, 303, 312, 324, 333, 345, 357, 
	366, 372, 381, 390, 396, 405, 417, 429, 438, 447, 459, 471, 480, 492, 507, 522, 
	528, 531, 537, 543, 552, 558, 567, 576, 588, 594, 603, 612, 624, 633, 645, 657, 
	666, 672, 681, 690, 702, 711, 717, 729, 738, 747, 759, 771, 786, 798, 807, 822, 
	828, 834, 843, 852, 864, 873, 885, 897, 912, 921, 933, 945, 960, 972, 987, 1002, 
	1014, 1023, 1035, 1047, 1056, 1068, 1077, 1092, 1098, 1110, 1125, 1140, 1152, 1167, 1179, 1185, 
	1188, 1191, 1197, 1203, 1212, 1218, 1227, 1236, 1248, 1254, 1263, 1272, 1284, 1293, 1305, 1317, 
	1326, 1332, 1341, 1350, 1362, 1371, 1383, 1395, 1410, 1419, 1431, 1443, 1458, 1470, 1485, 1500, 
	1512, 1518, 1527, 1536, 1548, 1557, 1569, 1581, 1596, 1605, 1617, 1623, 1632, 1644, 1659, 1668, 
	1674, 1683, 1695, 1707, 1716, 1728, 1743, 1758, 1770, 1782, 1797, 1806, 1812, 1827, 1833, 1845, 
	1848, 1854, 1863, 1872, 1884, 1893, 1905, 1917, 1932, 1941, 1953, 1965, 1980, 1986, 1995, 2004, 
	2010, 2019, 2031, 2043, 2058, 2070, 2079, 2094, 2106, 2118, 2133, 2148, 2154, 2163, 2169, 2181, 
	2184, 2193, 2205, 2217, 2232, 2244, 2259, 2274, 2280, 2292, 2307, 2316, 2328, 2337, 2349, 2355, 
	2358, 2364, 2373, 2382, 2388, 2397, 2403, 2415, 2418, 2427, 2439, 2445, 2448, 2454, 2457, 2460, 
	2460, 
};

const int[] tessellation_table = {
	// 0x00
	
	// 0x01
	0, 3, 4, 
	// 0x02
	5, 1, 0, 
	// 0x03
	1, 3, 5, 3, 4, 5, 
	// 0x04
	8, 4, 11, 
	// 0x05
	11, 8, 3, 3, 8, 0, 
	// 0x06
	0, 5, 1, 4, 11, 8, 
	// 0x07
	1, 3, 11, 1, 11, 5, 5, 11, 8, 
	// 0x08
	9, 5, 8, 
	// 0x09
	5, 8, 9, 0, 3, 4, 
	// 0x0a
	9, 1, 8, 1, 0, 8, 
	// 0x0b
	9, 1, 3, 9, 3, 8, 8, 3, 4, 
	// 0x0c
	5, 4, 9, 4, 11, 9, 
	// 0x0d
	3, 11, 9, 3, 9, 0, 0, 9, 5, 
	// 0x0e
	1, 11, 9, 1, 0, 11, 0, 4, 11, 
	// 0x0f
	1, 3, 9, 3, 11, 9, 
	// 0x10
	2, 7, 3, 
	// 0x11
	4, 0, 7, 7, 0, 2, 
	// 0x12
	1, 0, 5, 2, 7, 3, 
	// 0x13
	7, 4, 5, 7, 5, 2, 2, 5, 1, 
	// 0x14
	11, 8, 4, 7, 3, 2, 
	// 0x15
	2, 8, 0, 2, 7, 8, 7, 11, 8, 
	// 0x16
	0, 5, 1, 2, 7, 3, 4, 11, 8, 
	// 0x17
	1, 2, 5, 2, 7, 5, 5, 7, 8, 7, 11, 8, 
	// 0x18
	2, 7, 3, 5, 8, 9, 
	// 0x19
	0, 2, 4, 2, 7, 4, 5, 8, 9, 
	// 0x1a
	1, 0, 9, 9, 0, 8, 2, 7, 3, 
	// 0x1b
	1, 2, 9, 2, 7, 9, 7, 4, 9, 4, 8, 9, 
	// 0x1c
	4, 11, 5, 5, 11, 9, 3, 2, 7, 
	// 0x1d
	11, 9, 7, 7, 9, 2, 2, 9, 0, 0, 9, 5, 
	// 0x1e
	0, 9, 1, 0, 4, 9, 4, 11, 9, 2, 7, 3, 
	// 0x1f
	1, 2, 9, 2, 7, 9, 7, 11, 9, 
	// 0x20
	1, 6, 2, 
	// 0x21
	2, 1, 6, 3, 4, 0, 
	// 0x22
	5, 6, 0, 6, 2, 0, 
	// 0x23
	6, 4, 5, 6, 2, 4, 2, 3, 4, 
	// 0x24
	8, 4, 11, 6, 2, 1, 
	// 0x25
	3, 11, 0, 11, 8, 0, 2, 1, 6, 
	// 0x26
	5, 6, 0, 6, 2, 0, 8, 4, 11, 
	// 0x27
	5, 6, 8, 8, 6, 11, 11, 6, 3, 3, 6, 2, 
	// 0x28
	9, 5, 8, 6, 2, 1, 
	// 0x29
	5, 8, 9, 6, 2, 1, 0, 3, 4, 
	// 0x2a
	2, 0, 8, 2, 8, 6, 6, 8, 9, 
	// 0x2b
	9, 6, 8, 6, 2, 8, 8, 2, 4, 2, 3, 4, 
	// 0x2c
	5, 4, 9, 4, 11, 9, 1, 6, 2, 
	// 0x2d
	5, 11, 9, 5, 0, 11, 0, 3, 11, 6, 2, 1, 
	// 0x2e
	9, 6, 11, 6, 2, 11, 2, 0, 11, 0, 4, 11, 
	// 0x2f
	9, 6, 11, 6, 2, 11, 2, 3, 11, 
	// 0x30
	6, 7, 1, 7, 3, 1, 
	// 0x31
	6, 7, 4, 6, 4, 1, 1, 4, 0, 
	// 0x32
	5, 6, 7, 5, 7, 0, 0, 7, 3, 
	// 0x33
	6, 7, 5, 7, 4, 5, 
	// 0x34
	7, 3, 6, 6, 3, 1, 11, 8, 4, 
	// 0x35
	0, 1, 8, 1, 6, 8, 6, 7, 8, 7, 11, 8, 
	// 0x36
	3, 6, 7, 3, 0, 6, 0, 5, 6, 11, 8, 4, 
	// 0x37
	7, 11, 6, 11, 8, 6, 8, 5, 6, 
	// 0x38
	6, 7, 1, 7, 3, 1, 9, 5, 8, 
	// 0x39
	1, 6, 7, 1, 7, 0, 0, 7, 4, 9, 5, 8, 
	// 0x3a
	0, 8, 3, 3, 8, 7, 7, 8, 6, 6, 8, 9, 
	// 0x3b
	6, 7, 9, 9, 7, 8, 8, 7, 4, 
	// 0x3c
	1, 6, 3, 3, 6, 7, 4, 9, 5, 4, 11, 9, 
	// 0x3d
	0, 1, 6, 0, 6, 7, 0, 7, 11, 0, 11, 5, 5, 11, 9, 
	// 0x3e
	0, 7, 3, 0, 6, 7, 0, 9, 6, 0, 4, 9, 4, 11, 9, 
	// 0x3f
	6, 7, 9, 7, 11, 9, 
	// 0x40
	10, 11, 7, 
	// 0x41
	7, 10, 11, 3, 4, 0, 
	// 0x42
	10, 11, 7, 1, 0, 5, 
	// 0x43
	3, 4, 1, 1, 4, 5, 7, 10, 11, 
	// 0x44
	7, 10, 4, 4, 10, 8, 
	// 0x45
	0, 10, 8, 0, 3, 10, 3, 7, 10, 
	// 0x46
	4, 7, 8, 7, 10, 8, 0, 5, 1, 
	// 0x47
	8, 5, 10, 5, 1, 10, 1, 3, 10, 3, 7, 10, 
	// 0x48
	8, 9, 5, 11, 7, 10, 
	// 0x49
	8, 9, 5, 0, 3, 4, 11, 7, 10, 
	// 0x4a
	9, 1, 8, 1, 0, 8, 10, 11, 7, 
	// 0x4b
	4, 1, 3, 4, 8, 1, 8, 9, 1, 7, 10, 11, 
	// 0x4c
	5, 4, 7, 5, 7, 9, 9, 7, 10, 
	// 0x4d
	5, 0, 9, 0, 3, 9, 9, 3, 10, 3, 7, 10, 
	// 0x4e
	9, 1, 10, 10, 1, 7, 7, 1, 4, 4, 1, 0, 
	// 0x4f
	3, 7, 1, 7, 10, 1, 10, 9, 1, 
	// 0x50
	3, 2, 11, 11, 2, 10, 
	// 0x51
	10, 0, 2, 10, 11, 0, 11, 4, 0, 
	// 0x52
	2, 10, 3, 10, 11, 3, 1, 0, 5, 
	// 0x53
	4, 5, 11, 11, 5, 10, 10, 5, 2, 2, 5, 1, 
	// 0x54
	8, 2, 10, 8, 4, 2, 4, 3, 2, 
	// 0x55
	10, 8, 2, 2, 8, 0, 
	// 0x56
	3, 2, 10, 3, 10, 4, 4, 10, 8, 1, 0, 5, 
	// 0x57
	2, 10, 1, 1, 10, 5, 5, 10, 8, 
	// 0x58
	11, 3, 10, 3, 2, 10, 8, 9, 5, 
	// 0x59
	4, 0, 2, 4, 2, 11, 11, 2, 10, 5, 8, 9, 
	// 0x5a
	3, 2, 11, 11, 2, 10, 8, 1, 0, 8, 9, 1, 
	// 0x5b
	4, 10, 11, 4, 2, 10, 4, 1, 2, 4, 8, 1, 8, 9, 1, 
	// 0x5c
	10, 9, 2, 9, 5, 2, 5, 4, 2, 4, 3, 2, 
	// 0x5d
	0, 2, 5, 5, 2, 9, 9, 2, 10, 
	// 0x5e
	4, 1, 0, 4, 9, 1, 4, 10, 9, 4, 3, 10, 3, 2, 10, 
	// 0x5f
	10, 9, 2, 2, 9, 1, 
	// 0x60
	6, 2, 1, 10, 11, 7, 
	// 0x61
	2, 1, 6, 10, 11, 7, 3, 4, 0, 
	// 0x62
	6, 2, 5, 5, 2, 0, 10, 11, 7, 
	// 0x63
	2, 5, 6, 2, 3, 5, 3, 4, 5, 10, 11, 7, 
	// 0x64
	10, 8, 7, 8, 4, 7, 6, 2, 1, 
	// 0x65
	7, 10, 8, 7, 8, 3, 3, 8, 0, 6, 2, 1, 
	// 0x66
	7, 10, 4, 4, 10, 8, 0, 6, 2, 0, 5, 6, 
	// 0x67
	3, 6, 2, 3, 5, 6, 3, 8, 5, 3, 7, 8, 7, 10, 8, 
	// 0x68
	6, 2, 1, 5, 8, 9, 10, 11, 7, 
	// 0x69
	0, 3, 4, 1, 6, 2, 5, 8, 9, 7, 10, 11, 
	// 0x6a
	9, 0, 8, 9, 6, 0, 6, 2, 0, 11, 7, 10, 
	// 0x6b
	2, 3, 6, 3, 4, 6, 4, 9, 6, 4, 8, 9, 7, 10, 11, 
	// 0x6c
	9, 5, 4, 9, 4, 10, 10, 4, 7, 1, 6, 2, 
	// 0x6d
	0, 3, 5, 5, 3, 9, 9, 3, 7, 9, 7, 10, 1, 6, 2, 
	// 0x6e
	9, 6, 2, 9, 2, 0, 9, 0, 4, 9, 4, 10, 10, 4, 7, 
	// 0x6f
	2, 3, 6, 3, 9, 6, 3, 7, 9, 7, 10, 9, 
	// 0x70
	11, 3, 1, 11, 1, 10, 10, 1, 6, 
	// 0x71
	6, 10, 1, 10, 11, 1, 1, 11, 0, 11, 4, 0, 
	// 0x72
	6, 10, 5, 10, 11, 5, 11, 3, 5, 3, 0, 5, 
	// 0x73
	6, 10, 5, 10, 11, 5, 11, 4, 5, 
	// 0x74
	3, 1, 4, 4, 1, 8, 8, 1, 10, 10, 1, 6, 
	// 0x75
	10, 8, 6, 6, 8, 1, 1, 8, 0, 
	// 0x76
	3, 8, 4, 3, 10, 8, 3, 6, 10, 3, 0, 6, 0, 5, 6, 
	// 0x77
	8, 5, 10, 10, 5, 6, 
	// 0x78
	6, 3, 1, 6, 10, 3, 10, 11, 3, 5, 8, 9, 
	// 0x79
	10, 11, 6, 6, 11, 1, 1, 11, 4, 1, 4, 0, 9, 5, 8, 
	// 0x7a
	6, 10, 11, 6, 11, 3, 6, 3, 0, 6, 0, 9, 9, 0, 8, 
	// 0x7b
	9, 6, 8, 6, 4, 8, 6, 10, 4, 10, 11, 4, 
	// 0x7c
	10, 9, 5, 10, 5, 4, 10, 4, 3, 10, 3, 6, 6, 3, 1, 
	// 0x7d
	9, 5, 10, 10, 5, 0, 10, 0, 6, 6, 0, 1, 
	// 0x7e
	0, 4, 3, 6, 10, 9, 
	// 0x7f
	6, 10, 9, 
	// 0x80
	6, 9, 10, 
	// 0x81
	0, 3, 4, 9, 10, 6, 
	// 0x82
	5, 1, 0, 9, 10, 6, 
	// 0x83
	1, 3, 5, 3, 4, 5, 6, 9, 10, 
	// 0x84
	9, 10, 6, 8, 4, 11, 
	// 0x85
	8, 0, 11, 0, 3, 11, 9, 10, 6, 
	// 0x86
	9, 10, 6, 1, 0, 5, 8, 4, 11, 
	// 0x87
	5, 1, 3, 5, 3, 8, 8, 3, 11, 6, 9, 10, 
	// 0x88
	6, 5, 10, 5, 8, 10, 
	// 0x89
	5, 8, 6, 6, 8, 10, 0, 3, 4, 
	// 0x8a
	0, 8, 10, 0, 10, 1, 1, 10, 6, 
	// 0x8b
	8, 10, 4, 4, 10, 3, 3, 10, 1, 1, 10, 6, 
	// 0x8c
	6, 5, 4, 6, 4, 10, 10, 4, 11, 
	// 0x8d
	5, 0, 6, 0, 3, 6, 3, 11, 6, 11, 10, 6, 
	// 0x8e
	6, 1, 10, 1, 0, 10, 10, 0, 11, 0, 4, 11, 
	// 0x8f
	1, 3, 6, 6, 3, 10, 10, 3, 11, 
	// 0x90
	10, 6, 9, 7, 3, 2, 
	// 0x91
	7, 4, 2, 4, 0, 2, 10, 6, 9, 
	// 0x92
	1, 0, 5, 9, 10, 6, 2, 7, 3, 
	// 0x93
	1, 4, 5, 1, 2, 4, 2, 7, 4, 9, 10, 6, 
	// 0x94
	10, 6, 9, 8, 4, 11, 7, 3, 2, 
	// 0x95
	11, 8, 0, 11, 0, 7, 7, 0, 2, 9, 10, 6, 
	// 0x96
	8, 4, 11, 5, 1, 0, 9, 10, 6, 3, 2, 7, 
	// 0x97
	2, 7, 1, 1, 7, 5, 5, 7, 11, 5, 11, 8, 6, 9, 10, 
	// 0x98
	6, 5, 10, 5, 8, 10, 2, 7, 3, 
	// 0x99
	4, 0, 7, 7, 0, 2, 10, 5, 8, 10, 6, 5, 
	// 0x9a
	6, 8, 10, 6, 1, 8, 1, 0, 8, 7, 3, 2, 
	// 0x9b
	1, 2, 7, 1, 7, 4, 1, 4, 8, 1, 8, 6, 6, 8, 10, 
	// 0x9c
	11, 5, 4, 11, 10, 5, 10, 6, 5, 3, 2, 7, 
	// 0x9d
	11, 2, 7, 11, 0, 2, 11, 5, 0, 11, 10, 5, 10, 6, 5, 
	// 0x9e
	0, 4, 1, 4, 11, 1, 11, 6, 1, 11, 10, 6, 3, 2, 7, 
	// 0x9f
	6, 1, 10, 1, 11, 10, 1, 2, 11, 2, 7, 11, 
	// 0xa0
	1, 9, 2, 9, 10, 2, 
	// 0xa1
	1, 9, 2, 9, 10, 2, 0, 3, 4, 
	// 0xa2
	10, 2, 0, 10, 0, 9, 9, 0, 5, 
	// 0xa3
	5, 9, 4, 9, 10, 4, 10, 2, 4, 2, 3, 4, 
	// 0xa4
	9, 10, 1, 1, 10, 2, 8, 4, 11, 
	// 0xa5
	11, 8, 3, 3, 8, 0, 2, 9, 10, 2, 1, 9, 
	// 0xa6
	5, 2, 0, 5, 9, 2, 9, 10, 2, 4, 11, 8, 
	// 0xa7
	5, 9, 10, 5, 10, 2, 5, 2, 3, 5, 3, 8, 8, 3, 11, 
	// 0xa8
	8, 10, 2, 8, 2, 5, 5, 2, 1, 
	// 0xa9
	1, 10, 2, 1, 5, 10, 5, 8, 10, 3, 4, 0, 
	// 0xaa
	10, 2, 8, 2, 0, 8, 
	// 0xab
	2, 3, 10, 3, 4, 10, 4, 8, 10, 
	// 0xac
	10, 2, 11, 11, 2, 4, 4, 2, 5, 5, 2, 1, 
	// 0xad
	5, 0, 3, 5, 3, 11, 5, 11, 10, 5, 10, 1, 1, 10, 2, 
	// 0xae
	0, 4, 2, 4, 11, 2, 11, 10, 2, 
	// 0xaf
	10, 2, 11, 2, 3, 11, 
	// 0xb0
	9, 3, 1, 9, 10, 3, 10, 7, 3, 
	// 0xb1
	1, 9, 0, 0, 9, 4, 4, 9, 7, 7, 9, 10, 
	// 0xb2
	5, 9, 0, 9, 10, 0, 0, 10, 3, 10, 7, 3, 
	// 0xb3
	5, 9, 4, 9, 10, 4, 10, 7, 4, 
	// 0xb4
	10, 1, 9, 10, 7, 1, 7, 3, 1, 8, 4, 11, 
	// 0xb5
	7, 9, 10, 7, 1, 9, 7, 0, 1, 7, 11, 0, 11, 8, 0, 
	// 0xb6
	10, 7, 9, 7, 3, 9, 3, 5, 9, 3, 0, 5, 11, 8, 4, 
	// 0xb7
	10, 7, 9, 7, 5, 9, 7, 11, 5, 11, 8, 5, 
	// 0xb8
	1, 5, 3, 5, 8, 3, 8, 10, 3, 10, 7, 3, 
	// 0xb9
	1, 5, 8, 1, 8, 10, 1, 10, 7, 1, 7, 0, 0, 7, 4, 
	// 0xba
	10, 7, 8, 7, 3, 8, 3, 0, 8, 
	// 0xbb
	8, 10, 4, 10, 7, 4, 
	// 0xbc
	10, 4, 11, 10, 5, 4, 10, 1, 5, 10, 7, 1, 7, 3, 1, 
	// 0xbd
	10, 7, 11, 5, 0, 1, 
	// 0xbe
	11, 10, 4, 10, 0, 4, 10, 7, 0, 7, 3, 0, 
	// 0xbf
	10, 7, 11, 
	// 0xc0
	9, 11, 6, 11, 7, 6, 
	// 0xc1
	11, 7, 9, 9, 7, 6, 4, 0, 3, 
	// 0xc2
	9, 11, 6, 11, 7, 6, 5, 1, 0, 
	// 0xc3
	5, 1, 4, 4, 1, 3, 11, 6, 9, 11, 7, 6, 
	// 0xc4
	4, 7, 6, 4, 6, 8, 8, 6, 9, 
	// 0xc5
	7, 6, 3, 3, 6, 0, 0, 6, 8, 8, 6, 9, 
	// 0xc6
	9, 7, 6, 9, 8, 7, 8, 4, 7, 1, 0, 5, 
	// 0xc7
	8, 5, 1, 8, 1, 3, 8, 3, 7, 8, 7, 9, 9, 7, 6, 
	// 0xc8
	5, 7, 6, 5, 8, 7, 8, 11, 7, 
	// 0xc9
	8, 6, 5, 8, 11, 6, 11, 7, 6, 0, 3, 4, 
	// 0xca
	6, 1, 7, 1, 0, 7, 0, 8, 7, 8, 11, 7, 
	// 0xcb
	8, 3, 4, 8, 1, 3, 8, 6, 1, 8, 11, 6, 11, 7, 6, 
	// 0xcc
	5, 4, 6, 4, 7, 6, 
	// 0xcd
	5, 0, 6, 0, 3, 6, 3, 7, 6, 
	// 0xce
	6, 1, 7, 1, 0, 7, 0, 4, 7, 
	// 0xcf
	1, 3, 6, 3, 7, 6, 
	// 0xd0
	9, 11, 3, 9, 3, 6, 6, 3, 2, 
	// 0xd1
	2, 6, 0, 6, 9, 0, 9, 11, 0, 11, 4, 0, 
	// 0xd2
	6, 9, 11, 6, 11, 2, 2, 11, 3, 5, 1, 0, 
	// 0xd3
	2, 6, 9, 2, 9, 11, 2, 11, 4, 2, 4, 1, 1, 4, 5, 
	// 0xd4
	9, 8, 6, 8, 4, 6, 6, 4, 2, 4, 3, 2, 
	// 0xd5
	8, 0, 9, 9, 0, 6, 6, 0, 2, 
	// 0xd6
	8, 4, 9, 9, 4, 6, 6, 4, 3, 6, 3, 2, 5, 1, 0, 
	// 0xd7
	6, 9, 2, 2, 9, 8, 2, 8, 1, 1, 8, 5, 
	// 0xd8
	6, 5, 2, 2, 5, 3, 3, 5, 11, 11, 5, 8, 
	// 0xd9
	11, 5, 8, 11, 6, 5, 11, 2, 6, 11, 4, 2, 4, 0, 2, 
	// 0xda
	6, 1, 0, 6, 0, 8, 6, 8, 11, 6, 11, 2, 2, 11, 3, 
	// 0xdb
	8, 11, 4, 1, 2, 6, 
	// 0xdc
	4, 3, 5, 3, 2, 5, 2, 6, 5, 
	// 0xdd
	2, 6, 0, 0, 6, 5, 
	// 0xde
	0, 4, 1, 4, 6, 1, 4, 3, 6, 3, 2, 6, 
	// 0xdf
	1, 2, 6, 
	// 0xe0
	1, 9, 11, 1, 11, 2, 2, 11, 7, 
	// 0xe1
	7, 9, 11, 7, 2, 9, 2, 1, 9, 4, 0, 3, 
	// 0xe2
	2, 0, 7, 7, 0, 11, 11, 0, 9, 9, 0, 5, 
	// 0xe3
	2, 11, 7, 2, 9, 11, 2, 5, 9, 2, 3, 5, 3, 4, 5, 
	// 0xe4
	9, 8, 1, 8, 4, 1, 4, 7, 1, 7, 2, 1, 
	// 0xe5
	7, 0, 3, 7, 8, 0, 7, 9, 8, 7, 2, 9, 2, 1, 9, 
	// 0xe6
	9, 8, 4, 9, 4, 7, 9, 7, 2, 9, 2, 5, 5, 2, 0, 
	// 0xe7
	2, 3, 7, 9, 8, 5, 
	// 0xe8
	1, 5, 2, 5, 8, 2, 2, 8, 7, 8, 11, 7, 
	// 0xe9
	8, 11, 5, 11, 7, 5, 7, 1, 5, 7, 2, 1, 4, 0, 3, 
	// 0xea
	8, 11, 0, 11, 7, 0, 7, 2, 0, 
	// 0xeb
	4, 8, 3, 8, 2, 3, 8, 11, 2, 11, 7, 2, 
	// 0xec
	5, 4, 1, 1, 4, 2, 2, 4, 7, 
	// 0xed
	1, 5, 2, 5, 7, 2, 5, 0, 7, 0, 3, 7, 
	// 0xee
	2, 0, 7, 0, 4, 7, 
	// 0xef
	2, 3, 7, 
	// 0xf0
	9, 11, 1, 11, 3, 1, 
	// 0xf1
	11, 4, 9, 4, 0, 9, 0, 1, 9, 
	// 0xf2
	9, 11, 5, 5, 11, 0, 0, 11, 3, 
	// 0xf3
	9, 11, 5, 11, 4, 5, 
	// 0xf4
	9, 8, 1, 8, 4, 1, 4, 3, 1, 
	// 0xf5
	0, 1, 8, 8, 1, 9, 
	// 0xf6
	5, 9, 0, 9, 3, 0, 9, 8, 3, 8, 4, 3, 
	// 0xf7
	9, 8, 5, 
	// 0xf8
	1, 5, 3, 5, 8, 3, 8, 11, 3, 
	// 0xf9
	8, 11, 5, 11, 1, 5, 11, 4, 1, 4, 0, 1, 
	// 0xfa
	0, 8, 3, 8, 11, 3, 
	// 0xfb
	8, 11, 4, 
	// 0xfc
	5, 4, 1, 4, 3, 1, 
	// 0xfd
	5, 0, 1, 
	// 0xfe
	0, 4, 3, 
	// 0xff
	
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
			//Should not be called
			return vec3(pos_infinity, pos_infinity, pos_infinity);
	}
}

float calc_edge_weight(float threshold, float p0_val, float p1_val) {
	return (threshold - p0_val) / (p1_val - p0_val);
//	return .5;
}

void main() {
	ivec3 pos = ivec3(gl_GlobalInvocationID.xyz);

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
	
//cube_index = 1;
	
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

	int read_pos = tessellation_offsets[cube_index];
	int num_points = tessellation_offsets[cube_index + 1] - read_pos;
	int write_pos = atomicAdd(params_rw.num_vertices, num_points * 3);
	
	for (int i = 0; i < num_points; ++i) {
		vec3 point = get_edge_point(tessellation_table[read_pos + i], edge_weights);
	
		vec3 local_point_pos = (point + pos) / params.grid_size;
//		vec3 grad = normalize(texture(gradient_tex, local_point_pos).rgb);
		vec3 normal = -normalize(texture(gradient_tex, local_point_pos).rgb);
		
		params_w_point.values[write_pos + i * 3] = local_point_pos.x;
		params_w_point.values[write_pos + i * 3 + 1] = local_point_pos.y;
		params_w_point.values[write_pos + i * 3 + 2] = local_point_pos.z;

		params_w_normal.values[write_pos + i * 3] = normal.x;
		params_w_normal.values[write_pos + i * 3 + 1] = normal.y;
		params_w_normal.values[write_pos + i * 3 + 2] = normal.z;

	}
	
	
	/*
	//TEST
	{	
		int cube_index = 1;
		int read_pos = tessellation_offsets[cube_index];
		int num_points = tessellation_offsets[cube_index + 1] - read_pos;
		int write_pos = atomicAdd(params_rw.num_vertices, num_points * 2);
		
		for (int i = 0; i < num_points; ++i) {
			imageStore(result_points, write_pos + i * 2, vec4(pos, 1.0));
			imageStore(result_points, write_pos + i * 2 + 1, vec4(pos, 0.0));
		}
	}
	*/
}
