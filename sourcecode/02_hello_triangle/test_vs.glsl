#version 410

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 vertex_colour;

uniform mat4 matrix; // our matrix


/*
uniform mat4 matrix1;
uniform mat4 matrix2;
uniform mat4 matrix3;
*/

/* 1.a
uniform mat4 matrix4;
*/


out vec3 colour;

void main() {
	colour = vertex_colour;

	gl_Position = (matrix) * vec4(vertex_position, 1.0);
	/* 1.a
	gl_Position = (matrix4) * vec4(vertex_position, 1.0);
    */

	/* 1.b 
	gl_Position = (matrix3 * matrix2 * matrix1) * vec4(vertex_position, 1.0);
	*/
}
