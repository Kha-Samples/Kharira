package;

class TrackGenerator {
	
	private var sections: Int;
	private var sectionCurves: Array<Float>;
	private var sectionLengths: Array<Float>;
	
	public function new(sections: Int) {
		this.sections = sections;
		sectionCurves = new Array<Float>();
		sectionLengths = new Array<Float>();
		
		var lastCurve = 2.5;
		for (i in 0...sections) {
			var lastCurve = getRandomValue(Math.max(lastCurve - 1.5, 1), Math.min(lastCurve + 1.5, 5));
			sectionCurves.push(lastCurve);
			sectionLengths.push(getRandomValue(5, 10));
		}
		
	}
	
	public function getY(x: Float): Float {
		var s = 0;
		var l = sectionLengths[0];
		while (x > l && s < sections) {
			s++;
			l += sectionLengths[s];
		}
		
		return getYInSection(x - l, s);
	}
	
	private function getYInSection(x: Float, s: Int): Float {
		return Math.sin(x * (2 * Math.PI) / sectionLengths[s]) * sectionCurves[s];
	}
	
	private inline function getRandomValue(min: Float, max: Float): Float {
		return min + kha.math.Random.getFloat() * (max - min);
	}
}
