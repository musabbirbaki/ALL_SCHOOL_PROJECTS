/* File obtained from RandyFortier's CSCI3090U github 			*
 * Link: https://github.com/randyfortier/CSCI3090U_Examples		*/

#include <string>
#include <iostream>
#include <fstream>

#include <GL/glew.h>

#pragma once
class ShaderProgram {
private:
	std::string vertexShaderCode;
	std::string fragmentShaderCode;
	GLuint vertexShaderId;
	GLuint fragmentShaderId;
	GLuint programId;

	GLuint loadShader(const GLenum shaderType, const std::string shaderFilename);

public:
	ShaderProgram();
	GLuint loadShaders(const std::string vertexShaderFilename, const std::string fragmentShaderFilename);
	std::string getVertexShaderCode();
	std::string getFragmentShaderCode();
	GLuint getVertexShaderId();
	GLuint getFragmentShaderId();
	GLuint getProgramId();
};
