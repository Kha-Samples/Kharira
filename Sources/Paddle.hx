package;

import kha.Color;
import kha.math.FastMatrix4;
import kha.math.Random;
import kha.math.Vector4;
import khajak.RenderObject;

class Paddle extends RenderObject {
	
	public function new(color: Color) {
		super(Meshes.Paddle, color, kha.Assets.images.black);
	}
}