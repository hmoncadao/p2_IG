extends Node3D

# Mostrar un MeshInstance3D con diferentes modos de sombreado y opcionalmente colores por cara
# modo: "phong"/"pixel", "gouraud"/"vertex", "flat"
# random_colors: si es true, asigna colores distintos por cara
func mostrar_malla(malla: ArrayMesh, color: Color, modo: String, padre: Node3D, random_colors: bool = false) -> MeshInstance3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	
	match modo:
		"phong", "pixel":
			mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
			mat.flags_use_flat_shading = false
		"gouraud", "vertex":
			mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
			mat.flags_use_flat_shading = false
		"flat":
			mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
			mat.flags_use_flat_shading = true
	
	# Si se quieren colores distintos por cara
	if random_colors:
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		
		for s in range(malla.get_surface_count()):
			var arrays = malla.surface_get_arrays(s)
			var verts = arrays[Mesh.ARRAY_VERTEX]
			var indices = arrays[Mesh.ARRAY_INDEX]
			
			for i in range(0, indices.size(), 3):
				var c = Color(randf(), randf(), randf(), 1.0)
				for j in range(3):
					var vi = indices[i + j]
					st.add_color(c)
					st.add_vertex(verts[vi])
		
		malla = st.commit()
	
	var inst = MeshInstance3D.new()
	inst.mesh = malla
	inst.material_override = mat
	padre.add_child(inst)
	
	return inst
