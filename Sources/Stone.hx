package;

import kha.Color;
import kha.math.FastMatrix4;
import kha.math.Random;
import kha.math.Vector2;
import kha.math.Vector4;
import khajak.RenderObject;

class Stone extends RenderObject {
	private var position: Vector4;
	
	public function new(position: Vector4) {
		super(Meshes.Stone, Color.fromBytes(Random.getIn(64, 128), Random.getIn(64, 128), Random.getIn(64, 128)), kha.Assets.images.black);
		this.position = position;
		model = FastMatrix4.translation(position.x, position.y, position.z).multmat(FastMatrix4.rotation(2 * Math.PI * Random.getFloat(), 2 * Math.PI * Random.getFloat(), 2 * Math.PI * Random.getFloat()));
	}
	
	public function update(): Void {
		var x = model._30;
		var z = model._32;
		model._31 = Water.map(new Vector2(x, z)) / 2.0 + 0.5;
	}
}
