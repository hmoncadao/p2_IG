extends Node3D

@export var altura := 1.5
@export var radio := 0.5
@export var lados := 20
@export var color := Color(1.0, 0.4, 0.1)

var colores := [
	Color(1, 0, 0), # rojo
	Color(0, 1, 0), # verde
	Color(0, 0, 1), # azul
	Color(1, 1, 0), # amarillo
	Color(1, 0, 1), # magenta
	Color(0, 1, 1)  # cian
]

var mesh_instance : MeshInstance3D
var mesh : ArrayMesh

func _ready():
	# Crear la malla del cono
	mesh = ArrayMesh.new()
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var vertices: Array[Vector3] = []
	for i in range(lados):
		var ang = i * TAU / lados
		vertices.append(Vector3(radio * cos(ang), 0, radio * sin(ang)))

	var pico = Vector3(0, altura, 0)
	var centro = Vector3(0, 0, 0)

	for i in range(lados):
		st.add_triangle_fan([vertices[i], vertices[(i + 1) % lados], pico])
	for i in range(lados):
		st.add_triangle_fan([centro, vertices[(i + 1) % lados], vertices[i]])

	st.generate_normals()
	st.commit(mesh)

	mesh_instance = Visualizador.mostrar_malla(mesh, color, "pixel", self)
	print("✅ Cono listo y visible.")

func _process(delta):
	if Input.is_action_just_pressed("mostrar_malla"):
		mostrar_malla()

func mostrar_malla():
	if mesh_instance == null:
		return

	# Determinar el modo actual y cambiarlo
	var nuevo_modo := "pixel"
	if mesh_instance.material_override.shading_mode == BaseMaterial3D.SHADING_MODE_PER_PIXEL:
		nuevo_modo = "vertex"
		print("Modo cambiado → Per Vertex (Gouraud)")
	else:
		nuevo_modo = "pixel"
		print("Modo cambiado → Per Pixel (Phong)")

	# Eliminar el nodo anterior para reemplazarlo
	mesh_instance.queue_free()

	# Crear un nuevo MeshInstance3D usando Visualizador
	mesh_instance = Visualizador.mostrar_malla(mesh, color, nuevo_modo, self)
