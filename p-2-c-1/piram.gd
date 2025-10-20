extends Node3D

@export var altura := 1.5
@export var lado := 1.0
@export var color := Color(1.0, 0.3, 0.3)

var mesh_instance : MeshInstance3D
var material : StandardMaterial3D

func _ready():
	var mesh := ArrayMesh.new()
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var h = altura / 2.0
	var l = lado / 2.0

	# Vértices
	var v = [
		Vector3(-l, 0, -l),
		Vector3(l, 0, -l),
		Vector3(l, 0, l),
		Vector3(-l, 0, l),
		Vector3(0, h, 0)
	]

	# Caras
	var caras = [
		[0,1,4],
		[1,2,4],
		[2,3,4],
		[3,0,4],
		[0,3,2],
		[0,2,1]
	]

	for cara in caras:
		for idx in cara:
			st.add_vertex(v[idx])

	st.generate_normals()
	st.commit(mesh)

	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh

	material = StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	mesh_instance.material_override = material

	add_child(mesh_instance)

	print("Pirámide lista. Pulsa 'S' para cambiar sombreado.")

func _process(delta):
	# Detecta acción definida en InputMap
	if Input.is_action_just_pressed("cambiar_sombreado"):
		_cambiar_sombreado()

func _cambiar_sombreado():
	if material == null:
		return

	if material.shading_mode == BaseMaterial3D.SHADING_MODE_PER_PIXEL:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
		print("Modo cambiado → Per Vertex (Gouraud)")
	else:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
		print("Modo cambiado → Per Pixel (Phong)")
