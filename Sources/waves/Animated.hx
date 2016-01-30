package waves;

class Animated {
	var pos: Tensor; // 4x4 state tensor (orientation, position)
	var vel: Tensor; // 4   velocity WORLD
	var ome: Tensor; // 4   angular velocity OBJECT
	var acc: Tensor; // 4   accel OBJECT coordinates
	var tor: Tensor; // 4   torque tensor (wtf: OBJECT coordinges ?)

	var fva: Tensor;
	var fot: Tensor;
	var ine: Tensor; // 4x4 inertia tensor, initialized with eye(4)

	var col: Tensor; // 4   color
	//time            rmv;
	var status: Int;
	var ort: Int;
	//rapid           rap;
	//meshgl*         msh;
	//meshgl*         shd;
	var shd_: Int; // display list for static shadow PROTOTYPE

	static var dt: Float;
	static var humanized: Animated;
	
	public function new() {
		pos = Tensor.eye(4);
		vel = new Tensor(4);
		ome = new Tensor(4);
		acc = new Tensor(4);
		tor = new Tensor(4);

		fva = new Tensor(4);
		fot = new Tensor(4);
		//ine = tensor<double>::diag(tensor<double>::vector(4).as( 1.0, 1.0, 1.0, 1.0));

		//col = tensor<double>::vector(4).as( 1.0, 1.0, 1.0, 1.0);
		//ort = random<double>::uniform()*100;
		//msh = 0;
		//shd = 0;
		shd_ = 0;
	}
}
