/* The header file for the Shape class. The Shape class is capable of drawing a variety of			
 * different shapes, including prisms, cylinders, cubes, cones and pyramids. It is also capable		
 * of drawing 2D shapes such as traingles, squares, and circles but this was not its original purpose 
 * so use with caution. This class is currently not capable of drawing spheres, so UVSphere was added 		
 * to the project in order to perform that task. The Shape created would dependo on the arguments   
 * passed to this class' constructor. 
 * 
 * Triangle bases/tops (both same shape) can be created if the number of horizontal fragments is 3.
 * Square bases/tops (both same shape) can be created if the number of horizontal fragments is 4. 
 * Pentagons/Hexagons/Octagons can be created if the number of horizontal fragments is equal to
 * 		their respective number of sides.
 * Pyramids and cones can be drawn if one of the radius provided is 0.
 * Cylinders can be drawn when a large amount of horizontal fragments are used along with a
 * 		height greater than 0.
 * 2D shapes can be drawn if height is set to 0, this class was not made for this so there might
 * 		be some problems with regards to how they look.													
 * 
 * The last two arguments, drawBase and drawTop can be used to determine whether the base or top 
 * are drawn respectively. For example, if you have a cylinder with dropTop as false then you will
 * get a cup. 																							*/

#include <iostream>
#include <string>
#include <vector>
#include <glm/glm.hpp>

#pragma once

class Shape {
private:
    unsigned int numVerticalSegments;
	unsigned int numHorizontalSegments;
	float radiusOne;
	float radiusTwo;
    float height;
	bool drawBase;
	bool drawTop;

	std::vector<glm::vec3> positions;
	std::vector<glm::vec2> textureCoords;
	std::vector<glm::vec3> normals;
	unsigned int numVertices;
	unsigned int numTriangles;
	unsigned int* triangleIndices;

public: 
    Shape(float radiusOne, float radiusTwo, float height, unsigned int vertSegs, unsigned int horizSegs, bool drawBase, bool drawTop) {
		this->radiusOne = radiusOne;
		this->radiusTwo = radiusTwo;
		this->height = height;
		this->numVerticalSegments = vertSegs;
		this->numHorizontalSegments = horizSegs;
		this->drawBase = drawBase;
		this->drawTop = drawTop;
	}

	glm::vec3* getPositions();
	glm::vec2* getTextureCoords();
	glm::vec3* getNormals();

	unsigned int getNumVertices();
	unsigned int getNumTriangles();

	unsigned int* getTriangleIndices();

	float getRadiusOne();
	float getRadiusTwo();
    float getHeight();
	bool getDrawBase();
	bool getDrawTop();
	unsigned int getNumVerticalSegments();
	unsigned int getNumHorizontalSegments();

	void setDrawBase(bool val) {
		drawBase = val;
	}

	void setDrawTop(bool val) {
		drawTop = val;
	}

	void save(const std::string filename);
};