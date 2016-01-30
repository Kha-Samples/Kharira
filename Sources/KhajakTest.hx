package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.Vector2;
import kha.math.Vector3;
import kha.math.Vector4;
import kha.Scheduler;
import kha.System;
import khajak.Mesh;
import khajak.particles.Emitter;
import khajak.Renderer;
import khajak.RenderObject;

class KhajakTest {
	var lastTime: Float;
	
	var boats: Array<Boat>;
	var water: Water;
	var initialized: Bool;
	
	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		
		Renderer.init(new Renderer(Color.fromFloats(0.5, 0.5, 0.5)));
		Renderer.the.setSplitscreenMode(2);
		
		Assets.loadEverything(loadFinished);
	}
	
	function loadFinished() {
		kha.math.Random.init(Std.int(Scheduler.realTime() * 1000000));
		InputManager.init(new InputManager());		
		TrackGenerator.init(new TrackGenerator(42, 1, 5, 10, 20));
		
		Renderer.the.light1.position = new FastVector3(5, 500, 5);
		Renderer.the.light1.power = 150000;
		Renderer.the.light1.color = Color.White;
			
		/*var emitter = new Emitter(new FastVector3(0, -1, 2), 0.1, 0.1, new FastVector3(0, 1, 0), 0.125 * Math.PI, 0, 1, 1.5, new FastVector2(0.15, 0.15), new FastVector2(0.25, 0.25), 0, 2 * Math.PI, 0, 2 * Math.PI, 1, 1, 1, 1, Color.Magenta, Color.Magenta, Color.Green, Color.Green, 0.005, 0.005, 500, Assets.images.smoke);
		emitter.start(Math.POSITIVE_INFINITY);
		Renderer.the.particleEmitters.push(emitter);*/
		
		water = new Water();
		boats = [new Boat(new Vector4(-2, 0, 0)), new Boat(new Vector4(2, 0, 0))];
		for (boat in boats) {
			Renderer.the.objects.push(boat);
		}
		
		lastTime = Scheduler.time();
		initialized = true;
	}

	function update(): Void {
		if (!initialized) return;
		
		var deltaTime = Scheduler.time() - lastTime;
		lastTime = Scheduler.time();
		
		var left: Float;
		var right: Float;
		for (player in 0...2) {
			left = InputManager.the.getStrength(player, false);
			right = InputManager.the.getStrength(player, true);
			
			if (left > 0) {
				boats[player].addImpulse(left, true);
				trace("[player " + player + "] left = " + left);
			}
			if (right > 0) {
				boats[player].addImpulse(right, false);
				trace("[player " + player + "] right = " + right);
			}
		}
		
		for (boat in boats) {
			boat.update(deltaTime);
		}
		
		for (emitter in Renderer.the.particleEmitters) {
			emitter.update(deltaTime);
		}
	}

	function render(framebuffer: Framebuffer): Void {
		if (!initialized) return;
		
		var distances = new Array<Float>();
		for (player in 0...2) {
			Renderer.the.updateCamera(new FastVector3(boats[player].position.x, 10, boats[player].position.z - 10), new FastVector3(boats[player].position.x, boats[player].position.y, boats[player].position.z));
			Renderer.the.render(framebuffer, player);
		
			distances[player] = boats[player].position.z - boats[1 - player].position.z;
		}
		
		//TODO: water.render(framebuffer);
		
		var g2 = framebuffer.g2;
		
		g2.begin(false);
		
		var nextY = 0.0;
		var lastY = TrackGenerator.the.getY(0) + System.pixelHeight / 2;
		for (i in 1...System.pixelWidth) {
			nextY = TrackGenerator.the.getY(i / 10) * 10 + System.pixelHeight / 2;
			g2.drawLine((i - 1), lastY, i, nextY);
			g2.drawLine((i - 1), lastY - 25, i, nextY - 25);
			g2.drawLine((i - 1), lastY + 25, i, nextY + 25);
			lastY = nextY;
		}
		
		var padding = 25;
		var fontSize = 16;
		var font = Assets.fonts.DejaVuSansMono_Bold;
		
		g2.fontSize = fontSize;
		g2.font = font;
		
		g2.drawString(Math.round(distances[0]) + " m", padding, padding);
		var s = Math.round(distances[1]) + " m";
		g2.drawString(s, System.pixelWidth - padding - font.width(fontSize, s), padding);
		
		g2.end();
	}
}
