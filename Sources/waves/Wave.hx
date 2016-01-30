package waves;

import haxe.ds.Vector;

class Wave extends Animated {
	private static var ANIWAVE_CONVERSION = 0.3;
	
	var let: Vector<Wavelet>;
	var num: Int;
	var hgt: Float;  // offset z coordinate to draw mesh, TODO should be in mesh design
	var cut: Float;  // kill prticles with absolute amplitude below this value
	var arr: Tensor;  // holds means to init the entire mesh
	var mxx: Float;
	var mxy: Float;
	var szx: Int;
	var szy: Int;
	var lcx: Int;
	var lcy: Int;
	var numel: Int; // max number of particles
	var dsr: Int; // distribute
	var texture_wav: Int;
	var texture_ref: Int;
	var spd: Float;  // TODO needed in this class (or just in lets) !?
	
	public function new(num: Int, szx: Int, szy: Int, mxx: Float, mxy: Float) {
		super();
		num = 1;
		this.num = num;
		this.szx = szx;
		this.szy = szy;
		this.mxx = mxx;
		this.mxy = mxy;
		hgt = 0;
		dsr = 0;
		cut = 0.05;  
		//msh=new meshgl(meshgl::surface(tensor<float>(2,szx+1,szy+1))); // tensor<double>::vector(2).as( szx+0.0, szy+0.0)
		//arr=msh->arr;
		//printf("ARRAY %s\n",arr.toInfo());
		lcx = Std.int(pos.forValues(0, [3])); // initialization important for texture coordinates
		lcy = Std.int(pos.forValues(1, [3]));
		numel = 3500;
		//assert(0<num);
		let = new Vector<Wavelet>(num);
		for (c0 in 0...num) {
			let[c0] = new Wavelet();
			let[c0].wav = this;
		}
		spd = 0;
		setSpeed(1);
	}
	
	function setSpeed(spd_: Float) {
		spd_ = Math.max(0.1, spd_ / ANIWAVE_CONVERSION);
		if (spd!=spd_) {
			for (c0 in 0...num) {
				//**let.get(c0).tre.empty();
				//**let.get(c0).prt.delete_empty();
				let.get(c0).spd = spd_;
			}
			spd = spd_;
			//printf("setSpeed %6.3f\n", spd * ANIWAVE_CONVERSION);
		}
	}
}
