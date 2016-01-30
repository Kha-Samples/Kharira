package;

import kha.Framebuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureFormat;
import kha.graphics4.TextureUnit;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Image;
import kha.math.Random;
import kha.Shaders;

class Water {
	var vertexMap: Image;
	var vertexMapLocation: TextureUnit;
	var waterPipeline: PipelineState;

	public function new() {
		vertexMap = Image.create(1024, 1024, TextureFormat.L8);
		var pixels = vertexMap.lock();
		for (y in 0...1024)
			for (x in 0...1024)
				pixels.set(y * 1024 + x, Random.getUpTo(255));
		vertexMap.unlock();
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float2);
		waterPipeline = new PipelineState();
		waterPipeline.inputLayout = [structure];
		waterPipeline.vertexShader = Shaders.water_vert;
		waterPipeline.fragmentShader = Shaders.water_frag;
		waterPipeline.compile();
		
		vertexMapLocation = waterPipeline.getTextureUnit("tex");
	}
	
	public function render(framebuffer: Framebuffer): Void {
		var g = framebuffer.g4;
		g.setTexture(vertexMapLocation, vertexMap);
		
	}
}
