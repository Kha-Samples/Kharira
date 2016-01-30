package waves;

class WavePart {
	public var pos0: Float; // birth place
	public var pos1: Float;
	public var vel0: Float; // velocity
	public var vel1: Float;
	public var amp: Float;  // amplitude
	public var ang: Int;  // next split (is compared to opengl_time - tic) / recursion => dispersion angle
	public var tic: Float;  // birth time
	
	public function new() { }
}
