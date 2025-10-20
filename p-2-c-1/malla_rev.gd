extends Node3D

# Función global para generar malla por revolución
# profile: lista de puntos Vector3 en plano XZ
# sides: número de lados de la malla
# top_cap, bottom_cap: crear tapas superior e inferior
# vertices_out, triangles_out: arrays vacíos que serán llenados
func generate_revolution_mesh(profile: Array, sides: int, top_cap: bool, bottom_cap: bool, vertices_out: Array, triangles_out: Array) -> void:
	var m = profile.size()
	var angle_step = TAU / sides

	# Limpiar arrays antes de llenarlos
	vertices_out.clear()
	triangles_out.clear()

	# 1️⃣ Generar vértices rotados
	for j in range(sides):
		var angle = j * angle_step
		var cos_a = cos(angle)
		var sin_a = sin(angle)
		for p in profile:
			var x = p.x * cos_a + p.z * sin_a
			var z = -p.x * sin_a + p.z * cos_a
			vertices_out.append(Vector3(x, p.y, z))

	# 2️⃣ Crear triángulos laterales
	for j in range(sides):
		var next_j = (j + 1) % sides
		for i in range(m - 1):
			var a = j * m + i
			var b = next_j * m + i
			var c = next_j * m + i + 1
			var d = j * m + i + 1

			# Primer triángulo
			triangles_out.append(a)
			triangles_out.append(b)
			triangles_out.append(d)

			# Segundo triángulo
			triangles_out.append(d)
			triangles_out.append(b)
			triangles_out.append(c)

	# 3️⃣ Crear tapas
	var top_index = -1
	var bottom_index = -1

	if top_cap:
		vertices_out.append(Vector3(0, profile[-1].y, 0))
		top_index = vertices_out.size() - 1
	if bottom_cap:
		vertices_out.append(Vector3(0, profile[0].y, 0))
		bottom_index = vertices_out.size() - 1

	# Tapa superior
	if top_cap:
		for j in range(sides):
			var next_j = (j + 1) % sides
			triangles_out.append(top_index)
			triangles_out.append(next_j * m + (m - 1))
			triangles_out.append(j * m + (m - 1))

	# Tapa inferior
	if bottom_cap:
		for j in range(sides):
			var next_j = (j + 1) % sides
			triangles_out.append(bottom_index)
			triangles_out.append(j * m + 0)
			triangles_out.append(next_j * m + 0)
