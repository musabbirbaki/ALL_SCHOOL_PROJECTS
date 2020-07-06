/* This file contains the definitions of most of the Shape class' functions */

#include "Shape.h"

#define _USE_MATH_DEFINES
#include <math.h>
#include <fstream>

void Shape::save(const std::string filename) {

    std::vector<glm::vec3> positions;
    std::vector<glm::vec2> textureCoords;
    std::vector<glm::vec3> normals;

    std::vector<glm::vec3> botCirclePositions;
    std::vector<glm::vec3> topCirclePositions;

    std::vector<glm::vec2> botTextureCoords;
    std::vector<glm::vec2> topTextureCoords;

    std::vector<glm::vec3> botNormals;
    std::vector<glm::vec3> topNormals;

    glm::vec3 center(0, height/2, 0);
    
    // bottom object center
    botCirclePositions.push_back(glm::vec3(0, 0, 0));
    botTextureCoords.push_back(glm::vec2(0.5, 0.5));
    botNormals.push_back(glm::normalize(botCirclePositions[0] - center));

    // top object center
    topCirclePositions.push_back(glm::vec3(0, height, 0));
    topTextureCoords.push_back(glm::vec2(0.5, 0.5));
    topNormals.push_back(glm::normalize(topCirclePositions[0] - center));

    float maxRadians = 2 * M_PI;
    float radiansInc = maxRadians / (float)this->numHorizontalSegments;

    // Getting base/top coordinates
    for (float i = 0; i <= maxRadians; i+=radiansInc) {
        float x1 = this->radiusOne * sin(i);
        float y1 = 0;
        float z1 = this->radiusOne * cos(i);

        glm::vec3 pos(x1, y1, z1);
        botCirclePositions.push_back(pos);

        glm::vec3 normal = glm::normalize(pos - center);

        botNormals.push_back(normal);

        float x2 = this->radiusTwo * sin(i);
        float y2 = height;
        float z2 = this->radiusTwo * cos(i);

        glm::vec3 pos2(x2, y2, z2);
        topCirclePositions.push_back(pos2);
        glm::vec3 normal2 = glm::normalize(pos2 - center);
        topNormals.push_back(normal2);

        glm::vec2 uv1((x1 / this->radiusOne + 1) * 0.5, (z1 / this->radiusOne + 1) * 0.5);
        botTextureCoords.push_back(uv1);

        glm::vec2 uv2((x2 / this->radiusTwo + 1) * 0.5, (z2 / this->radiusTwo + 1) * 0.5);
        topTextureCoords.push_back(uv2);
    }

    for (unsigned int j = 0; j < botCirclePositions.size(); j++) {
        positions.push_back(botCirclePositions[j]);
        textureCoords.push_back(botTextureCoords[j]);
        normals.push_back(botNormals[j]);
    }

    for (unsigned int j = 0; j < topCirclePositions.size() ; j++) {
        positions.push_back(topCirclePositions[j]);
        textureCoords.push_back(topTextureCoords[j]);
        normals.push_back(topNormals[j]);
    }

    // ------------------------ Getting coordinates of the sides of the shape ------------------------ 
    unsigned int start = positions.size();
    float heightGrowth = height/((float)this->numVerticalSegments);
    float uGrowth = 1.0f/((float)this->numHorizontalSegments);
    float vGrowth = 1.0f/((float)this->numVerticalSegments);

    for (unsigned int i = 2; i < this->numHorizontalSegments+1; i++) {
      float xGrowthOne = (topCirclePositions[i - 1].x - botCirclePositions[i - 1].x) / (float)this->numVerticalSegments;
      float xGrowthTwo = (topCirclePositions[i].x - botCirclePositions[i].x) / (float)this->numVerticalSegments;

      float zGrowthOne = (topCirclePositions[i - 1].z - botCirclePositions[i - 1].z) / (float)this->numVerticalSegments;
      float zGrowthTwo = (topCirclePositions[i].z - botCirclePositions[i].z) / (float)this->numVerticalSegments;

      for (unsigned int j = 1; j < this->numVerticalSegments+1; j++) {
        glm::vec3 currentCenterOne(0, (j-1) * heightGrowth, 0);
        glm::vec3 currentCenterTwo(0, j * heightGrowth, 0);

        glm::vec3 t1v1(botCirclePositions[i - 1] + glm::vec3((j - 1) * xGrowthOne, 
                                                             (j - 1) * heightGrowth,
                                                             (j - 1) * zGrowthOne));
 
        glm::vec3 t1v2(botCirclePositions[i] + glm::vec3((j - 1) * xGrowthTwo, 
                                                         (j - 1) * heightGrowth,
                                                         (j - 1) * zGrowthTwo));

        glm::vec3 t1v3(botCirclePositions[i] + glm::vec3(j * xGrowthTwo, 
                                                         j * heightGrowth,
                                                         j * zGrowthTwo));

        positions.push_back(t1v1);
        positions.push_back(t1v2);
        positions.push_back(t1v3);
        
        textureCoords.push_back(glm::vec2((i-1) * uGrowth, (j-1) * vGrowth));
        textureCoords.push_back(glm::vec2(i * uGrowth, (j-1) * vGrowth));
        textureCoords.push_back(glm::vec2(i * uGrowth, j * vGrowth));

        normals.push_back(glm::normalize(t1v1 - currentCenterOne));
        normals.push_back(glm::normalize(t1v2 - currentCenterOne));
        normals.push_back(glm::normalize(t1v3 - currentCenterTwo));

        glm::vec3 t2v1(botCirclePositions[i] + glm::vec3(j * xGrowthTwo, 
                                                         j * heightGrowth, 
                                                         j * zGrowthTwo));

        glm::vec3 t2v2(botCirclePositions[i - 1] + glm::vec3(j * xGrowthOne,
                                                             j * heightGrowth,
                                                             j * zGrowthOne));

        glm::vec3 t2v3(botCirclePositions[i - 1] + glm::vec3((j - 1) * xGrowthOne, 
                                                             (j - 1) * heightGrowth, 
                                                             (j - 1) * zGrowthOne));

        positions.push_back(t2v1);
        positions.push_back(t2v2);
        positions.push_back(t2v3);

        textureCoords.push_back(glm::vec2(i * uGrowth, j * vGrowth));
        textureCoords.push_back(glm::vec2((i-1) * uGrowth, j * vGrowth));
        textureCoords.push_back(glm::vec2((i-1) * uGrowth, (j-1) * vGrowth));

        normals.push_back(glm::normalize(t2v1 - currentCenterTwo));
        normals.push_back(glm::normalize(t2v2 - currentCenterTwo));
        normals.push_back(glm::normalize(t2v3 - currentCenterOne));
      }
    }

    // End to start special case
    int i = this->numHorizontalSegments;

    float xGrowthOne = (topCirclePositions[1].x - botCirclePositions[1].x) / (float)this->numVerticalSegments;
    float xGrowthTwo = (topCirclePositions[i].x - botCirclePositions[i].x) / (float)this->numVerticalSegments;

    float zGrowthOne = (topCirclePositions[1].z - botCirclePositions[1].z) / (float)this->numVerticalSegments;
    float zGrowthTwo = (topCirclePositions[i].z - botCirclePositions[i].z) / (float)this->numVerticalSegments;

    for (unsigned int j = 1; j < this->numVerticalSegments+1; j++) {
        glm::vec3 t1v1(botCirclePositions[1] + glm::vec3((j - 1) * xGrowthOne, 
                                                         (j - 1) * heightGrowth,
                                                         (j - 1) * zGrowthOne));

        glm::vec3 t1v2(botCirclePositions[i] + glm::vec3((j - 1) * xGrowthTwo, 
                                                         (j - 1) * heightGrowth,
                                                         (j - 1) * zGrowthTwo));

        glm::vec3 t1v3(botCirclePositions[i] + glm::vec3(j * xGrowthTwo, 
                                                         j * heightGrowth,
                                                         j * zGrowthTwo));

        glm::vec3 currentCenterOne(0, (j-1) * heightGrowth, 0);
        glm::vec3 currentCenterTwo(0, j * heightGrowth, 0);

        positions.push_back(t1v1);
        positions.push_back(t1v2);
        positions.push_back(t1v3);

        textureCoords.push_back(glm::vec2(0, (j-1) * vGrowth));
        textureCoords.push_back(glm::vec2(1, (j-1) * vGrowth));
        textureCoords.push_back(glm::vec2(1, j * vGrowth));

        normals.push_back(glm::normalize(t1v1 - currentCenterOne));
        normals.push_back(glm::normalize(t1v2 - currentCenterOne));
        normals.push_back(glm::normalize(t1v3 - currentCenterTwo));

        glm::vec3 t2v1(botCirclePositions[i] + glm::vec3(j * xGrowthTwo, 
                                                                j * heightGrowth, 
                                                                j * zGrowthTwo));

        glm::vec3 t2v2(botCirclePositions[1] + glm::vec3(j * xGrowthOne,
                                                                    j * heightGrowth,
                                                                    j * zGrowthOne));

        glm::vec3 t2v3(botCirclePositions[1] + glm::vec3((j - 1) * xGrowthOne, 
                                                                    (j - 1) * heightGrowth, 
                                                                    (j - 1) * zGrowthOne));
        
        positions.push_back(t2v1);
        positions.push_back(t2v2);
        positions.push_back(t2v3);

        textureCoords.push_back(glm::vec2(1, j * vGrowth));
        textureCoords.push_back(glm::vec2(0, j * vGrowth));
        textureCoords.push_back(glm::vec2(0, (j-1) * vGrowth));

        normals.push_back(glm::normalize(t2v1 - currentCenterOne));
        normals.push_back(glm::normalize(t2v2 - currentCenterOne));
        normals.push_back(glm::normalize(t2v3 - currentCenterOne));
    }

    std::ofstream fileOut(filename.c_str());

    if (!fileOut.is_open()) {
        return;
    }

    for (unsigned int i = 0; i < positions.size(); i++) {
        fileOut << "v " << positions[i].x << " "  << positions[i].y << " "  << positions[i].z << std::endl;
    }

    for (unsigned int i = 0; i < textureCoords.size(); i++) {
        fileOut << "vt " << textureCoords[i].s << " "  << textureCoords[i].t << std::endl;
    }

    for (unsigned int i = 0; i < normals.size(); i++) {
        fileOut << "vn " << normals[i].x << " "  << normals[i].y << " "  << normals[i].z << std::endl;
    }

    unsigned int limit = botCirclePositions.size();
    for (unsigned int i = 1; i < limit; i++) {
        if (this->drawBase == 1) {
            fileOut << "f " << (i-1) << "/" << (i-1) << "/" << (i-1) << " ";
            fileOut << i << "/" << i << "/" << i << " ";
            fileOut << "0" << "/" << "0" << "/" << "0" << std::endl;
        }

        if (this->drawTop == 1) {
            fileOut << "f " << (limit + i-1) << "/" << (limit + i-1) << "/" << (limit + i-1) << " ";
            fileOut << (limit + i) << "/" << (limit + i) << "/" << (limit + i) << " ";
            fileOut << limit << "/" << limit << "/" << limit << std::endl;
        }
    }

    if (this->drawBase == 1) {
        fileOut << "f " << (limit - 1) << "/" << (limit - 1) << "/" << (limit - 1) << " ";
        fileOut << 1 << "/" << 1 << "/" << 1 << " ";
        fileOut << "0" << "/" << "0" << "/" << "0" << std::endl;
    }

    if (this->drawTop == 1) {
        fileOut << "f " << (limit * 2 - 1) << "/" << (limit * 2 - 1) << "/" << (limit * 2 - 1) << " ";
        fileOut << (limit + 1) << "/" << (limit + 1) << "/" << (limit + 1) << " ";
        fileOut << limit << "/" << limit << "/" << limit << std::endl;
    }

    for (unsigned int i = start; i < positions.size(); i+=3) {
        fileOut << "f " << i << "/" << i << "/" << i << " ";
        fileOut << (i + 1) << "/" << (i + 1) << "/" << (i + 1) << " ";
        fileOut << (i + 2) << "/" << (i + 2) << "/" << (i + 2) << std::endl;      
    }

    fileOut.close();
}

glm::vec3* Shape::getPositions() { 
    return this->positions.data(); 
}

glm::vec2* Shape::getTextureCoords() { 
    return this->textureCoords.data(); 
}

glm::vec3* Shape::getNormals() { 
    return this->normals.data(); 
}

float Shape::getRadiusOne() {
    return this->radiusOne;
}

float Shape::getRadiusTwo() {
    return this->radiusTwo;
}

float Shape::getHeight() {
    return this->height;
}

bool Shape::getDrawBase() {
    return this->drawBase;
}

bool Shape::getDrawTop() {
    return this->drawTop;
}

unsigned int Shape::getNumVertices() {
    return this->numVertices;
}

unsigned int Shape::getNumTriangles() {
    return this->numTriangles;
}

unsigned int Shape::getNumVerticalSegments() {
    return this->numVerticalSegments;
}

unsigned int Shape::getNumHorizontalSegments() {
    return this->numHorizontalSegments;
}

unsigned int* Shape::getTriangleIndices() {
    return this->triangleIndices;
}
