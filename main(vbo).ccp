/******************************************************************************\
| OpenGL 4 Example Code.                                                       |
| Accompanies written series "Anton's OpenGL 4 Tutorials"                      |
| Email: anton at antongerdelan dot net                                        |
| First version 27 Jan 2014                                                    |
| Copyright Dr Anton Gerdelan, Trinity College Dublin, Ireland.                |
| See individual libraries for separate legal notices                          |
|******************************************************************************|
| Matrices and Vectors                                                         |
| Note: code discussed in previous tutorials is moved into gl_utils file       |
| On Apple don't forget to uncomment the version number hint in start_gl()     |
\******************************************************************************/
#include "gl_utils.h"		// utility functions discussed in earlier tutorials
#include <GL/glew.h>		// include GLEW and new version of GL on Windows
#include <GLFW/glfw3.h> // GLFW helper library
#include <assert.h>
#define _USE_MATH_DEFINES
#include <math.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "maths_funcs.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#define GL_LOG_FILE "gl.log"

// keep track of window size for things like the viewport and the mouse cursor
int g_gl_width = 640;
int g_gl_height = 480;
GLFWwindow *g_window = NULL;

int main() {
	restart_gl_log();
	// all the GLFW and GLEW start-up code is moved to here in gl_utils.cpp
	start_gl();
	// tell GL to only draw onto a pixel if the shape is closer to the viewer
	glEnable(GL_DEPTH_TEST); // enable depth-testing
	glDepthFunc(GL_LESS);		 // depth-testing interprets a smaller value as "closer"

	/* OTHER STUFF GOES HERE NEXT */
	//GLfloat points[] = { 0.0f, -0.1f, 0.0f,
	//					-0.2f, 0.2f, 0.0f,
	//					0.2f, 0.2f, 0.0f,

	//};

	GLfloat points[] = { 
		-0.4f, -0.1f, 0.0f, //D
		-0.6f, 0.2f, 0.0f,	//F
		-0.2f, 0.2f, 0.0f,	//B

		0.0f, -0.1f, 0.0f,	//A
		-0.4f, -0.1f, 0.0f,	//D
		-0.2f, 0.2f, 0.0f,	//B

		0.0f, -0.1f, 0.0f,	//A
		-0.2f, 0.2f, 0.0f,	//B
		0.2f, 0.2f, 0.0f,	//C

		0.4f, -0.1f, 0.0f,	//E
		0.0f, -0.1f, 0.0f,	//A
		0.2f, 0.2f, 0.0f,	//C

		0.4f, -0.1f, 0.0f,	//E
		0.2f, 0.2f, 0.0f,	//C
		0.6f, 0.2f, 0.0f,	//G
	};

	/*GLfloat points[] = { 0.2f, 0.2f, 0.0f,
		0.0f, -0.1, 0.0f
		- 0.4f, -0.1f, 0.0f,
		0.0f, -0.1f, 0.0f,
		-0.2f, 0.2f, 0.0f,
		0.2f, 0.2f, 0.0f };*/

	GLfloat colours[] = { 
		1.0f, 0.0f, 0.0f,
		1.0f, 0.0f, 0.0f,
		1.0f, 0.0f, 0.0f, 

		0.0f, 1.0f, 1.0f,
		0.0f, 1.0f, 1.0f,
		0.0f, 1.0f, 1.0f,

		0.0f, 1.0f, 0.0f,
		0.0f, 1.0f, 0.0f,
		0.0f, 1.0f, 0.0f,

		1.0f, 0.0f, 1.0f,
		1.0f, 0.0f, 1.0f,
		1.0f, 0.0f, 1.0f,

		0.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 1.0f,
	};


	GLuint points_vbo;
	glGenBuffers(1, &points_vbo);
	glBindBuffer(GL_ARRAY_BUFFER, points_vbo);
	glBufferData(GL_ARRAY_BUFFER, 45 * sizeof(GLfloat), points, GL_STATIC_DRAW);

	GLuint colours_vbo;
	glGenBuffers(1, &colours_vbo);
	glBindBuffer(GL_ARRAY_BUFFER, colours_vbo);
	glBufferData(GL_ARRAY_BUFFER, 45 * sizeof(GLfloat), colours, GL_STATIC_DRAW);

	GLuint vao;
	glGenVertexArrays(1, &vao);
	glBindVertexArray(vao);
	glBindBuffer(GL_ARRAY_BUFFER, points_vbo);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glBindBuffer(GL_ARRAY_BUFFER, colours_vbo);
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, NULL);
	glEnableVertexAttribArray(0);
	glEnableVertexAttribArray(1);

	////float vertices[] = {
	////	// positions          // colors
	////	0.0f, -0.1f, 0.0f,		0.0f, 1.0f, 0.0f,										//A verde 0
	////	0.0f, -0.1f, 0.0f,		0.0f, 1.0f, 1.0f,										//A ciano 1
	////	0.0f, -0.1f, 0.0f,		1.0f, 0.0f, 1.0f,										//A roxo 2
	////	-0.2f, 0.2f, 0.0f,		1.0f, 0.0f, 0.0f,										//B vermelho 3
	////	-0.2f, 0.2f, 0.0f,		0.0f, 1.0f, 1.0f,										//B ciano 4
	////	-0.2f, 0.2f, 0.0f,		0.0f, 1.0f, 0.0f,										//B verde 5
	////	0.2f, 0.2f, 0.0f,		0.0f, 1.0f, 0.0f,										//C verde 6
	////	0.2f, 0.2f, 0.0f,		1.0f, 0.0f, 1.0f,										//C roxo 7
	////	0.2f, 0.2f, 0.0f,		0.0f, 0.0f, 1.0f,										//C azul 8
	////	-0.4f, -0.1f, 0.0f,		1.0f, 0.0f, 0.0f,										//D vermelho 9
	////	-0.4f, -0.1f, 0.0f,		0.0f, 1.0f, 1.0f,										//D ciano 10
	////	0.4f, -0.1f, 0.0f,		1.0f, 0.0f, 1.0f,										//E roxo 11
	////	0.4f, -0.1f, 0.0f,		0.0f, 0.0f, 1.0f,										//E azul 12
	////	-0.6f, 0.2f, 0.0f,		1.0f, 0.0f, 0.0f,										//F vermelho 13
	////	0.6f, 0.2f, 0.0f,		0.0f, 0.0f, 1.0f										//G azul 14
	////};

	//float vertices[] = {
	//	0.0f, -0.1f, 0.0f,		0.0f, 1.0f, 0.0f,
	//	-0.2f, 0.2f, 0.0f,		1.0f, 0.0f, 0.0f,
	//	0.2f, 0.2f, 0.0f,		0.0f, 1.0f, 0.0f,
	//	-0.4f, -0.1f, 0.0f,		1.0f, 0.0f, 0.0f,
	//	0.4f, -0.1f, 0.0f,		1.0f, 0.0f, 1.0f,
	//	-0.6f, 0.2f, 0.0f,		1.0f, 0.0f, 0.0f,
	//	0.6f, 0.2f, 0.0f,		0.0f, 0.0f, 1.0f
	//};


	//unsigned int indices[] = {
	//	3, 5, 1
	//	//9, 13, 3, // first triangle
	//	//1, 10, 4, // second triangle
	//	//0, 5, 6, // third triangle
	//	//11, 2, 7, // fourth triangle
	//	//12, 8, 14 // fifth triangle
	//};

	////unsigned int indices[] = {
	////	0, 1, 3, // first triangle
	////	1, 2, 3  // second triangle
	////};

	//unsigned int VBO, VAO, EBO;
	//glGenVertexArrays(1, &VAO);
	//glGenBuffers(1, &VBO);
	//glGenBuffers(1, &EBO);

	//glBindVertexArray(VAO);

	//glBindBuffer(GL_ARRAY_BUFFER, VBO);
	//glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

	//glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	//glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

	//// position attribute
	//glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)0);
	//glEnableVertexAttribArray(0);
	//// color attribute
	//glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(3 * sizeof(float)));
	//glEnableVertexAttribArray(1);

	char vertex_shader[1024 * 256];
	char fragment_shader[1024 * 256];
	parse_file_into_str("test_vs.glsl", vertex_shader, 1024 * 256);
	parse_file_into_str("test_fs.glsl", fragment_shader, 1024 * 256);

	GLuint vs = glCreateShader(GL_VERTEX_SHADER);
	const GLchar *p = (const GLchar *)vertex_shader;
	glShaderSource(vs, 1, &p, NULL);
	glCompileShader(vs);

	// check for compile errors
	int params = -1;
	glGetShaderiv(vs, GL_COMPILE_STATUS, &params);
	if (GL_TRUE != params) {
		fprintf(stderr, "ERROR: GL shader index %i did not compile\n", vs);
		print_shader_info_log(vs);
		return 1; // or exit or something
	}

	GLuint fs = glCreateShader(GL_FRAGMENT_SHADER);
	p = (const GLchar *)fragment_shader;
	glShaderSource(fs, 1, &p, NULL);
	glCompileShader(fs);

	// check for compile errors
	glGetShaderiv(fs, GL_COMPILE_STATUS, &params);
	if (GL_TRUE != params) {
		fprintf(stderr, "ERROR: GL shader index %i did not compile\n", fs);
		print_shader_info_log(fs);
		return 1; // or exit or something
	}

	GLuint shader_programme = glCreateProgram();
	glAttachShader(shader_programme, fs);
	glAttachShader(shader_programme, vs);
	glLinkProgram(shader_programme);

	glGetProgramiv(shader_programme, GL_LINK_STATUS, &params);
	if (GL_TRUE != params) {
		fprintf(stderr, "ERROR: could not link shader programme GL index %i\n",
			shader_programme);
		print_programme_info_log(shader_programme);
		return false;
	}

	GLfloat matrix[] = {
		1.0f, 0.0f, 0.0f, 0.0f, // first column
		0.0f, 1.0f, 0.0f, 0.0f, // second column
		0.0f, 0.0f, 1.0f, 0.0f, // third column
		0.0f, 0.0f, 0.0f, 1.0f	// fourth column
	};

	GLfloat matrix1[] = {
		1.0f, 0.0f, 0.0f, 0.0f, // first column
		0.0f, 1.0f, 0.0f, 0.0f, // second column
		0.0f, 0.0f, 1.0f, 0.0f, // third column
		-0.5f, -0.5f, 0.0f, 1.0f	// fourth column
	};

	float ang = (30 * (M_PI/180));
	float ang2 = (1 * (M_PI / 180));

	GLfloat matrix2[] = {
		cos(ang), -sin(ang), 0.0f, 0.0f, // first column
		sin(ang), cos(ang), 0.0f, 0.0f, // second column
		0.0f, 0.0f, 1.0f, 0.0f, // third column
		0.0f, 0.0f, 0.0f, 1.0f	// fourth column
	};

	GLfloat matrix3[] = {
		1.0f, 0.0f, 0.0f, 0.0f, // first column
		0.0f, 1.0f, 0.0f, 0.0f, // second column
		0.0f, 0.0f, 1.0f, 0.0f, // third column
		0.5f, 0.5f, 0.0f, 1.0f	// fourth column
	};

	//glm::mat4 matrix(
	//	1.0f, 0.0f, 0.0f, 0.0f, // first column
	//	0.0f, 1.0f, 0.0f, 0.0f, // second column
	//	0.0f, 0.0f, 1.0f, 0.0f, // third column
	//	0.0f, 0.0f, 0.0f, 1.0f	// fourth column
	//);

	//glm::mat4 matrix1(
	//	1.0f, 0.0f, 0.0f, 0.0f, // first column
	//	0.0f, 1.0f, 0.0f, 0.0f, // second column
	//	0.0f, 0.0f, 1.0f, 0.0f, // third column
	//	-0.5f, -0.5f, 0.0f, 1.0f	// fourth column
	//);

	//double ang = (30 * (M_PI / 180));

	//glm::mat4 matrix2(
	//	cos(ang), -sin(ang), 0.0f, 0.0f, // first column
	//	sin(ang), cos(ang), 0.0f, 0.0f, // second column
	//	0.0f, 0.0f, 1.0f, 0.0f, // third column
	//	0.0f, 0.0f, 0.0f, 1.0f	// fourth column
	//);

	//glm::mat4 matrix3(
	//	1.0f, 0.0f, 0.0f, 0.0f, // first column
	//	0.0f, 1.0f, 0.0f, 0.0f, // second column
	//	0.0f, 0.0f, 1.0f, 0.0f, // third column
	//	0.5f, 0.5f, 0.0f, 1.0f	// fourth column
	//);

	//glm::mat4 matrix = matrix3 * matrix2 * matrix1;


	int matrix_location = glGetUniformLocation(shader_programme, "matrix");
	glUseProgram(shader_programme);
	glUniformMatrix4fv(matrix_location, 1, GL_FALSE, (matrix));

	int matrix_location1 = glGetUniformLocation(shader_programme, "matrix1");
	glUseProgram(shader_programme);
	glUniformMatrix4fv(matrix_location1, 1, GL_FALSE, (matrix1));

	int matrix_location2 = glGetUniformLocation(shader_programme, "matrix2");
	glUseProgram(shader_programme);
	glUniformMatrix4fv(matrix_location2, 1, GL_FALSE, (matrix2));

	int matrix_location3 = glGetUniformLocation(shader_programme, "matrix3");
	glUseProgram(shader_programme);
	glUniformMatrix4fv(matrix_location3, 1, GL_FALSE, (matrix3));

	glEnable(GL_CULL_FACE); // cull face
	glCullFace(GL_BACK);		// cull back face
	glFrontFace(GL_CW);			// GL_CCW for counter clock-wise

	float speed = 1.0f; // move at 1 unit per second
	float last_position = 0.0f;
	while (!glfwWindowShouldClose(g_window)) {
		// add a timer for doing animation
		static double previous_seconds = glfwGetTime();
		double current_seconds = glfwGetTime();
		double elapsed_seconds = current_seconds - previous_seconds;
		previous_seconds = current_seconds;

		_update_fps_counter(g_window);
		// wipe the drawing surface clear
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glViewport(0, 0, g_gl_width, g_gl_height);

		//
		// Note: this call is not necessary, but I like to do it anyway before any
		// time that I call glDrawArrays() so I never use the wrong shader programme

		glUseProgram(shader_programme);

		// update the matrix
		// - you could simplify this by just using sin(current_seconds)

		/*matrix[12] = elapsed_seconds * speed + last_position;
		last_position = matrix[12];
		if (fabs(last_position) > 1.0) {
			speed = -speed;
		}*/

		//
		// Note: this call is related to the most recently 'used' shader programme
		glUniformMatrix4fv(matrix_location, 1, GL_FALSE, (matrix));

		//
		// Note: this call is not necessary, but I like to do it anyway before any
		// time that I call glDrawArrays() so I never use the wrong vertex data
		//glBindVertexArray(VAO);
		// draw points 0-3 from the currently bound VAO with current in-use shader
		glDrawArrays(GL_TRIANGLES, 0, 15);
		//glDrawElements(GL_TRIANGLES, 15, GL_UNSIGNED_INT, 0);
		// update other events like input handling
		glfwPollEvents();
		if (GLFW_PRESS == glfwGetKey(g_window, GLFW_KEY_ESCAPE)) {
			glfwSetWindowShouldClose(g_window, 1);
		}
		//else if (GLFW_PRESS == glfwGetKey(g_window, GLFW_KEY_TAB)) {
		//	matrix[0] = matrix[0] * 1.02;
		//	matrix[5] = matrix[5] * 1.02;
		//}
		//else if (GLFW_PRESS == glfwGetKey(g_window, GLFW_KEY_SPACE)) {
		//	matrix[0] = matrix[0] / 1.02;
		//	matrix[5] = matrix[5] / 1.02;
		//}
		////else if (GLFW_PRESS == glfwGetKey(g_window, GLFW_KEY_Q)) {
		////	matrix[] = matrix1[];
		////}
		else if (GLFW_PRESS == glfwGetKey(g_window, GLFW_KEY_R)) {
			matrix[0] = cos(ang2);
			matrix[1] = -sin(ang2);
			matrix[4] = sin(ang2);
			matrix[5] = cos(ang2);
			ang2 = ang2 + 0.3;
		}
		// put the stuff we've been drawing onto the display
		glfwSwapBuffers(g_window);
	}

	// close GL context and any other GLFW resources
	glfwTerminate();
	return 0;
}
