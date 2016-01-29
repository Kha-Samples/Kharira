package;

class TrackGenerator {
	
	private var sections: Int;
	private var sectionCurves: Array<Float>;
	private var sectionLengths: Array<Float>;
	
	public function new(sections: Int) {
		this.sections = sections;
		sectionCurves = new Array<Float>();
		sectionLengths = new Array<Float>();
		
		for (i in 0...sections) {
			sectionCurves.push(getRandomValue(1, 4));
			sectionLengths.push(getRandomValue(10, 20));
		}
		
	}
	
	public function getY(x: Float): Float {
		var s = 0;
		var l = sectionLengths[0];
		while (x > l && s < sections) {
			s++;
			l += sectionLengths[s];
		}
		
		return getYInSection(x, s);
	}
	
	private function getYInSection(x: Float, s: Int): Float {
		return Math.sin(sectionLengths[s] * x / (2 * Math.PI)) * sectionCurves[s];
	}
	
	private inline function getRandomValue(min: Float, max: Float): Float {
		return min + kha.math.Random.getFloat() * (max - min);
	}
}
