package;

import khajak.Mesh;

class Meshes extends khajak.Meshes {
		
	static var cube: Mesh;
	public static var Cube(get, null): Mesh;
	static function get_Cube() {
		if (cube == null) {
			cube = Mesh.FromModel(kha.Assets.blobs.cube_obj.toString());
		}
		
		return cube;
	}
}