extends Node3D

#Funcion para cerar una malla con colores distintos para cada cara pero sin iluminar
static func malla_coloreada(vertices: Array, caras: Array, color: Array, material: StandardMaterial3D) -> ArrayMesh:
	var st = SurfaceTool.new() #SurfaceTool para construir malla 
	# Sin iluminacion
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in range(caras.size()):
		st.set_color(color[i])
		st.add_vertex(vertices[caras[i][0]])
		st.add_vertex(vertices[caras[i][1]])
		st.add_vertex(vertices[caras[i][2]])


	st.generate_normals()
	return st.commit()  #Generamos la malla final y la devolvemos

static func malla_iluminacion_plana(vertices: Array, caras: Array, color: Color, material: StandardMaterial3D) -> ArrayMesh:
	var st = SurfaceTool.new()
	
	# Material para iluminación plana
	material = StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = false  # Usamos iluminación
	material.cull_mode = BaseMaterial3D.CULL_BACK
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(caras.size()):
		st.add_vertex(vertices[caras[i][0]])
		st.add_vertex(vertices[caras[i][1]])
		st.add_vertex(vertices[caras[i][2]])
	
	st.generate_normals()
	return st.commit()


static func malla_sombra_suave(vertices: Array, caras: Array, color: Color, material: StandardMaterial3D) -> ArrayMesh:
	var st = SurfaceTool.new()
	
	# Material con iluminación
	material = StandardMaterial3D.new()
	material.albedo_color = color
	material.vertex_color_use_as_albedo = false
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for cara in caras:
		# Normal de la cara
		var n = ((vertices[cara[1]] - vertices[cara[0]]).cross(vertices[cara[2]] - vertices[cara[0]])).normalized()
		st.set_normal(n)
		st.add_vertex(vertices[cara[0]])
		st.add_vertex(vertices[cara[1]])
		st.add_vertex(vertices[cara[2]])
	
	return st.commit()
