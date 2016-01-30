package;

import kha.Key;
import kha.Scheduler;

class InputManager {
	
	public static var TARGET_DELAY = 1.0;
	public static var TRIGGER_THRESHOLD = 0.75;
	
	public static var the(default, null): InputManager;
	
	private var leftSide: Array<Bool>;
	private var rightSide: Array<Bool>;
	
	private var strenghtLeft: Array<Bool>;
	private var strenght: Array<Float>;
	
	private var time: Array<Float>;
	
	public function new() {
		leftSide = [false, false];
		rightSide = [false, false];
		strenghtLeft = [false, false];
		strenght = [0.0, 0.0];
		time = [0.0, 0.0];
		
		for (i in 0...2) {
			registerGamepadListenener(i);
		}
	}
	
	public static function init(inputManager: InputManager) {
		the = inputManager;
	}
	
	public function getStrength(ID: Int, left: Bool): Float {
		if (left && !strenghtLeft[ID])
			return 0.0;
		if (!left && strenghtLeft[ID])
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
    }

    function onKeyUp(inputKey : Key, inputChar : String) {
		if (inputChar == " ") TrackGenerator.the.generate();
    }
	
	function onGamepadAxis(padID: Int, axis: Int, value: Float) {
		//trace("[axis_" + padID + "] " + axis + ": " + value);
	}
	
	function onGamepadButton(padID: Int, button: Int, value: Float) {
		if (button == 4) {
			rightSide[padID] = false;
			leftSide[padID] = true;
			strenght[padID] = 0.0;
			time[padID] = Scheduler.time();
		}
		else if (button == 5) {
			rightSide[padID] = true;
			leftSide[padID] = false;
			strenght[padID] = 0.0;
			time[padID] = Scheduler.time();
		}
		else if (button == 6 && value > TRIGGER_THRESHOLD) {
			if (leftSide[padID]) {
				strenght[padID] = Math.max(1 - Math.abs(TARGET_DELAY - (Scheduler.time() - time[padID])), 0);
				leftSide[padID] = false;
				strenghtLeft[padID] = true;
			}
		}
		else if (button == 7 && value > TRIGGER_THRESHOLD) {
			if (rightSide[padID]) {
				strenght[padID] = Math.max(1 - Math.abs(TARGET_DELAY - (Scheduler.time() - time[padID])), 0);
				rightSide[padID] = false;
				strenghtLeft[padID] = false;
			}
		}
		//trace("[button_" + padID + "] " + button + ": " + value);
	}
	
	private inline function clamp(value: Float, min: Float, max: Float) {
		return Math.min(Math.max(value, min), max);
	}
}