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
	var pipeline: PipelineState;
	var vertexBuffer: VertexBuffer;
	var indexBuffer: IndexBuffer;

	public function new() {
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

		vertexBuffer = new VertexBuffer(50 * 50, structure, Usage.DynamicUsage);
		var vertices = vertexBuffer.lock();
		var ypos = -1.0;
		var xpos = -1.0;
		for (y in 0...50) {
			for (x in 0...50) {
				vertices.set(y * 50 * 2 + x * 2 + 0, (x - 25) / 25.0 * 50.0);
				vertices.set(y * 50 * 2 + x * 2 + 1, (y - 25) / 25.0 * 50.0);
			}
		}
		vertexBuffer.unlock();
		
		indexBuffer = new IndexBuffer(50 * 50 * 6, Usage.StaticUsage);
		var indices = indexBuffer.lock();
		for (i in 0...49 * 49) {
			indices[i * 6 + 0] = i;
			indices[i * 6 + 1] = i + 1;
			indices[i * 6 + 2] = i + 50;
			indices[i * 6 + 3] = i + 50;
			indices[i * 6 + 4] = i + 1;
			indices[i * 6 + 5] = i + 50 + 1;
		}
		indexBuffer.unlock();
	}
	
	public function render(framebuffer: Framebuffer, matrix: FastMatrix4): Void {
		var g = framebuffer.g4;
		g.setPipeline(pipeline);
		g.setMatrix(matrixLocation, matrix);
		g.setTexture(vertexMapLocation, vertexMap);
		g.setIndexBuffer(indexBuffer);
		g.setVertexBuffer(vertexBuffer);
		g.drawIndexedVertices();
	}
}
