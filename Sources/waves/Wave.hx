package waves;

class Wave {
	var let: Wavelet;
	var num: Int;
	var hgt: Float;  // offset z coordinate to draw mesh, TODO should be in mesh design
	var cut: Float;  // kill prticles with absolute amplitude below this value
	var arr: Tensor;  // holds means to init the entire mesh
	var mxx: Float;
	var mxy: Float;
	var szx: Int;
	var szy: Int;
	var lcx: Int;
	var lxy: Int;
	var numel: Int; // max number of particles
	var dsr: Int; // distribute
	var texture_wav: Int;
	var texture_ref: Int;
	var spd: Float;  // TODO needed in this class (or just in lets) !?
	
	public function new() { }
}
