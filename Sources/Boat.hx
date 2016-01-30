package;

import kha.Color;
import kha.math.Matrix4;
import kha.math.FastMatrix4;
import kha.math.Vector3;
import kha.math.Vector4;
import khajak.RenderObject;

class Boat extends RenderObject {
	
	public static var IMPULSE_DAMPING = 0.5;
	public static var IMPULSE_SPEED = 7.5;
	public static var ROTATING_DAMPING = 0.5;
	public static var ROTATING_SPEED = 0.25 * Math.PI;
	
	public var position(default, null): Vector4;
	public var direction(default, null): Vector4;
	
	private var angle: Float;
	private var impulse: Vector4;
	private var rotationDir: Float;
	private var rotationStrength: Float;
	private var startingPosition: Vector4;
		
	public function new(position: Vector4, color: Color) {
		super(Meshes.Boat, color, kha.Assets.images.black);
		
		startingPosition = position;
		resetAll();
	}
	
	private function resetMovement() {
		angle = 0;
		direction = new Vector4(0, 0, 1);
		impulse = new Vector4(0, 0, 0);
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
		var trackCenter = TrackGenerator.the.getY(position.z);
		if (Math.abs(TrackGenerator.the.getY(position.z) - position.x) >= TrackGenerator.the.width) {
			resetMovement();
			position = new Vector4(trackCenter, position.y, position.z - 5);
		}
		else {
			impulse.length = Math.max(impulse.length * (1 - IMPULSE_DAMPING * deltaTime), 0);
			rotationStrength =  Math.max(rotationStrength * (1 - ROTATING_DAMPING * deltaTime), 0);
			
			angle += rotationDir * rotationStrength * ROTATING_SPEED * deltaTime;
			position = position.add(impulse.mult(IMPULSE_SPEED * deltaTime));
			
			model = FastMatrix4.translation(position.x, position.y, position.z).multmat(FastMatrix4.rotationY(angle));
		}
	}
	
	public function getDistFromTrackCenter(): Float {
		return Math.abs(TrackGenerator.the.getY(position.z) - position.x);
	}
	
	public function resetAll() {
		resetMovement();
		position = startingPosition;
	}
}