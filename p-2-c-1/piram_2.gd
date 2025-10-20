# cono.gd
extends Node3D # se crea en un Node3D

@export var altura: float = 1.0
@export var radio: float = 0.5
@export var lados: int = 10

# variables globales al script
var cono = MeshInstance3D.new()
var material = StandardMaterial3D.new()
var mesh = ArrayMesh.new()
var modo = load("res://modos_malla_2.gd")

# matrices de vértices y caras inicialmente vacías
var vertices = []
var caras = []
var colores = []
var albedo = Color(0.9, 0.4, 0.1, 1.0)

func _ready() -> void:
	var i = 0
	var px
	var pz

	# Vértices de la base
	while i < lados:
		px = radio * cos(i * 2 * PI / lados)
		pz = -radio * sin(i * 2 * PI / lados)
		vertices.append(Vector3(px, 0, pz))
		i += 1

	# Vértice superior (pico)
	var pico_index = vertices.size()
	vertices.append(Vector3(0, altura, 0))

	# Centro de la base
	var centro_index = vertices.size()
	vertices.append(Vector3(0, 0, 0))

	# Caras laterales (triángulos que conectan la base con el pico)
	for j in range(lados):
		caras.append(j)
		caras.append((j + 1) % lados)
		caras.append(pico_index)

	# Caras de la base (triángulos desde el centro hacia los vértices)
	for j in range(lados):
		caras.append(centro_index)
		caras.append((j + 1) % lados)
		caras.append(j)

	# Colores aleatorios por vértice
	for v in vertices:
		colores.append(Color(randf(), randf(), randf(), 1.0))

	# Normales aproximadas para iluminación
	var normales = []
	for v in vertices:
		normales.append((v - Vector3(0, altura/2, 0)).normalized())

	# Crear el mesh
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = caras
	arrays[Mesh.ARRAY_COLOR] = colores
	arrays[Mesh.ARRAY_NORMAL] = normales

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	# Configurar material
	material.albedo_color = albedo
	cono.mesh = mesh
	cono.material_override = material

	# Añadir a la escena
	add_child(cono)
