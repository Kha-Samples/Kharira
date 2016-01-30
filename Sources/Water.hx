package;

import kha.Framebuffer;
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
import kha.math.Random;
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
}
