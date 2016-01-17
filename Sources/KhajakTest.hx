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
	var emitter: Emitter;
	var emitter2: Emitter;
	
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
		
		billboardMesh = new Mesh(Assets.blobs.billboard_obj.toString());
		emitter = new Emitter(new FastVector3(-1, 0, 2), new FastVector3(1, 0, 0), 45, false, new Vector2(2, 3), new Vector2(0.5, 1), new FastVector2(0.1, 0.1), new FastVector2(0.2, 0.2), Assets.images.cube, 0.3, 10, billboardMesh);
		emitter.start(10);
		Renderer.the.particleEmitters.push(emitter);
		
		emitter2 = new Emitter(new FastVector3(1, 0, -2), new FastVector3(-1, 0, 0), 45, false, new Vector2(2, 3), new Vector2(0.5, 1), new FastVector2(0.1, 0.1), new FastVector2(0.2, 0.2), Assets.images.cube, 0.3, 10, billboardMesh);
		emitter2.start(10);
		Renderer.the.particleEmitters.push(emitter2);
		
		lastTime = Scheduler.time();
		initialized = true;
	}

	function update(): Void {
		if (!initialized) return;
		
		var deltaTime = Scheduler.time() - lastTime;
		lastTime = Scheduler.time();
		
		emitter.update(deltaTime);
		emitter2.update(deltaTime);
		Renderer.the.updateCamera(new FastVector3(0, 0, 10), new FastVector3(0, 0, 0));
	}

	function render(framebuffer: Framebuffer): Void {
		if (!initialized) return;
		
		Renderer.the.render(framebuffer);
	}
}
