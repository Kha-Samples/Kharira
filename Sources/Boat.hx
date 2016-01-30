package;

import kha.math.FastMatrix4;
import kha.math.Vector3;
import khajak.RenderObject;

class Boat extends RenderObject {
	
	public static var IMPULSE_DAMPING = 0.5;
	public static var ROTATING_DAMPING = 0.5;
	
	public var position(default, null): Vector3;
	private var impulse: Vector3;
	private var rotation: Vector3;
	
	public function new(position: Vector3) {
		super(Meshes.Cube, kha.Color.Black, kha.Assets.images.cube);
		
		this.position = position;
		impulse = new Vector3();
		rotation = new Vector3();
	}
	
	public function addImpulse(strenght: Float, left: Bool) {
		impulse = impulse.add(new Vector3(0, 0, strenght));
	}
	
	public function update(deltaTime: Float) {
		impulse.length = Math.max(impulse.length * (1 - IMPULSE_DAMPING * deltaTime), 0);
		rotation.length = Math.max(rotation.length * (1 - ROTATING_DAMPING * deltaTime), 0);
		
		position = position.add(impulse);
		
		model = FastMatrix4.translation(position.x, position.y, position.z);
	}
}