package;

import kha.Framebuffer;
import kha.graphics4.CompareMode;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureFormat;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Image;
import kha.math.FastMatrix4;
import kha.math.Matrix2;
import kha.math.Random;
import kha.math.Vector2;
import kha.Shaders;

class Water {
	var vertexMap: Image;
	var vertexMapLocation: TextureUnit;
	var matrixLocation: ConstantLocation;
	var timeLocation: ConstantLocation;
	var pipeline: PipelineState;
	var vertexBuffer: VertexBuffer;
	var indexBuffer: IndexBuffer;
	static inline var xdiv: Int = 150;
	static inline var ydiv: Int = 150;

	public function new() {
		new waves.Wavelet();
		
		vertexMap = Image.create(1024, 1024, TextureFormat.L8);
		var pixels = vertexMap.lock();
		for (y in 0...1024)
			for (x in 0...1024)
				pixels.set(y * 1024 + x, Random.getUpTo(255));
		vertexMap.unlock();
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float2);
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.water_vert;
		pipeline.fragmentShader = Shaders.water_frag;
		pipeline.depthWrite = true;
		pipeline.depthMode = CompareMode.Less;
		pipeline.compile();
		
		vertexMapLocation = pipeline.getTextureUnit("tex");
		matrixLocation = pipeline.getConstantLocation("matrix");
		timeLocation = pipeline.getConstantLocation("time");

		vertexBuffer = new VertexBuffer(xdiv * ydiv, structure, Usage.DynamicUsage);
		var vertices = vertexBuffer.lock();
		var ypos = -1.0;
		var xpos = -1.0;
		for (y in 0...ydiv) {
			for (x in 0...xdiv) {
				vertices.set(y * xdiv * 2 + x * 2 + 0, (x - (xdiv / 2)) / (xdiv / 2) * 50.0);
				vertices.set(y * xdiv * 2 + x * 2 + 1, (y - (ydiv / 2)) / (ydiv / 2) * 50.0);
			}
		}
		vertexBuffer.unlock();
		
		indexBuffer = new IndexBuffer(xdiv * ydiv * 6, Usage.StaticUsage);
		var indices = indexBuffer.lock();		
		for (y in 0...ydiv - 1) {
			for (x in 0...xdiv - 1) {
				indices[y * xdiv * 6 + x * 6 + 0] = y * xdiv + x;
				indices[y * xdiv * 6 + x * 6 + 1] = y * xdiv + x + 1;
				indices[y * xdiv * 6 + x * 6 + 2] = (y + 1) * xdiv + x;
				indices[y * xdiv * 6 + x * 6 + 3] = (y + 1) * xdiv + x;
				indices[y * xdiv * 6 + x * 6 + 4] = y * xdiv + x + 1;
				indices[y * xdiv * 6 + x * 6 + 5] = (y + 1) * xdiv + x + 1;
			}
		}
		indexBuffer.unlock();
	}
	
	public function render(framebuffer: Framebuffer, matrix: FastMatrix4): Void {
		var g = framebuffer.g4;
		g.setPipeline(pipeline);
		g.setFloat(timeLocation, kha.Scheduler.time() * 5);
		g.setMatrix(matrixLocation, matrix);
		g.setTexture(vertexMapLocation, vertexMap);
		g.setIndexBuffer(indexBuffer);
		g.setVertexBuffer(vertexBuffer);
		g.drawIndexedVertices();
	}
	
	static inline var ITER_GEOMETRY = 3;
	static inline var SEA_CHOPPY = 4.0;
	static inline var SEA_SPEED = 0.8;
	static inline var SEA_FREQ = 0.16;
	static inline var SEA_HEIGHT = 0.6;
	static var octave_m = new Matrix2(1.6, 1.2, -1.2, 1.6);

	static function sin(vec: Vector2) {
		return new Vector2(Math.sin(vec.x), Math.sin(vec.y));
	}
	
	static function cos(vec: Vector2) {
		return new Vector2(Math.cos(vec.x), Math.cos(vec.y));
	}
	
	static function abs(vec: Vector2) {
		return new Vector2(Math.abs(vec.x), Math.abs(vec.y));
	}
	
	static function fract(x: Float) {
		return x - Math.floor(x);
	}
	
	static function fract_v2(vec: Vector2) {
		return new Vector2(fract(vec.x), fract(vec.y));
	}
	
	static function floor(vec: Vector2) {
		return new Vector2(Math.floor(vec.x), Math.floor(vec.y));
	}
	
	static function mix(x: Float, y: Float, a: Float) {
		return x * (1.0 - a) + y * a;
	}
	
	static function mix_vec2(x: Vector2, y: Vector2, a: Vector2) {
		return new Vector2(mix(x.x, y.x, a.x), mix(x.y, y.y, a.y));
	}
	
	static function add(vec: Vector2, value: Float) {
		return new Vector2(vec.x + value, vec.y + value);
	}
	
	static function add_vec(vec1: Vector2, vec2: Vector2) {
		return new Vector2(vec1.x + vec2.x, vec1.y + vec2.y);
	}

	static function hash(p: Vector2) {
		var h = p.dot(new Vector2(127.1,311.7));	
		return fract(Math.sin(h)*43758.5453123);
	}
	
	static function mult(v1: Vector2, v2: Vector2) {
		return new Vector2(v1.x * v2.x, v1.y * v2.y);
	}

	static function noise(p: Vector2) {
		var i = floor( p );
		var f = fract_v2( p );	
		var u = mult(f, mult(f, (add(f.mult(-2.0), 3.0))));
		return -1.0+2.0*mix( mix( hash( add_vec(i, new Vector2(0.0,0.0) ) ), 
						hash( add_vec(i, new Vector2(1.0,0.0) ) ), u.x),
					mix( hash( add_vec(i, new Vector2(0.0,1.0) ) ), 
						hash( add_vec(i, new Vector2(1.0,1.0) ) ), u.x), u.y);
	}

	static function sea_octave(uv: Vector2, choppy: Float) {
		uv = add(uv, noise(uv));
		var wv = add(abs(sin(uv)).mult(-1.0), 1.0);
		var swv = abs(cos(uv));
		wv = mix_vec2(wv,swv,wv);
		return Math.pow(1.0-Math.pow(wv.x * wv.y,0.65),choppy);
	}

	public static function map(uv: Vector2) {
		var SEA_TIME = kha.Scheduler.time() * SEA_SPEED;

		var freq = SEA_FREQ;
		var amp = SEA_HEIGHT;
		var choppy = SEA_CHOPPY;
		uv.x *= 0.75;
		
		var d = 0.0;
		var h = 0.0;
		for (i in 0...3) {
			d = sea_octave(add(uv, SEA_TIME).mult(freq),choppy);
			d += sea_octave(add(uv, -SEA_TIME).mult(freq),choppy);
			h += d * amp;
			uv = octave_m.multvec(uv); freq *= 1.9; amp *= 0.22;
			choppy = mix(choppy,1.0,0.2);
		}
		return h;// p.y - h;
	}
}
