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
	public static var TRACK_LENGHT = 150;
	
	var lastTime: Float;
	
	var boats: Array<Boat>;
	var water: Water;
	
	var gameRunning: Bool;
	var gameStopped: Bool;
	var playerReady: Array<Bool>;
	var playerWon: Array<Bool>;
	var message: String;
	
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
		TrackGenerator.init(new TrackGenerator(42, 1, 5, 50, 75, 7));
		
		Renderer.the.light1.position = new FastVector3(5, 500, 5);
		Renderer.the.light1.power = 150000;
		Renderer.the.light1.color = Color.White;
			
		/*var emitter = new Emitter(new FastVector3(0, -1, 2), 0.1, 0.1, new FastVector3(0, 1, 0), 0.125 * Math.PI, 0, 1, 1.5, new FastVector2(0.15, 0.15), new FastVector2(0.25, 0.25), 0, 2 * Math.PI, 0, 2 * Math.PI, 1, 1, 1, 1, Color.Magenta, Color.Magenta, Color.Green, Color.Green, 0.005, 0.005, 500, Assets.images.smoke);
		emitter.start(Math.POSITIVE_INFINITY);
		Renderer.the.particleEmitters.push(emitter);*/
		
		water = new Water();
		boats = [new Boat(new Vector4(2, 1.2, 0), kha.Color.fromBytes(238, 154, 73)), new Boat(new Vector4(-2, 1.2, 0), kha.Color.fromBytes(139, 90, 43))];
		for (boat in boats) {
			Renderer.the.objects.push(boat);
		}
		
		var x: Float;
		var y: Float;
		var iMax = Std.int(TRACK_LENGHT / 5);
		for (i in 0...iMax) {
			x = i * 5;
			y = TrackGenerator.the.getY(x);
			Renderer.the.objects.push(new Stone(new Vector4(y - (TrackGenerator.the.width + 2.0), 1, x)));
			Renderer.the.objects.push(new Stone(new Vector4(y + (TrackGenerator.the.width + 2.0), 1, x)));
		}
		
		reset();
		
		lastTime = Scheduler.time();
		initialized = true;
	}
	
	function reset() {
		gameRunning = false;
		gameStopped = false;
		playerReady = [false, false];
		playerWon = [false, false];
		message = "";
		for (player in 0...2) {
			boats[player].resetAll();
		}
	}

	function update(): Void {
		if (!initialized) return;
		
		var deltaTime = Scheduler.time() - lastTime;
		lastTime = Scheduler.time();
		
		if (gameRunning) {
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
		}
		else {
			var ready = true;
			for (player in 0...2) {
				playerReady[player] = playerReady[player] || InputManager.the.getStart(player);
				ready = ready && playerReady[player];
			}
			gameRunning = ready || InputManager.the.forceStart;
			if (gameRunning) {
				Scheduler.addTimeTask(displayText.bind("Lower your paddle with a shoulder button").bind(3), 1);
				Scheduler.addTimeTask(displayText.bind("Pull back using a trigger").bind(3), 5);
				Scheduler.addTimeTask(displayText.bind("Experiment with the delay between your inputs").bind(3), 9);
			}
		}
		
		for (boat in boats) {
			boat.update(deltaTime);
		}
		
		for (player in 0...2) {
			if (!gameStopped && !playerWon[1 - player] && boats[player].position.z >= (TRACK_LENGHT - 5)) {
				playerWon[player] = true;
				displayText("Player " + ((1 - player) + 1) + " will be sacrificed at the ritual!", 10);
				Scheduler.addTimeTask(reset, 11);
				gameStopped = true;
			}
		}
		for (emitter in Renderer.the.particleEmitters) {
			emitter.update(deltaTime);
		}
	}

	function render(framebuffer: Framebuffer): Void {
		if (!initialized) return;
		
		var distances = new Array<Float>();
		for (player in 0...2) {
			Renderer.the.updateCamera(new FastVector3(boats[player].position.x, 20, boats[player].position.z - 20), new FastVector3(boats[player].position.x, 0, boats[player].position.z + 10));
			Renderer.the.beginRender(framebuffer, player);
			water.render(framebuffer, Renderer.the.calculateMV(), boats[player].position.z);
			Renderer.the.render(framebuffer, player);
			Renderer.the.endRender(framebuffer, player);
		
			distances[player] = boats[player].position.z - boats[1 - player].position.z;
		}
		
		var g2 = framebuffer.g2;
		
		g2.begin(false);
		
		g2.color = Color.fromFloats(0.5, 0.5, 0.5);
		
		g2.fillRect(Std.int(System.pixelWidth / 2) - 2, 0, 4, System.pixelHeight);
		
		
		g2.color = Color.White;
		/*var nextY = 0.0;
		var lastY = TrackGenerator.the.getY(0) + System.pixelHeight / 2;
		for (i in 1...System.pixelWidth) {
			nextY = TrackGenerator.the.getY(i / 10) * 10 + System.pixelHeight / 2;
			g2.drawLine((i - 1), lastY, i, nextY);
			g2.drawLine((i - 1), lastY - 25, i, nextY - 25);
			g2.drawLine((i - 1), lastY + 25, i, nextY + 25);
			lastY = nextY;
		}*/
		
		var padding = 25;
		var fontSize = 16;
		var font = Assets.fonts.DejaVuSansMono_Bold;
		
		g2.fontSize = fontSize;
		g2.font = font;
		
		g2.drawString(Math.round(distances[0]) + " m", padding, padding);
		var s = Math.round(distances[1]) + " m";
		g2.drawString(s, System.pixelWidth - padding - font.width(fontSize, s), padding);
		
		if (!gameRunning) {
			for (player in 0...2) {
				if (!playerReady[player]) {
					s = "Press A to ready up";
					g2.drawString(s, player * System.pixelWidth / 2 + System.pixelWidth / 4 - font.width(fontSize, s) / 2, (System.pixelHeight - font.height(fontSize)) / 2);
				}
			}
		}
		else if (message != "") {
			s = message;
			for (player in 0...2) {
				g2.drawString(s, player * System.pixelWidth / 2 + System.pixelWidth / 4 - font.width(fontSize, s) / 2, (System.pixelHeight - font.height(fontSize)) / 2);
			}
		}
		
		if (!gameRunning) {
			fontSize = 12;
			g2.fontSize = fontSize;
			
			s = "A Global Game Jam 2016 game";
			g2.drawString(s, (System.pixelWidth - font.width(fontSize, s)) / 2, (3 * System.pixelHeight / 2 - font.height(fontSize)) / 2);
			s = "by Robert Konrad and Christian Reuter";
			g2.drawString(s, (System.pixelWidth - font.width(fontSize, s)) / 2, (3 * System.pixelHeight / 2 - font.height(fontSize)) / 2 + font.height(fontSize) * 1.5);
			s = "made with Kha (http://kode.tech)";
			g2.drawString(s, (System.pixelWidth - font.width(fontSize, s)) / 2, (3 * System.pixelHeight / 2 - font.height(fontSize)) / 2 + font.height(fontSize) * 3);
			
			fontSize = 48;
			g2.fontSize = fontSize;
			
			s = "Khajak";
			g2.drawString(s, (System.pixelWidth - font.width(fontSize, s)) / 2, (System.pixelHeight / 3 - font.height(fontSize)) / 2);
		}
		
		g2.end();
	}
	
	private function displayText(text: String, seconds: Float) {
		message = text;
		Scheduler.addTimeTask(function(){message = "";}, seconds);
	}
}
