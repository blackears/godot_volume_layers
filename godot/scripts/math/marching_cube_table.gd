extends Node
class_name MarchingCubeTable

static var meshes = [
	[ # 00 (root 00, rev winding false)
	],
	[ # 01 (root 01, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
	],
	[ # 02 (root 01, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
	],
	[ # 03 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, 
	],
	[ # 04 (root 01, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
	],
	[ # 05 (root 03, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
	],
	[ # 06 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, 
	],
	[ # 07 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
	],
	[ # 08 (root 01, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
	],
	[ # 09 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
	],
	[ # 0a (root 03, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, 
	],
	[ # 0b (root 07, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, 
	],
	[ # 0c (root 03, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, 
	],
	[ # 0d (root 07, rev winding false)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
	],
	[ # 0e (root 07, rev winding true)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, 
	],
	[ # 0f (root 0f, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, 
	],
	[ # 10 (root 01, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
	],
	[ # 11 (root 03, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
	],
	[ # 12 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
	],
	[ # 13 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
	],
	[ # 14 (root 06, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
	],
	[ # 15 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
	],
	[ # 16 (root 16, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, 
	],
	[ # 17 (root 17, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, 
	],
	[ # 18 (root 18, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, 
	],
	[ # 19 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, 
	],
	[ # 1a (root 19, rev winding true)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, 
	],
	[ # 1b (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, 
	],
	[ # 1c (root 19, rev winding true)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, 
	],
	[ # 1d (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, 
	],
	[ # 1e (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
	],
	[ # 1f (root 07, rev winding false)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, 
	],
	[ # 20 (root 01, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
	],
	[ # 21 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, 
	],
	[ # 22 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, 
	],
	[ # 23 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, 
	],
	[ # 24 (root 18, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
	],
	[ # 25 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
	],
	[ # 26 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, 
	],
	[ # 27 (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, 
	],
	[ # 28 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, 
	],
	[ # 29 (root 16, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
	],
	[ # 2a (root 07, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, 
	],
	[ # 2b (root 17, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
	],
	[ # 2c (root 19, rev winding false)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, 
	],
	[ # 2d (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
	],
	[ # 2e (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
	],
	[ # 2f (root 07, rev winding true)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
	],
	[ # 30 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, 
	],
	[ # 31 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
	],
	[ # 32 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, 
	],
	[ # 33 (root 0f, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, 
	],
	[ # 34 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, 
	],
	[ # 35 (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, 
	],
	[ # 36 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, 
	],
	[ # 37 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, 
	],
	[ # 38 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, 
	],
	[ # 39 (root 1e, rev winding true)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
	],
	[ # 3a (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
	],
	[ # 3b (root 07, rev winding true)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
	],
	[ # 3c (root 3c, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, 
	],
	[ # 3d (root 19, rev winding true)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.A, 
	],
	[ # 3e (root 19, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.A, 
	],
	[ # 3f (root 03, rev winding false)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.A, 
	],
	[ # 40 (root 01, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
	],
	[ # 41 (root 06, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
	],
	[ # 42 (root 18, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
	],
	[ # 43 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, 
	],
	[ # 44 (root 03, rev winding true)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
	],
	[ # 45 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
	],
	[ # 46 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
	],
	[ # 47 (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, 
	],
	[ # 48 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, 
	],
	[ # 49 (root 16, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, 
	],
	[ # 4a (root 19, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, 
	],
	[ # 4b (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, 
	],
	[ # 4c (root 07, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
	],
	[ # 4d (root 17, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, 
	],
	[ # 4e (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, 
	],
	[ # 4f (root 07, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, 
	],
	[ # 50 (root 03, rev winding true)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
	],
	[ # 51 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
	],
	[ # 52 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, 
	],
	[ # 53 (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, 
	],
	[ # 54 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
	],
	[ # 55 (root 0f, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, 
	],
	[ # 56 (root 1e, rev winding true)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
	],
	[ # 57 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, 
	],
	[ # 58 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
	],
	[ # 59 (root 1e, rev winding true)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
	],
	[ # 5a (root 3c, rev winding false)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
	],
	[ # 5b (root 19, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, 
	],
	[ # 5c (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, 
	],
	[ # 5d (root 07, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, 
	],
	[ # 5e (root 19, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.L, 
	],
	[ # 5f (root 03, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.C, 
	],
	[ # 60 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
	],
	[ # 61 (root 16, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, 
	],
	[ # 62 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, 
	],
	[ # 63 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
	],
	[ # 64 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, 
	],
	[ # 65 (root 1e, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
	],
	[ # 66 (root 3c, rev winding false)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
	],
	[ # 67 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, 
	],
	[ # 68 (root 16, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, 
	],
	[ # 69 (root 69, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, 
	],
	[ # 6a (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, 
	],
	[ # 6b (root 16, rev winding true)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, 
	],
	[ # 6c (root 1e, rev winding true)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
	],
	[ # 6d (root 16, rev winding true)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
	],
	[ # 6e (root 19, rev winding true)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
	],
	[ # 6f (root 06, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
	],
	[ # 70 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
	],
	[ # 71 (root 17, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, 
	],
	[ # 72 (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, 
	],
	[ # 73 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, 
	],
	[ # 74 (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, 
	],
	[ # 75 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, 
	],
	[ # 76 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, 
	],
	[ # 77 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.G, 
	],
	[ # 78 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
	],
	[ # 79 (root 16, rev winding true)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
	],
	[ # 7a (root 19, rev winding true)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, 
	],
	[ # 7b (root 06, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, 
	],
	[ # 7c (root 19, rev winding true)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, 
	],
	[ # 7d (root 06, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.D, 
	],
	[ # 7e (root 18, rev winding true)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, 
	],
	[ # 7f (root 01, rev winding true)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.C, 
	],
	[ # 80 (root 01, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
	],
	[ # 81 (root 18, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, 
	],
	[ # 82 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, 
	],
	[ # 83 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, 
	],
	[ # 84 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
	],
	[ # 85 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, 
	],
	[ # 86 (root 16, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
	],
	[ # 87 (root 1e, rev winding true)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
	],
	[ # 88 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, 
	],
	[ # 89 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, 
	],
	[ # 8a (root 07, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, 
	],
	[ # 8b (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
	],
	[ # 8c (root 07, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.D, 
	],
	[ # 8d (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, 
	],
	[ # 8e (root 17, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
	],
	[ # 8f (root 07, rev winding true)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
	],
	[ # 90 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, 
	],
	[ # 91 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
	],
	[ # 92 (root 16, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, 
	],
	[ # 93 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
	],
	[ # 94 (root 16, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, 
	],
	[ # 95 (root 1e, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
	],
	[ # 96 (root 69, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, 
	],
	[ # 97 (root 16, rev winding true)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
	],
	[ # 98 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, 
	],
	[ # 99 (root 3c, rev winding false)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
	],
	[ # 9a (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, 
	],
	[ # 9b (root 19, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, 
	],
	[ # 9c (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, 
	],
	[ # 9d (root 19, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, 
	],
	[ # 9e (root 16, rev winding true)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, 
	],
	[ # 9f (root 06, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, 
	],
	[ # a0 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, 
	],
	[ # a1 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, 
	],
	[ # a2 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, 
	],
	[ # a3 (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
	],
	[ # a4 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, 
	],
	[ # a5 (root 3c, rev winding false)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
	],
	[ # a6 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, 
	],
	[ # a7 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
	],
	[ # a8 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, 
	],
	[ # a9 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, 
	],
	[ # aa (root 0f, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, 
	],
	[ # ab (root 07, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
	],
	[ # ac (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
	],
	[ # ad (root 19, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, 
	],
	[ # ae (root 07, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
	],
	[ # af (root 03, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.I, 
	],
	[ # b0 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, 
	],
	[ # b1 (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, 
	],
	[ # b2 (root 17, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
	],
	[ # b3 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
	],
	[ # b4 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
	],
	[ # b5 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, 
	],
	[ # b6 (root 16, rev winding true)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, 
	],
	[ # b7 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
	],
	[ # b8 (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
	],
	[ # b9 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
	],
	[ # ba (root 07, rev winding false)
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
	],
	[ # bb (root 03, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.E, 
	],
	[ # bc (root 19, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, 
	],
	[ # bd (root 18, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, 
	],
	[ # be (root 06, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, 
	],
	[ # bf (root 01, rev winding true)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.D, CubeSymmetries.CubeEdge.A, 
	],
	[ # c0 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, 
	],
	[ # c1 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, 
	],
	[ # c2 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, 
	],
	[ # c3 (root 3c, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, 
	],
	[ # c4 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
	],
	[ # c5 (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, 
	],
	[ # c6 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
	],
	[ # c7 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.E, 
	],
	[ # c8 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, 
	],
	[ # c9 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
	],
	[ # ca (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
	],
	[ # cb (root 19, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.E, 
	],
	[ # cc (root 0f, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, 
	],
	[ # cd (root 07, rev winding false)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, 
	],
	[ # ce (root 07, rev winding true)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
	],
	[ # cf (root 03, rev winding false)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.E, 
	],
	[ # d0 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
	],
	[ # d1 (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, 
	],
	[ # d2 (root 1e, rev winding true)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
	],
	[ # d3 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, 
	],
	[ # d4 (root 17, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, 
	],
	[ # d5 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, 
	],
	[ # d6 (root 16, rev winding true)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
	],
	[ # d7 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, 
	],
	[ # d8 (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, 
	],
	[ # d9 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.J, 
	],
	[ # da (root 19, rev winding true)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
	],
	[ # db (root 18, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, 
	],
	[ # dc (root 07, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.H, CubeSymmetries.CubeEdge.L, 
	],
	[ # dd (root 03, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.H, 
	],
	[ # de (root 06, rev winding false)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
	],
	[ # df (root 01, rev winding true)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.H, 
	],
	[ # e0 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.L, 
	],
	[ # e1 (root 1e, rev winding false)
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, 
	],
	[ # e2 (root 1b, rev winding true)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
	],
	[ # e3 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, 
	],
	[ # e4 (root 1b, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, 
	],
	[ # e5 (root 19, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, 
	],
	[ # e6 (root 19, rev winding true)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, 
	],
	[ # e7 (root 18, rev winding true)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, 
	],
	[ # e8 (root 17, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
	],
	[ # e9 (root 16, rev winding true)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, 
	],
	[ # ea (root 07, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
	],
	[ # eb (root 06, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, 
	],
	[ # ec (root 07, rev winding true)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.E, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
	],
	[ # ed (root 06, rev winding false)
		CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, 
	],
	[ # ee (root 03, rev winding false)
		CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.E, CubeSymmetries.CubeEdge.F, 
	],
	[ # ef (root 01, rev winding true)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.L, CubeSymmetries.CubeEdge.E, 
	],
	[ # f0 (root 0f, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, 
	],
	[ # f1 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.J, 
	],
	[ # f2 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
	],
	[ # f3 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.A, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.F, 
	],
	[ # f4 (root 07, rev winding false)
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, 
	],
	[ # f5 (root 03, rev winding false)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.K, 
	],
	[ # f6 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, 
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, 
	],
	[ # f7 (root 01, rev winding true)
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.C, CubeSymmetries.CubeEdge.G, 
	],
	[ # f8 (root 07, rev winding true)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, 
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.K, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
	],
	[ # f9 (root 06, rev winding false)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
	],
	[ # fa (root 03, rev winding false)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.B, 
		CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.I, CubeSymmetries.CubeEdge.A, 
	],
	[ # fb (root 01, rev winding true)
		CubeSymmetries.CubeEdge.A, CubeSymmetries.CubeEdge.B, CubeSymmetries.CubeEdge.F, 
	],
	[ # fc (root 03, rev winding false)
		CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.F, 
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.K, CubeSymmetries.CubeEdge.I, 
	],
	[ # fd (root 01, rev winding true)
		CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.G, CubeSymmetries.CubeEdge.K, 
	],
	[ # fe (root 01, rev winding true)
		CubeSymmetries.CubeEdge.F, CubeSymmetries.CubeEdge.J, CubeSymmetries.CubeEdge.I, 
	],
	[ # ff (root 00, rev winding true)
	],
]
