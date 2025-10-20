extends Node

# Crea y muestra un MeshInstance3D con un material
func mostrar_malla(malla: ArrayMesh, color: Color, sombreado: String, padre: Node3D):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color

	match sombreado:
		"phong", "pixel":
			mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
		"gouraud", "vertex":
			mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX

	var inst = MeshInstance3D.new()
	inst.mesh = malla
	inst.material_override = mat
	padre.add_child(inst)
	
	return inst
