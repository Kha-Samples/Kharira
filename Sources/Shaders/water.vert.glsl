#version 100

uniform sampler2D tex;
uniform mat4 matrix;

attribute vec2 pos;

varying mediump vec4 color;

void main() {
	vec4 coord = texture2D(tex, pos);
	gl_Position = matrix * vec4(pos.x, coord.r, pos.y, 1.0);
	color = vec4(0.0, 0.0, coord.r, 0.0);
}
