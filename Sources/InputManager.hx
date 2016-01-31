package;

import kha.Key;
import kha.Scheduler;

class InputManager {
	
	public static var TARGET_DELAY = 1.0;
	public static var TRIGGER_THRESHOLD = 0.75;
	
	public static var the(default, null): InputManager;
	
	private var leftSide: Array<Bool>;
	private var rightSide: Array<Bool>;
	
	public var strenghtLeft: Array<Bool>;
	private var strenght: Array<Float>;
	private var inverted: Array<Bool>;
	private var invertedDown: Array<Bool>;
	private var startDown: Array<Bool>;
	
	public var currentLeft(default, null): Array<Bool>;
	
	private var time: Array<Float>;
	
	public var forceStart: Bool;
	
	public function new() {
		leftSide = [false, false];
		rightSide = [false, false];
		strenghtLeft = [false, false];
		inverted = [false, false];
		invertedDown = [false, false];
		startDown = [false, false];
		currentLeft = [false, false];
		strenght = [0.0, 0.0];
		time = [Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY];
		forceStart = false;
		
		for (i in 0...2) {
			registerGamepadListenener(i);
		}
	}
	
	public static function init(inputManager: InputManager) {
		the = inputManager;
	}
	
	public function getStart(ID: Int): Bool {
		return startDown[ID];
	}
	
	public function getCharge(ID: Int): Float {
		return Math.max(1 - Math.abs(TARGET_DELAY - (Scheduler.time() - time[ID])), 0);
	}
	
	public function getStrength(ID: Int, left: Bool): Float {
		if (left != inverted[ID] && !strenghtLeft[ID])
			return 0.0;
		if (left == inverted[ID] && strenghtLeft[ID])
			return 0.0;
		
		var result = strenght[ID];
		strenght[ID] = 0.0;
		return result;
	}
	
	function registerGamepadListenener(ID: Int) {
		kha.input.Keyboard.get().notify(onKeyDown, onKeyUp);
		if (kha.input.Gamepad.get(ID) != null) {
			kha.input.Gamepad.get(ID).notify(onGamepadAxis.bind(ID), onGamepadButton.bind(ID));
		}
	}
	
    function onKeyDown(inputKey : Key, inputChar : String) {
		if (inputChar == " ") forceStart = true;
		if (inputChar == "s") {
			startDown[0] = true;
		}
		if (inputChar == "k") {
			startDown[1] = true;
		}
		else if (inputChar == "q") {
			rightSide[0] = false;
			leftSide[0] = true;
			currentLeft[0] = true;
			strenght[0] = 0.0;
			time[0] = Scheduler.time();
			kha.audio1.Audio.play(kha.Assets.sounds.insert);
		}
		else if (inputChar == "u") {
			rightSide[1] = false;
			leftSide[1] = true;
			currentLeft[1] = true;
			strenght[1] = 0.0;
			time[1] = Scheduler.time();
			kha.audio1.Audio.play(kha.Assets.sounds.insert);
		}
		else if (inputChar == "e") {
			rightSide[0] = true;
			leftSide[0] = false;
			currentLeft[0] = false;
			strenght[0] = 0.0;
			time[0] = Scheduler.time();
			kha.audio1.Audio.play(kha.Assets.sounds.insert);
		}
		else if (inputChar == "o") {
			rightSide[1] = true;
			leftSide[1] = false;
			currentLeft[1] = false;
			strenght[1] = 0.0;
			time[1] = Scheduler.time();
			kha.audio1.Audio.play(kha.Assets.sounds.insert);
		}
		else if (inputChar == "a") {
			if (leftSide[0]) {
				strenght[0] = getCharge(0);
				leftSide[0] = false;
				strenghtLeft[0] = true;
				time[0] = Math.NEGATIVE_INFINITY;
				kha.audio1.Audio.play(kha.Assets.sounds.pull);
			}
		}
		else if (inputChar == "j") {
			if (leftSide[1]) {
				strenght[1] = getCharge(1);
				leftSide[1] = false;
				strenghtLeft[1] = true;
				time[1] = Math.NEGATIVE_INFINITY;
				kha.audio1.Audio.play(kha.Assets.sounds.pull);
			}
		}
		else if (inputChar == "d") {
			if (rightSide[0]) {
				strenght[0] = getCharge(0);
				rightSide[0] = false;
				strenghtLeft[0] = false;
				time[0] = Math.NEGATIVE_INFINITY;
				kha.audio1.Audio.play(kha.Assets.sounds.pull);
			}
		}
		else if (inputChar == "l") {
			if (rightSide[1]) {
				strenght[1] = getCharge(1);
				rightSide[1] = false;
				strenghtLeft[1] = false;
				time[1] = Math.NEGATIVE_INFINITY;
				kha.audio1.Audio.play(kha.Assets.sounds.pull);
			}
		}
    }

    function onKeyUp(inputKey : Key, inputChar : String) {
		if (inputChar == " ") forceStart = false;
		if (inputChar == "s") {
			startDown[0] = false;
		}
		if (inputChar == "k") {
			startDown[1] = false;
		}
    }
	
	function onGamepadAxis(padID: Int, axis: Int, value: Float) {
		//trace("[axis_" + padID + "] " + axis + ": " + value);
	}
	
	function onGamepadButton(padID: Int, button: Int, value: Float) {
		if (button == 0) {
			startDown[padID] = value > 0.75;
		}
		/*else if (button == 3) {
			var down = value > 0.75;
			if (invertedDown[padID] && !down) {
				invertedDown[padID] = false;
			}
			else if (!invertedDown[padID] && down) {
				invertedDown[padID] = true;
				inverted[padID] = !inverted[padID];
			}
		}*/
		else if (button == 4 && value > TRIGGER_THRESHOLD) {
			rightSide[padID] = false;
			leftSide[padID] = true;
			currentLeft[padID] = true;
			strenght[padID] = 0.0;
			time[padID] = Scheduler.time();
			kha.audio1.Audio.play(kha.Assets.sounds.insert);
		}
		else if (button == 5 && value > TRIGGER_THRESHOLD) {
			rightSide[padID] = true;
			leftSide[padID] = false;
			currentLeft[padID] = false;
			strenght[padID] = 0.0;
			time[padID] = Scheduler.time();
			kha.audio1.Audio.play(kha.Assets.sounds.insert);
		}
		else if (button == 6 && value > TRIGGER_THRESHOLD) {
			if (leftSide[padID]) {
				strenght[padID] = getCharge(padID);
				leftSide[padID] = false;
				strenghtLeft[padID] = true;
				time[padID] = Math.NEGATIVE_INFINITY;
				kha.audio1.Audio.play(kha.Assets.sounds.pull);
			}
		}
		else if (button == 7 && value > TRIGGER_THRESHOLD) {
			if (rightSide[padID]) {
				strenght[padID] = getCharge(padID);
				rightSide[padID] = false;
				strenghtLeft[padID] = false;
				time[padID] = Math.NEGATIVE_INFINITY;
				kha.audio1.Audio.play(kha.Assets.sounds.pull);
			}
		}
		//trace("[button_" + padID + "] " + button + ": " + value);
	}
	
	private inline function clamp(value: Float, min: Float, max: Float) {
		return Math.min(Math.max(value, min), max);
	}
}