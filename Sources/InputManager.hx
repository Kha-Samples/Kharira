package;

import kha.Key;

class InputManager {
	
	public static var the(default, null): InputManager;
	
	public function new() {
		for (i in 0...1) {
			registerGamepadListenener(i);
		}
	}
	
	public static function init(inputManager: InputManager) {
		the = inputManager;
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
		trace("[axis_" + padID + "] " + axis + ": " + value);
	}
	
	function onGamepadButton(padID: Int, button: Int, value: Float) {
		trace("[button_" + padID + "] " + button + ": " + value);
	}
}