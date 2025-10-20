extends Node3D

# pivote.gd
@export var incremento := 0.02 # velocidad angular en rad/s
@export var trasladar := 5.0 # posición inicial en z de la cámara
@export var incremento2 := 0.05 # velocidad del zoom de la cámara
@export var umbral := 0.02 # evita valores negativos del zoom

var angulo := 0.0 # rotación en X
var angulo2 := 0.0 # rotación en y
var acciones := ["orbitar_izquierda", "orbitar_derecha", "orbitar_abajo", "orbitar_arriba", "alejar", "acercar"]

func _ready():
	var delta = 0
	_process(delta)

func _process(delta):
	# se inicializa la rotación y la traslación de la cámara
	rotation=Vector3(0,0,0.0)
	position=Vector3(0,0,0.0)
	
	for action in acciones:
		if Input.is_action_pressed(action):
			match action: # match equivale a un switch case
				# para rotar en Y
				"orbitar_izquierda": angulo2 -= incremento
				"orbitar_derecha": angulo2 += incremento
				# para rotar en X
				"orbitar_abajo": angulo -= incremento
				"orbitar_arriba": angulo += incremento
				"alejar": trasladar += incremento2
				"acercar":
					trasladar -= incremento2
					if trasladar < umbral : trasladar = umbral
	rotate_y(angulo2)
	rotate_x(angulo)
	translate(Vector3(0, 0, trasladar)) # zoom trasladando la cámara
