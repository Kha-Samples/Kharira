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
	private var startDown: Array<Bool>;
	
	public var currentLeft(default, null): Array<Bool>;
	
	private var time: Array<Float>;
	
	public function new() {
		leftSide = [false, false];
		rightSide = [false, false];
		strenghtLeft = [false, false];
		startDown = [false, false];
		currentLeft = [false, false];
		strenght = [0.0, 0.0];
		time = [Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY];
		
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
		var linear = Math.max(1 - Math.abs(TARGET_DELAY - (Scheduler.time() - time[ID])), 0);
		return linear * linear;
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
		if (inputChar == "s") {
			startDown[0] = true;
		}
		if (inputChar == "k") {
			startDown[1] = true;
		}
		else if (inputChar == "q") {
			onInsert(0, true);
		}
		else if (inputChar == "u") {
			onInsert(1, true);
		}
		else if (inputChar == "e") {
			onInsert(0, false);
		}
		else if (inputChar == "o") {
			onInsert(1, false);
		}
		else if (inputChar == "a") {
			onPush(0, true);
		}
		else if (inputChar == "j") {
			onPush(1, true);
		}
		else if (inputChar == "d") {
			onPush(0, false);
		}
		else if (inputChar == "l") {
			onPush(1, false);
		}
    }

    function onKeyUp(inputKey : Key, inputChar : String) {
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
		else if (button == 4 && value > TRIGGER_THRESHOLD) {
			onInsert(padID, true);
		}
		else if (button == 5 && value > TRIGGER_THRESHOLD) {
			onInsert(padID, false);
		}
		else if (button == 6 && value > TRIGGER_THRESHOLD) {
			onPush(padID, true);
		}
		else if (button == 7 && value > TRIGGER_THRESHOLD) {
			onPush(padID, false);
		}
		//trace("[button_" + padID + "] " + button + ": " + value);
	}
	
	private function onInsert(ID: Int, left: Bool) {
		rightSide[ID] = !left;
		leftSide[ID] = left;
		currentLeft[ID] = left;
		strenght[ID] = 0.0;
		time[ID] = Scheduler.time();
		kha.audio1.Audio.play(kha.Assets.sounds.insert);
	}
	
	private function onPush(ID: Int, left: Bool) {
		if (rightSide[ID] && !left || leftSide[ID] && left) {
			strenght[ID] = getCharge(ID);
			leftSide[ID] = false;
			rightSide[ID] = false;
			strenghtLeft[ID] = left;
			time[ID] = Math.NEGATIVE_INFINITY;
			kha.audio1.Audio.play(kha.Assets.sounds.pull);
		}
	}
	
	private inline function clamp(value: Float, min: Float, max: Float) {
		return Math.min(Math.max(value, min), max);
	}
}