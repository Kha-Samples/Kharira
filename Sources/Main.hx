package;

import kha.System;

class Main {
	public static function main() {
		System.init("KhajakTest", 1024, 768, function () {
			new KhajakTest();
		});
	}
}
