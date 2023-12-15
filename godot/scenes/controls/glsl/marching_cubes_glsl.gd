@tool
extends Node3D
class_name MarchingCubesGlsl

@export_file("*.zip") var image_file:String:
	get:
		return image_file
	set(value):
		if value == image_file:
			return
		image_file = value
		flag_reload_image_file = true
		flag_update_mesh = true
		
@export_range(0, 1) var threshold:float = .5:
	get:
		return threshold
	set(value):
		if value == threshold:
			return
		threshold = value
		flag_update_mesh = true


@export_range(0, 1) var cube_resolution:float = .7:
	get:
		return cube_resolution
	set(value):
		if value == cube_resolution:
			return
		cube_resolution = value
		flag_update_mesh = true
		
var flag_reload_image_file:bool = false
var flag_update_mesh:bool = false
		
var density_tex_rid:RID
var grad_tex_rid:RID
var mesh_size_base:Vector3i

var rd:RenderingDevice


func reload_image():
	if !FileAccess.file_exists(image_file):
		return
	
	var ar:ZippedImageArchive_RF_3D = ZippedImageArchive_RF_3D.new()
	ar.zip_file = image_file
	
	#var rd:RenderingDevice = RenderingServer.create_local_rendering_device()
	var grad_gen:SobelGradientGenerator = SobelGradientGenerator.new(rd)
	var img_size:Vector3i = ar.get_size()
	var image_list:Array[Image] = ar.get_image_list().duplicate()
	var grad_image_list:Array[Image] = grad_gen.calculate_gradient_from_image_stack(image_list)

	var glsl_util:GLSLUtil = GLSLUtil.new(rd)
	density_tex_rid = glsl_util.create_texture_image_from_image_stack(image_list, RenderingDevice.DATA_FORMAT_R32_SFLOAT, true)
	grad_tex_rid = glsl_util.create_texture_image_from_image_stack(grad_image_list, RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT, true)
	
	mesh_size_base = Vector3i(image_list[0].get_width(), \
		image_list[0].get_height(), image_list.size())
		
	var min_dim:float = min(mesh_size_base.x, mesh_size_base.y, mesh_size_base.z)

	var xform:Transform3D = Transform3D(Basis.from_scale(Vector3(mesh_size_base / min_dim)))
	xform = xform.translated_local(Vector3(-.5, -.5, -.5))
	%mesh.transform = xform

func build_mesh():
	
	var cube_gen:MarchingCubesGeneratorGLSLVariable = MarchingCubesGeneratorGLSLVariable.new(rd)

	var start_time_msec = Time.get_ticks_msec()
	#var mesh_size_base:Vector3i = Vector3i(image_list[0].get_width(), \
		#image_list[0].get_height(), image_list.size())
	var mipmap_sizes:Array[Vector3i] = GLSLUtil.calc_mipmap_sizes(mesh_size_base)
	var mipmap_level:float = mipmap_sizes.size() * (1 - cube_resolution)
	var mesh_size:Vector3i = mipmap_sizes[int(mipmap_level)]
	

	var mesh:ArrayMesh = cube_gen.generate_mesh(mesh_size, .5, int(mipmap_level), \
		density_tex_rid, grad_tex_rid)
	var end_time_msec = Time.get_ticks_msec()

	%mesh.mesh = mesh
	print("time delta msec ", (end_time_msec - start_time_msec))
	#var dens_tex_rid:RID = cube_gen.create_texture_image_from_image_stack(image_list, true)
	
	#await %mesh_viewer.updated
	#%mesh_viewer.export_gltf()
	
	pass # Replace with function body.
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	rd = RenderingServer.create_local_rendering_device()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flag_reload_image_file:
		reload_image()
		flag_reload_image_file = false
		
	if flag_update_mesh:
		build_mesh()
		flag_update_mesh = false
	pass
