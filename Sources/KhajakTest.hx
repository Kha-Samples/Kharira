package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.Vector2;
import kha.Scheduler;
import kha.System;
import khajak.Mesh;
import khajak.particles.Emitter;
import khajak.Renderer;
import khajak.RenderObject;

class KhajakTest {
	var lastTime: Float;
	
	var boxMesh: Mesh;
	var billboardMesh: Mesh;
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
		
		boxMesh = Mesh.FromModel(Assets.blobs.cube_obj.toString());
		box = new RenderObject(boxMesh, Color.Black, Assets.images.cube);
		Renderer.the.objects.push(box);
		
		var emitter = new Emitter(new FastVector3(0, -1, 2), 0.1, true, new FastVector3(0, 1, 0), 0.125 * Math.PI, false, new Vector2(1, 1.5), new Vector2(1, 1), new Vector2(1, 1), new FastVector2(0.15, 0.15), new FastVector2(0.25, 0.25), Assets.images.smoke, 0.005, 0.005, 500);
		emitter.start(Math.POSITIVE_INFINITY);
		Renderer.the.particleEmitters.push(emitter);
		
		emitter = new Emitter(new FastVector3(1, 0, -2), 0, false, new FastVector3(-1, 0, 0), 0, true, new Vector2(1, 1), new Vector2(0.5, 1), new Vector2(0.5, 1), new FastVector2(0.1, 0.1), new FastVector2(0.2, 0.2), Assets.images.cube, 0.3, 0.5, 10);
		emitter.start(10);
		Renderer.the.particleEmitters.push(emitter);
		
		lastTime = Scheduler.time();
		initialized = true;
	}

	function update(): Void {
		if (!initialized) return;
		
		var deltaTime = Scheduler.time() - lastTime;
		lastTime = Scheduler.time();
		
		for (emitter in Renderer.the.particleEmitters) {
			emitter.update(deltaTime);
		}
		Renderer.the.updateCamera(new FastVector3(0, 0, 10), new FastVector3(0, 0, 0));
	}

	function render(framebuffer: Framebuffer): Void {
		if (!initialized) return;
		
		Renderer.the.render(framebuffer);
	}
}
