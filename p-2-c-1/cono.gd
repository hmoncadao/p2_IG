extends Node3D

@export var altura: float = 3
@export var radio: float = 1.5
@export var lados: int = 10

# Variables globales
var cono = MeshInstance3D.new()
var material = StandardMaterial3D.new()
var mesh = ArrayMesh.new()
var visualizador = load("res://visualizador.gd")

var acciones := ["visualizador_A", "visualizador_B", "visualizador_C"]

# Arrays para vertices, caras y colores
var vertices = []
var caras = []
var colores = []
var albedo = Color(0.9, 0.4, 0.1, 1.0)

func _ready() -> void:
	var count = 0
	var px 
	var pz
	
	# Crear los vertices de la base
	while count < lados:
		px = radio * cos(count * 2 * PI / lados)
		pz = -radio * sin(count * 2 * PI / lados)
		vertices.append(Vector3(px, 0, pz))
		count += 1
		
	# Vértice superior del cono
	vertices.append(Vector3(0, altura, 0))
	var indice_superior = vertices.size() - 1
	
	count = 0
	# Caras laterales
	while count < lados:
		caras.append(Vector3i((count+1)%lados, count, indice_superior))
		count += 1
		
	# Vertice central de la base
	vertices.append(Vector3(0,0,0))
	var indice_central_base = vertices.size() - 1
	
	count = 0
	# Caras de la base
	while count < lados:
		caras.append(Vector3i(count, (count+1)%lados, indice_central_base))
		count += 1
	
	# Colores aleatorios por cara
	for j in range(caras.size()):
		colores.append(Color(randf(), randf(), randf()))
	
	# Material
	material.albedo_color = albedo
	
	# Crear la malla usando visualizador
	cono.mesh = visualizador.malla_coloreada(vertices, caras, colores, material)
	cono.material_override = material
	
	add_child(cono)
	
	var delta = 0

func _process(delta):
	if Input.is_action_just_pressed("visualizador_A"):
		cono.mesh = visualizador.malla_coloreada(vertices, caras, colores, material)
		cono.material_override = material
	elif Input.is_action_just_pressed("visualizador_B"):
		cono.mesh = visualizador.malla_iluminacion_plana(vertices, caras, albedo, material)
		cono.material_override = material
	elif Input.is_action_just_pressed("visualizador_C"):
		cono.mesh = visualizador.malla_sombra_suave(vertices, caras, albedo, material)
		cono.material_override = material
