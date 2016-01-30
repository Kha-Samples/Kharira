package;

import kha.Color;
import kha.math.FastMatrix4;
import kha.math.Random;
import kha.math.Vector4;
import khajak.RenderObject;

class Stone extends RenderObject {
	
	public function new(position: Vector4) {
		super(Meshes.Stone, Color.fromBytes(Random.getIn(64, 128), Random.getIn(64, 128), Random.getIn(64, 128)), kha.Assets.images.black);
		
		model = FastMatrix4.translation(position.x, position.y, position.z).multmat(FastMatrix4.rotation(2 * Math.PI * Random.getFloat(), 2 * Math.PI * Random.getFloat(), 2 * Math.PI * Random.getFloat()));
	}
}