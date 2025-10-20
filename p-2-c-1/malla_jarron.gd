extends MeshInstance3D

# Nodo MeshInstance3D
var mesh_instance: MeshInstance3D

# Material para colorear la malla
var material: StandardMaterial3D

# Vértices y triángulos (inicialmente vacíos)
var vertices = []
var triangles = []

# Perfil 2D de ejemplo (jarrón)
var profile := [
	Vector3(0.5, 0, 0),
	Vector3(0.3, 0.5, 0),
	Vector3(0.2, 1.0, 0),
	Vector3(0, 1.5, 0)
]

func generate_revolution_mesh(profile: Array, sides: int, top_cap: bool = true, bottom_cap: bool = true) -> ArrayMesh:
	var vertices: Array = []
	var triangles: Array = []

	var m = profile.size()
	var angle_step = TAU / sides

	# Vértices rotados
	for j in range(sides):
		var angle = j * angle_step
		var cos_a = cos(angle)
		var sin_a = sin(angle)
		for p in profile:
			var x = p.x * cos_a + p.z * sin_a
			var z = -p.x * sin_a + p.z * cos_a
			vertices.append(Vector3(x, p.y, z))

	# Triángulos laterales
	for j in range(sides):
		var next_j = (j + 1) % sides
		for i in range(m - 1):
			var a = j * m + i
			var b = next_j * m + i
			var c = next_j * m + i + 1
			var d = j * m + i + 1

			triangles.append(a)
			triangles.append(b)
			triangles.append(d)

			triangles.append(d)
			triangles.append(b)
			triangles.append(c)

	# Tapas
	var top_index = -1
	var bottom_index = -1

	if top_cap:
		vertices.append(Vector3(0, profile[-1].y, 0))
		top_index = vertices.size() - 1
	if bottom_cap:
		vertices.append(Vector3(0, profile[0].y, 0))
		bottom_index = vertices.size() - 1

	if top_cap:
		for j in range(sides):
			var next_j = (j + 1) % sides
			triangles.append(top_index)
			triangles.append(next_j * m + (m - 1))
			triangles.append(j * m + (m - 1))

	if bottom_cap:
		for j in range(sides):
			var next_j = (j + 1) % sides
			triangles.append(bottom_index)
			triangles.append(j * m + 0)
			triangles.append(next_j * m + 0)

	# Crear ArrayMesh
	var mesh := ArrayMesh.new()
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = triangles

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh

func _ready() -> void:
	# Crear nodo MeshInstance3D si no lo has creado en el editor
	mesh_instance = $MeshInstance3D

	# Crear y asignar material
	material = StandardMaterial3D.new()
	material.albedo_color = Color(0.9, 0.4, 0.1)
	mesh_instance.material_override = material

	# Generar malla con el perfil definido
	mesh_instance.mesh = generate_revolution_mesh(profile, 32, true, true)
