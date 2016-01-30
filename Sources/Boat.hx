package;

import kha.math.Matrix4;
import kha.math.FastMatrix4;
import kha.math.Vector3;
import kha.math.Vector4;
import khajak.RenderObject;

class Boat extends RenderObject {
	
	public static var IMPULSE_DAMPING = 0.5;
	public static var IMPULSE_SPEED = 10.0;
	public static var ROTATING_DAMPING = 0.5;
	public static var ROTATING_SPEED = 1.0 * Math.PI;
	
	public var position(default, null): Vector4;
	public var direction(default, null): Vector4;
	
	private var angle: Float;
	private var impulse: Vector4;
	private var rotationDir: Float;
	private var rotationStrength: Float;
	
	public function new(position: Vector4) {
		super(Meshes.Boat, kha.Color.fromBytes(102, 51, 0), kha.Assets.images.black);
		
		this.position = position;
		angle = 0;
		direction = new Vector4(0, 0, 1);
		impulse = new Vector4();
		rotationDir = 0;
		rotationStrength = 0;
	}
	
	public function addImpulse(strenght: Float, left: Bool) {
		rotationStrength = strenght;
		rotationDir = (left ? -1 : 1) * rotationStrength;
		direction = Matrix4.rotationY(angle).multvec(new Vector4(0, 0, 1));
		impulse = impulse.add(direction.mult(strenght));
	}
	
	public function update(deltaTime: Float) {
		impulse.length = Math.max(impulse.length * (1 - IMPULSE_DAMPING * deltaTime), 0);
		rotationStrength =  Math.max(rotationStrength * (1 - ROTATING_DAMPING * deltaTime), 0);
		
		angle += rotationDir * rotationStrength * ROTATING_SPEED * deltaTime;
		position = position.add(impulse.mult(IMPULSE_SPEED * deltaTime));
		
		model = FastMatrix4.translation(position.x, position.y, position.z).multmat(FastMatrix4.rotationY(angle));
	}
}