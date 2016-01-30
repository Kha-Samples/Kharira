package;

class TrackGenerator {
	
	public var width(default, null): Float;
	
	private var sections: Int;
	private var minCurve: Float;
	private var maxCurve: Float;
	private var minLenght: Float;
	private var maxLenght: Float;
	private var sectionCurves: Array<Float>;
	private var sectionLengths: Array<Float>;
	
	public static var the(default, null): TrackGenerator;
	
	public function new(sections: Int, minCurve: Float, maxCurve: Float, minLenght: Float, maxLenght: Float, width: Float) {
		this.sections = sections;
		this.minCurve = minCurve;
		this.maxCurve = maxCurve;
		this.minLenght = minLenght;
		this.maxLenght = maxLenght;
		this.width = width;
		
		sectionCurves = new Array<Float>();
		sectionLengths = new Array<Float>();
		
		generate();
	}
	
	public static function init(trackGenerator: TrackGenerator) {
		the = trackGenerator;
	}
	
	public function generate() {
		var lastCurve = (maxCurve - minCurve) / 2;
		var lastLength = (maxLenght - minLenght) / 2;
		for (i in 0...sections) {
			lastCurve = getRandomValue(Math.max(lastCurve - 1.0, minCurve), Math.min(lastCurve + 1.0, maxCurve));
			sectionCurves[i] = lastCurve;
			lastLength = getRandomValue(Math.max(lastLength - 1.0, minLenght), Math.min(lastLength + 1.0, maxLenght));
			sectionLengths[i] = lastLength;
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
