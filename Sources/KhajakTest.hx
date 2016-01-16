package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.math.FastVector3;
import kha.Scheduler;
import kha.System;
import khajak.Mesh;
import khajak.Renderer;
import khajak.RenderObject;

class KhajakTest {
	var boxMesh: Mesh;
	var box: RenderObject;
	var initialized: Bool;
	
	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		
		Renderer.init(new Renderer(Color.fromFloats(0.5, 0.5, 0.5)));
		
		Assets.loadEverything(loadFinished);
	}
	
	function loadFinished() {
		Renderer.the.light1.position = new FastVector3(5, 5, 5);
		Renderer.the.light1.power = 100;
		Renderer.the.light1.color = Color.White;
		
		boxMesh = new Mesh(Assets.blobs.cube_obj.toString());
		box = new RenderObject(boxMesh, Color.Black, Assets.images.cube);
		Renderer.the.objects.push(box);
		
		initialized = true;
	}

	function update(): Void {
		if (!initialized) return;
		
		Renderer.the.updateCamera(new FastVector3(0, 0, 10), new FastVector3(0, 0, 0));
	}

	function render(framebuffer: Framebuffer): Void {
		if (!initialized) return;
		
		Renderer.the.render(framebuffer);
	}
}
