#version 100

uniform sampler2D tex;

attribute vec2 pos;

void main() {  
	gl_Position = vec4(texture2D(tex, pos).xy, 0.0, 1.0);
}
