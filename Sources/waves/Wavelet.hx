package waves;

class Wavelet {
	private static var ANIWAVE_CONVERSION = 0.3;
	
	public function new() { }
	
	public function particle(loc: Tensor, dir: Tensor, amp: Float) {
		var wpt = new WavePart();
		wpt.pos0 = loc.data[0];
		wpt.pos1 = loc.data[1];
		var fac: Float = spd / Math.sqrt(dir.data[0]*dir.data[0]+dir.data[1]*dir.data[1])*ANIWAVE_CONVERSION;
		wpt.vel0 = dir.data[0]*fac;
		wpt.vel1 = dir.data[1]*fac;
		wpt.amp = amp;
		wpt.ang = 1; // first split at t=1, causes circular pattern
		wpt.tic = 0; //** opengl_time.s();
		//** prt.add(wpt);
	}

	//linked<aniWavePart*>  prt;
	//linked<aniWaveRefl>   tre;  // this should be a sorted thing: like treeset !!!
	//linked<aniWaveEdge*>  edg;
	public var wav: Wave;
	public var spd: Float;
}
