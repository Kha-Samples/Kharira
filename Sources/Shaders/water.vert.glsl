#version 100

uniform sampler2D tex;
uniform mat4 matrix;

attribute vec2 pos;

void main() {
	vec4 coord = texture2D(tex, pos);
	gl_Position = matrix * vec4(pos.x, coord.r, pos.y, 1.0);
}
