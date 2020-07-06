/* A large part of the code in this file was obtained from RandyFortier's CSCI3090U github 			*
 * Link: https://github.com/randyfortier/CSCI3090U_Examples		                                  */

#include <string>
#include <iostream>
#include <cmath>
#include <GL/glew.h>
#ifdef __APPLE__
#  include <GLUT/glut.h>
#else
#  include <GL/glut.h>
#endif

#define GLM_ENABLE_EXPERIMENTAL
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtx/transform.hpp>

#define STB_IMAGE_IMPLEMENTATION
#include "apis/stb_image.h"

#include "ShaderProgram.h"
#include "ObjMesh.h"
#include "Shape.h"
#include "UVSphere.h"
#include "BezierPath.h"

#define SCALE_FACTOR 2.0f

int width, height;

// Shader Program IDs
GLuint programId;
GLuint enemyProgramId;
GLuint lightProgramId;
GLuint dimObjectProgramId;

// ObjMesh class declaration that will be reused multiple times
ObjMesh mesh;

// Texture IDs
GLuint texture_id_ground;
GLuint texture_id_hat;
GLuint texture_id_base;
GLuint texture_id_sphere;
GLuint texture_id_enemy_base;

// Ground
GLuint indexBuffer;
GLuint positions_vbo = 0;
GLuint textureCoords_vbo = 0;
GLuint normals_vbo = 0;
unsigned int numVertices;

// Hat
GLuint hat_indexBuffer;
GLuint hat_positions_vbo = 0;
GLuint hat_textureCoords_vbo = 0;
GLuint hat_normals_vbo = 0;
unsigned int hat_numVertices;

// Base
GLuint base_indexBuffer;
GLuint base_positions_vbo = 0;
GLuint base_textureCoords_vbo = 0;
GLuint base_normals_vbo = 0;
unsigned int base_numVertices;

// Sphere
GLuint sphere_indexBuffer;
GLuint sphere_positions_vbo = 0;
GLuint sphere_textureCoords_vbo = 0;
GLuint sphere_normals_vbo = 0;
unsigned int sphere_numVertices;

// Enemy Shadow
GLuint enemy_shadow_indexBuffer;
GLuint enemy_shadow_positions_vbo = 0;
GLuint enemy_shadow_textureCoords_vbo = 0;
GLuint enemy_shadow_normals_vbo = 0;
unsigned int enemy_shadow_numVertices;

// Enemy Base
GLuint enemy_base_indexBuffer;
GLuint enemy_base_positions_vbo = 0;
GLuint enemy_base_textureCoords_vbo = 0;
GLuint enemy_base_normals_vbo = 0;
unsigned int enemy_base_numVertices;

// PLAYER BEZIER PATH
float player_height = 0.0f;
const int player_jumps = 2;
const int player_segments = 50;
const int player_num_vertices = player_jumps * player_segments;
const float player_jump_height = 5.0f;
static GLfloat player_path_vertices[player_num_vertices * 3];
BezierPath player_path(player_jumps, player_segments, player_jump_height, 1.0f);

// ENEMY BEZIER PATH 
float enemy_one_height = 0.0f;
const int enemy_one_jumps = 4;
const int enemy_one_segments = 50;
const int enemy_one_num_vertices = enemy_one_jumps * enemy_one_segments;
const float enemy_one_jump_height = 5.0f;
static GLfloat enemy_one_path_vertices[enemy_one_num_vertices * 3];
BezierPath enemy_one_path(enemy_one_jumps, enemy_one_segments, enemy_one_jump_height, 1.0f);

// Vectors used to keep track of player and enemy models
glm::vec3 playerCoord;
glm::vec3 enemyCoord;

// Colors
glm::vec3 object_color(0.0f, 0.3f, 0.0f);
glm::vec3 whiteColor(0.9f, 0.9f, 0.9f);

// Center position vector
glm::vec4 centerPosition = glm::vec4( glm::vec3( 0.0f ), 1.0f );

bool moving = false;
float xAngle = 0.0f;
float yAngle = 0.0f;
float zAngle = 0.0f;

float moveX = 0.0f;
float moveY = 0.0f;

// Bezier Translation coordinates
float bezierXCord = 0.0f;
float bezierYCord = 0.0f;
float bezierZCord = 0.0f;
float bezierMovingSpeed = 50.0f; // Higher is slower.
bool translateObject = true; // Enable Bezier curve path follow

// Bezier Translation coordinates
bool enemy_one_active = true;
bool enemy_one_collision_count = 0;
float bezierXCord_enemy_one = 0.0f;
float bezierYCord_enemy_one = 0.0f;
float bezierZCord_enemy_one = 0.0f;
float bezier_enemy_one_MovingSpeed = 50.0f; // Higher is slower.

glm::vec3 eyePosition(60, 60, 60);
glm::vec3 rotationAxis(0,1,0);

float scaleFactor = 1.0f;
float modelScale = 1.0f;

float lastX = std::numeric_limits<float>::infinity();
float lastY = std::numeric_limits<float>::infinity();

// A function that setsBuffers right after a mesh is loaded in the createGeometry function
void setBuffers(ObjMesh mesh, GLuint* positions, GLuint* textureCoords, GLuint* normals, GLuint* indices) {
  unsigned int numVertices = mesh.getNumIndexedVertices();

  Vector3* vertexPositions = mesh.getIndexedPositions();
  Vector2* vertexTextureCoords = mesh.getIndexedTextureCoords();
  Vector3* vertexNormals = mesh.getIndexedNormals();

  unsigned int* indexData = mesh.getTriangleIndices();
  int numTriangles = mesh.getNumTriangles();

  glGenBuffers(1, positions);
  glBindBuffer(GL_ARRAY_BUFFER, *positions);
  glBufferData(GL_ARRAY_BUFFER, numVertices * sizeof(Vector3), vertexPositions, GL_STATIC_DRAW);

  glGenBuffers(1, textureCoords);
  glBindBuffer(GL_ARRAY_BUFFER, *textureCoords);
  glBufferData(GL_ARRAY_BUFFER, numVertices * sizeof(Vector2), vertexTextureCoords, GL_STATIC_DRAW);

  glGenBuffers(1, normals);
  glBindBuffer(GL_ARRAY_BUFFER, *normals);
  glBufferData(GL_ARRAY_BUFFER, numVertices * sizeof(Vector3), vertexNormals, GL_STATIC_DRAW);

  glGenBuffers(1, indices);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, *indices);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(unsigned int) * numTriangles * 3, indexData, GL_STATIC_DRAW);
}

// Function that sets buffers in the render function as well as draws the object's whose variables
// were passed into it.
void setBuffersAndDraw(unsigned int numVertices, GLuint* positions_vbo, GLuint* textureCoords_vbo, GLuint* normals_vbo, GLuint* indexBuffer, GLuint* programId) {
  GLint positionAttribId = glGetAttribLocation(*programId, "position");
  GLint textureCoordsAttribId = glGetAttribLocation(*programId, "textureCoords");
  GLint normalAttribId = glGetAttribLocation(*programId, "normal");

  glBindBuffer(GL_ARRAY_BUFFER, *positions_vbo);
  glEnableVertexAttribArray(positionAttribId);
  glVertexAttribPointer(positionAttribId, 3, GL_FLOAT, GL_FALSE, 0, nullptr);

  glBindBuffer(GL_ARRAY_BUFFER, *textureCoords_vbo);
  glEnableVertexAttribArray(textureCoordsAttribId);
  glVertexAttribPointer(textureCoordsAttribId, 2, GL_FLOAT, GL_FALSE, 0, nullptr);

  glBindBuffer(GL_ARRAY_BUFFER, *normals_vbo);
  glEnableVertexAttribArray(normalAttribId);
  glVertexAttribPointer(normalAttribId, 3, GL_FLOAT, GL_FALSE, 0, nullptr);

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, *indexBuffer);
  glDrawElements(GL_TRIANGLE_STRIP, numVertices, GL_UNSIGNED_INT, (void*)0);

  glDisableVertexAttribArray(positionAttribId);
  glDisableVertexAttribArray(textureCoordsAttribId);
  glDisableVertexAttribArray(normalAttribId);
}

// Lecture 10B createTexture function modified to take a texture ID as an argument instead
// of the texture id being hard coded.
static void createTexture(std::string filename, GLuint* texture_id) {
   int imageWidth, imageHeight;
   int numComponents;

   // Load the image data into a bitmap
   unsigned char *bitmap = stbi_load(filename.c_str(),
                                     &imageWidth,
                                     &imageHeight,
                                     &numComponents, 4);

   // Generate a texture name
   glGenTextures(1, texture_id);

   // Make the texture active
   glBindTexture(GL_TEXTURE_2D, *texture_id);

   // Make a texture mip map
   glGenerateTextureMipmap(*texture_id);
   glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);

   // Specify the functions to use when shrinking/enlarging the texture image
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);

   // Specify the tiling parameters
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

   // Send the data to OpenGL
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, imageWidth, imageHeight,
                0, GL_RGBA, GL_UNSIGNED_BYTE, bitmap);

   // Bind the texture to unit 0
   glBindTexture(GL_TEXTURE_2D, *texture_id);
   glActiveTexture(GL_TEXTURE0);

   // Free the bitmap data
   stbi_image_free(bitmap);
}

// Function Declaration
void getModel (glm::mat4 &model, float xAngle, float yAngle, float zAngle, 
                                float xTrans, float yTrans, float zTrans, 
                                float xScale, float yScale, float zScale);
void setObjectColorInShader(GLuint &object, char* shaderObj, int program, glm::vec3 &color);

// This function runs when player and enemy collision happens
void at_enemy_player_collision(){
  float xCollisionEps = abs(playerCoord.x - enemyCoord.x);
  float yCollisionEps = abs(playerCoord.y - enemyCoord.y);
  float zCollisionEps = abs(playerCoord.z - enemyCoord.z);
  if(xCollisionEps < 0.5f && zCollisionEps < 0.5f){
    if (enemy_one_collision_count == 0) {
      enemy_one_collision_count = enemy_one_collision_count + 1;
    } else {
      enemy_one_active = false;
      createTexture("textures/win.png", &texture_id_ground);
    }
  }
}

// Helper functions

// This function sets up the model matrix for the object using values in param.
void setModelMatrix (glm::mat4 &model, float xAngle, float yAngle, float zAngle, glm::vec3 xAxis, glm::vec3 yAxis, glm::vec3 zAxis, 
                                float xTrans, float yTrans, float zTrans, 
                                float xScale, float yScale, float zScale){
  model = glm::rotate(model, glm::radians(xAngle), xAxis); // Rotate about the x-axis
  model = glm::rotate(model, glm::radians(yAngle), yAxis); // Rotate about the y-axis
  model = glm::rotate(model, glm::radians(zAngle), zAxis); // Rotate about the z-axis  
  model = glm::translate(model, glm::vec3(xTrans, yTrans, zTrans));
  model = glm::scale(model, glm::vec3(scaleFactor * xScale, scaleFactor * yScale, scaleFactor * zScale));
}

// This function sets the object color from the shader in program using color param.
void setObjectColorInShader(GLuint &object, char* shaderObj, int program, glm::vec3 &color){
  object = glGetUniformLocation(program, shaderObj);
  glUniform3f(object, color.x, color.y, color.z);
}

// A function that finds the vertices of a single bezier curve given the control points (in path).
// This function is designed to find and set vertices of multiple bezier curves, so it stores its values in an
// array (vertices) which will hold all the vertices in the full path (that consists of bezier curves). It will
// take an integer (start) as an argument which determines at which index of vertices the current curve
// (represented by the variables in the BezierPath class argument path) starts at.
void getVertices (int start, BezierPath path, GLfloat* vertices) {
  int counter = start; 
  float stepSize = 1.0/(float)path.getNumSegments();

  for (float i = 0; i <= 1; i+=stepSize) {
    GLfloat x = pow((1.0 - i), 3) * path.getC1().x + pow((1.0 - i), 2) * 3 * i * path.getC2().x + (1.0 - i) * 3 * pow(i, 2) * path.getC3().x + pow(i, 3) * path.getC4().x;
    GLfloat y = pow((1.0 - i), 3) * path.getC1().y + pow((1.0 - i), 2) * 3 * i * path.getC2().y + (1.0 - i) * 3 * pow(i, 2) * path.getC3().y + pow(i, 3) * path.getC4().y;
    GLfloat z = pow((1.0 - i), 3) * path.getC1().z + pow((1.0 - i), 2) * 3 * i * path.getC2().z + (1.0 - i) * 3 * pow(i, 2) * path.getC3().z + pow(i, 3) * path.getC4().z;
    *(vertices + counter * 3) = x;
    *(vertices + counter * 3 + 1) = y;
    *(vertices + counter * 3 + 2) = z;
    counter++;
  }  
}

/* Given some initial values stored in path and a vector of points, this function will create and set
 * the vertices of multiple bezier curves going from adjacent points (including the last to first). For
 * example, if the jumpCoordinates were J1, J2 and J3 then curves will be found from J1 to J2, J2 to J3
 * and J3 to J1, the shape of the curve will be determined by some values already set in the BezierPath
 * class argument (path). The vertices of these curves will be stored in the argument called vertices. */
void getJumpVertices(std::vector<glm::vec3> jumpCoordinates, BezierPath path, GLfloat* vertices) {
  int numCoordinates = jumpCoordinates.size(); 
  glm::vec3 temp;

  for (int i = 1; i < numCoordinates; i++) {    
    // The current jump starting location
    temp = jumpCoordinates[i-1];
    path.setC1(temp);

    // The current jump landing location
    temp = jumpCoordinates[i];
    path.setC4(temp);

    temp.x = path.getC1().x + (path.getC4().x - path.getC1().x) / 3;
    temp.y = path.getC1().y + path.getJumpHeight();
    temp.z = path.getC1().z + (path.getC4().z - path.getC1().z) / 3;
    path.setC2(temp);

    temp.x = path.getC2().x + (path.getC4().x - path.getC1().x) / 3;
    temp.y = path.getC4().y + path.getJumpHeight() * path.getCurveType();
    temp.z = path.getC2().z + (path.getC4().z - path.getC1().z) / 3;
    path.setC3(temp);

    getVertices(path.getNumSegments() * (i - 1), path, vertices);
  }   
    // The jump starting location (last point)
    temp = jumpCoordinates[numCoordinates - 1];
    path.setC1(temp);

    // The jump landing location (first point)
    temp = jumpCoordinates[0];
    path.setC4(temp);

    temp.x = path.getC1().x + (path.getC4().x - path.getC1().x) / 3;
    temp.y = path.getC1().y + path.getJumpHeight();
    temp.z = path.getC1().z + (path.getC4().z - path.getC1().z) / 3;
    path.setC2(temp);

    temp.x = path.getC2().x + (path.getC4().x - path.getC1().x) / 3;
    temp.y = path.getC4().y + path.getJumpHeight() * path.getCurveType();
    temp.z = path.getC2().z + (path.getC4().z - path.getC1().z) / 3;
    path.setC3(temp);

    getVertices(path.getNumSegments() * (path.getNumJumps() - 1) - 1, path, vertices);
}

static void createGeometry(void) {
  //-------------ENEMY BEZIER PATH-------------
  std::vector<glm::vec3> points;
  points.push_back(glm::vec3(-12, 0, 12));
  points.push_back(glm::vec3(12, 0, 12));
  points.push_back(glm::vec3(12, 0, -12));
  points.push_back(glm::vec3(-12, 0, -12));

  getJumpVertices(points, enemy_one_path, enemy_one_path_vertices);

  //-----------End of ENEMY BEZIER PATH---------
    
  //------------------------------GROUND-----------------------------------------------------------------
  // Radius 1, Radius 2, Height, # of Vertical Segments, # of Horizontal Segments, Draw Base?, Draw Top?
  Shape ground(10.0, 10.0, 1.0, 40, 40, false, true);
  ground.save("objects/my_ground.obj");

  std::cout << "\nFinished generating ground geometry." << std::endl;
  mesh.load("objects/my_ground.obj", true, true);
  std::cout << "Finished loading ground .obj file.\n" << std::endl;

  numVertices = mesh.getNumIndexedVertices();
  setBuffers(mesh, &positions_vbo, &textureCoords_vbo, &normals_vbo, &indexBuffer);

  //--------------------------------------PLAYER--------------------------------------
  //---------------------------------------HAT----------------------------------------
  // Radius 1, Radius 2, Height, # of Vertical Segments, # of Horizontal Segments, Draw Base?, Draw Top?
  Shape hat(2.0, 0.0, 3.0, 30, 30, true, true);
  hat.save("objects/my_hat.obj");

  std::cout << "Finished generating sphere geometry." << std::endl;
  mesh.load("objects/my_hat.obj", true, true);
  std::cout << "Finished loading sphere .obj file.\n" << std::endl;

  hat_numVertices = mesh.getNumIndexedVertices();
  setBuffers(mesh, &hat_positions_vbo, &hat_textureCoords_vbo, &hat_normals_vbo, &hat_indexBuffer);

  //------------------------------------------BASE---------------------------------------------
  // Radius 1, Radius 2, Height, # of Vertical Segments, # of Horizontal Segments, Draw Base?, Draw Top?
  Shape base(1.2, 0.7, 5.0f, 30, 30, true, true);
  base.save("objects/my_base.obj");

  std::cout << "Finished generating base geometry." << std::endl;
  mesh.load("objects/my_base.obj", true, true);
  std::cout << "Finished loading base .obj file.\n" << std::endl;

  base_numVertices = mesh.getNumIndexedVertices();
  setBuffers(mesh, &base_positions_vbo, &base_textureCoords_vbo, &base_normals_vbo, &base_indexBuffer);

  //-------------------------------------SPHERE (HEAD)------------------------------------------
  UVSphere head(1, 20, 20);
  head.save("objects/my_sphere.obj");

  std::cout << "Finished generating sphere geometry." << std::endl;
  mesh.load("objects/my_sphere.obj", true, true);
  std::cout << "Finished loading sphere .obj file.\n" << std::endl;

  sphere_numVertices = mesh.getNumIndexedVertices();
  setBuffers(mesh, &sphere_positions_vbo, &sphere_textureCoords_vbo, &sphere_normals_vbo, &sphere_indexBuffer);

  //---------------------------------------PLAYER ENDS HERE---------------------------------------

  //--------------------------------------------ENEMY---------------------------------------------
  //-----------------------------------------ENEMY SHADOW-----------------------------------------
  // Radius 1, Radius 2, Height, # of Vertical Segments, # of Horizontal Segments, Draw enemy_base?, Draw Top?
  Shape enemy_shadow(1.0, 1.0, 0.0, 0, 20, true, true);
  enemy_shadow.save("objects/my_enemy_shadow.obj");

  std::cout << "Finished generating sphere geometry." << std::endl;
  mesh.load("objects/my_enemy_shadow.obj", true, true);
  std::cout << "Finished loading sphere .obj file.\n" << std::endl;

  enemy_shadow_numVertices = mesh.getNumIndexedVertices();
  setBuffers(mesh, &enemy_shadow_positions_vbo, &enemy_shadow_textureCoords_vbo, &enemy_shadow_normals_vbo, &enemy_shadow_indexBuffer);

  //------------------------------------------ENEMY BASE------------------------------------------
  // Radius 1, Radius 2, Height, # of Vertical Segments, # of Horizontal Segments, Draw enemy_base?, Draw Top?
  Shape enemy_base(1.0, 1.0, 4.0f, 30, 30, true, true);
  enemy_base.save("objects/my_enemy_base.obj");

  std::cout << "Finished generating enemy_base geometry." << std::endl;
  mesh.load("objects/my_enemy_base.obj", true, true);
  std::cout << "Finished loading enemy_base .obj file.\n" << std::endl;

  enemy_base_numVertices = mesh.getNumIndexedVertices();
  setBuffers(mesh, &enemy_base_positions_vbo, &enemy_base_textureCoords_vbo, &enemy_base_normals_vbo, &enemy_base_indexBuffer);

  //---------------------------------------ENEMY ENDS HERE-----------------------------------------

}

static void update(void) {
    int milliseconds = glutGet(GLUT_ELAPSED_TIME);

    if(translateObject){
      int i = (int)((float) milliseconds / bezierMovingSpeed) % (player_num_vertices - 1); //i changes by time

        bezierXCord = player_path_vertices[i * 3];
        bezierYCord = 3.0f;        
        bezierZCord = player_path_vertices[i * 3 + 2];

    }

    if(translateObject){
      int i = (int)((float) milliseconds / bezierMovingSpeed) % (enemy_one_num_vertices - 1); //i changes by time
        bezierXCord_enemy_one = enemy_one_path_vertices[i * 3];
        bezierYCord_enemy_one = enemy_one_path_vertices[i * 3 + 1];
        bezierZCord_enemy_one = enemy_one_path_vertices[i * 3 + 2];
    }

    if (enemy_one_active) {
      at_enemy_player_collision();
    }

    glutPostRedisplay();
}


static void render(void) {

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  // Activate our shader program
	glUseProgram(programId);

  // Turn on depth buffering
  glEnable(GL_DEPTH_TEST);

  // Declaring view and projection
  float aspectRatio = (float)width / (float)height;
  glm::mat4 projection = glm::perspective(glm::radians(20.0f), aspectRatio, 0.2f, 1000.0f);

  // View matrix - orient everything around our preferred view
  glm::mat4 view = glm::lookAt(
      eyePosition,
      glm::vec3(0,0,0),    // where to look
      glm::vec3(0,1,0)     // up
  );


  //----------------------------------------PLAYER MOVEMENT PATH----------------------------------------
  std::vector<glm::vec3> points;
  points.push_back(glm::vec3(moveX, 0, moveY));
  points.push_back(glm::vec3(moveX, 0, moveY));
  getJumpVertices(points, player_path, player_path_vertices);
  points.pop_back();
  points.pop_back();  


  //-----------------------------------------GROUND------------------------------------------------------
  // Texture uniform ID for ground
  GLuint textureUniformId = glGetUniformLocation(programId, "textureSampler");

  glUseProgram(programId);

  // Color Vectors
  object_color = glm::vec3(1.0f, 1.0f, 1.0f);

  // Object Color
  GLuint ground_objectColor;
  GLuint ground_lightColor;
  setObjectColorInShader(ground_objectColor, "objectColor", programId, object_color);
  setObjectColorInShader(ground_lightColor, "lightColor", programId, whiteColor);

  // Model matrix: translate, scale, and rotate the model
  float ground_model_scale_factor = 100;
  glm::mat4 ground_model = glm::mat4(1.0f);
  setModelMatrix (ground_model, xAngle, yAngle, zAngle, glm::vec3(1, 0, 0), glm::vec3(0, 1, 0), glm::vec3(0, 0, 1),
                                0.0f, 2.0f, 0.0f, 
                                ground_model_scale_factor, 1.0f, ground_model_scale_factor);

  // Model-view-projection matrix
  glm::mat4 mvp = projection * view * ground_model;
  GLuint mvpMatrixId = glGetUniformLocation(programId, "u_MVP");
  glUniformMatrix4fv(mvpMatrixId, 1, GL_FALSE, &mvp[0][0]);

  // Ground texture  
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, texture_id_ground);
  glUniform1i(textureUniformId, 0);

  setBuffersAndDraw(numVertices, &positions_vbo, &textureCoords_vbo, &normals_vbo, &indexBuffer, &programId);

  // Getting light's position using the Model matrix.
  GLfloat lightHeight = 2.50f;
  GLuint lightPos = glGetUniformLocation(programId, "lightPos");
  glUniform3f(lightPos, playerCoord.x, lightHeight, playerCoord.z);

  //------------------------------------END OF GROUND------------------------------------

  //------------------------------------PLAYER RENDER------------------------------------
  //-----------------------------------------HAT-----------------------------------------
  textureUniformId = glGetUniformLocation(lightProgramId, "textureSampler");

  glUseProgram(lightProgramId);

  //Color Vectors
  object_color = glm::vec3(1.0f, 0.3f, 0.3f);

  //Object Color
  GLuint hat_objectColor;
  GLuint hat_lightColor;
  setObjectColorInShader(hat_objectColor, "objectColor", lightProgramId, object_color);
  setObjectColorInShader(hat_lightColor, "lightColor", lightProgramId, whiteColor);

  float hat_model_scale_factor = 1.5f;
  glm::mat4 hat_model = glm::mat4(1.0f);

  setModelMatrix (hat_model, xAngle, yAngle, zAngle,  glm::vec3(bezierYCord/hat_model_scale_factor, 0, 0), glm::vec3(0, bezierYCord/hat_model_scale_factor, 0), glm::vec3(0, 0, bezierYCord/hat_model_scale_factor),
  0.0f, 3.0f, 0.0f, 
  hat_model_scale_factor, hat_model_scale_factor, hat_model_scale_factor);

  // Transformations matrix
  glm::mat4 hat_model_transformations = glm::mat4(1.0f);
  hat_model_transformations = glm::translate(hat_model_transformations, glm::vec3(bezierXCord/hat_model_scale_factor, bezierYCord/hat_model_scale_factor, bezierZCord/hat_model_scale_factor));

  // Model-view-projection matrix
  glm::mat4 hat_mvp = projection * view * hat_model * hat_model_transformations;
  GLuint hat_mvpMatrixId = glGetUniformLocation(lightProgramId, "u_MVP");
  glUniformMatrix4fv(hat_mvpMatrixId, 1, GL_FALSE, &hat_mvp[0][0]);

  // Hat texture  
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, texture_id_hat);
  glUniform1i(textureUniformId, 0);

  setBuffersAndDraw(hat_numVertices, &hat_positions_vbo, &hat_textureCoords_vbo, &hat_normals_vbo, &hat_indexBuffer, &lightProgramId);

  //--------------------------------------END OF HAT--------------------------------------


  //-----------------------------------------BASE-----------------------------------------
  glUseProgram(lightProgramId);

  // Object Color
  GLuint base_objectColor;
  GLuint base_lightColor;
  setObjectColorInShader(base_objectColor, "objectColor", lightProgramId, object_color);
  setObjectColorInShader(base_lightColor, "lightColor", lightProgramId, object_color);

  // Placement and size. This also allows mouse movment view.
  float scale_multiplier = 6.0f;
  glm::mat4 base_model = glm::mat4(1.0f);
  setModelMatrix(base_model, xAngle, yAngle, zAngle, glm::vec3(1, 0, 0), glm::vec3(0, 1, 0), glm::vec3(0, 0, 1),
                                0.0f, 0.5f, 0.0, 
                                scale_multiplier, 1.0f, scale_multiplier);

  // Transformations matrix
  glm::mat4 base_model_transformations = glm::mat4(1.0f);
  base_model_transformations = glm::translate(base_model_transformations, glm::vec3(bezierXCord/scale_multiplier, bezierYCord, bezierZCord/scale_multiplier));

  // Update player cord
  playerCoord = glm::vec3(bezierXCord/scale_multiplier, bezierYCord, bezierZCord/scale_multiplier);

  // Model-view-projection matrix
  glm::mat4 base_mvp = projection * view * base_model * base_model_transformations;
  GLuint base_mvpMatrixId = glGetUniformLocation(lightProgramId, "u_MVP");
  glUniformMatrix4fv(base_mvpMatrixId, 1, GL_FALSE, &base_mvp[0][0]);

  // Cylinder texture  
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, texture_id_base);
  glUniform1i(textureUniformId, 0);

  setBuffersAndDraw(base_numVertices, &base_positions_vbo, &base_textureCoords_vbo, &base_normals_vbo, &base_indexBuffer, &lightProgramId);

  //-------------------------------------------END OF BASE-------------------------------------------

  //------------------------------------------SPHERE (HEAD)------------------------------------------
  textureUniformId = glGetUniformLocation(lightProgramId, "textureSampler");

  glUseProgram(lightProgramId);

  // Color Vectors
  object_color = glm::vec3(0.3f, 0.3f, 0.3f);

  // Object Color
  GLuint sphere_objectColor = glGetUniformLocation(lightProgramId, "objectColor");
  glUniform3f(sphere_objectColor, object_color.x, object_color.y, object_color.z);

  // Light Color
  GLuint sphere_lightColor = glGetUniformLocation(lightProgramId, "lightColor");
  glUniform3f(sphere_lightColor, whiteColor.x ,whiteColor.y ,whiteColor.z);

  // View Position
  GLuint viewPos = glGetUniformLocation(lightProgramId, "viewPos");
  glUniform3f(viewPos, eyePosition.x ,eyePosition.y ,eyePosition.z);

  // Light Model matrix
  float sphere_model_scale_factor = 2.0f;
  glm::mat4 sphere_model = glm::mat4(1.0f);
  setModelMatrix(sphere_model, xAngle, yAngle, zAngle, glm::vec3(1, 0, 0), glm::vec3(0, 1, 0), glm::vec3(0, 0, 1),
                                0.0f, 2.0f, 0.0f, 
                                sphere_model_scale_factor, sphere_model_scale_factor, sphere_model_scale_factor);

  // Transformations matrix
  glm::mat4 sphere_model_transformations = glm::mat4(1.0f);
  sphere_model_transformations = glm::translate(sphere_model_transformations, glm::vec3(bezierXCord/sphere_model_scale_factor, bezierYCord/sphere_model_scale_factor, bezierZCord/sphere_model_scale_factor));

  glm::mat4 result_model = sphere_model * sphere_model_transformations;

  // Model-view-projection matrix
  glm::mat4 sphere_mvp = projection * view * result_model;
  GLuint sphere_mvpMatrixId = glGetUniformLocation(lightProgramId, "u_MVP");
  glUniformMatrix4fv(sphere_mvpMatrixId, 1, GL_FALSE, &sphere_mvp[0][0]);

  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, texture_id_sphere);
  glUniform1i(textureUniformId, 0);

  setBuffersAndDraw(enemy_base_numVertices, &sphere_positions_vbo, &sphere_textureCoords_vbo, &sphere_normals_vbo, &sphere_indexBuffer, &lightProgramId);
  
  //---------------------------SPHERE (HEAD) ENDS HERE----------------------------
  //---------------------------PLAYER RENDER ENDS HERE----------------------------

  //---------------------------------ENEMY RENDER---------------------------------
  //---------------------------------ENEMY SHADOW---------------------------------

  glUseProgram(dimObjectProgramId);

  // Color Vectors
  object_color = glm::vec3(0.0f, 0.0f, 0.0f);

  // Object Color
  GLuint enemy_shadow_objectColor;
  GLuint enemy_shadow_lightColor;
  setObjectColorInShader(enemy_shadow_objectColor, "objectColor", dimObjectProgramId, object_color);
  setObjectColorInShader(enemy_shadow_lightColor, "lightColor", dimObjectProgramId, whiteColor);

  // Model matrix: translate, scale, and rotate the model
  float enemy_shadow_model_scale_factor = 3.0f;
  glm::mat4 enemy_shadow_model = glm::mat4(1.0f);

  setModelMatrix (enemy_shadow_model, xAngle, yAngle, zAngle,  glm::vec3(bezierYCord/enemy_shadow_model_scale_factor, 0, 0), glm::vec3(0, 1.0/enemy_shadow_model_scale_factor, 0), glm::vec3(0, 0, bezierYCord/enemy_shadow_model_scale_factor),
  0.0f, 2.03f, 0.0f, 
  enemy_shadow_model_scale_factor, enemy_shadow_model_scale_factor, enemy_shadow_model_scale_factor);

  // Transformations matrix
  glm::mat4 enemy_shadow_model_transformations = glm::mat4(1.0f);
  enemy_shadow_model_transformations = glm::translate(enemy_shadow_model_transformations, glm::vec3(bezierXCord_enemy_one/enemy_shadow_model_scale_factor, 0, bezierZCord_enemy_one/enemy_shadow_model_scale_factor));

  enemy_one_height = bezierYCord_enemy_one;
  if(bezierYCord_enemy_one < 1.0f){
    enemy_one_height = 1.0f;
  }else if(bezierYCord_enemy_one > 5.0f){
    enemy_one_height = 5.0f;
  }

  enemy_shadow_model_transformations = glm::scale(enemy_shadow_model_transformations, glm::vec3(1.0f/enemy_one_height));

  // Model-view-projection matrix
  glm::mat4 enemy_shadow_mvp = projection * view * enemy_shadow_model * enemy_shadow_model_transformations;
  GLuint enemy_shadow_mvpMatrixId = glGetUniformLocation(dimObjectProgramId, "u_MVP");
  glUniformMatrix4fv(enemy_shadow_mvpMatrixId, 1, GL_FALSE, &enemy_shadow_mvp[0][0]);

  if (enemy_one_active) {
    setBuffersAndDraw(enemy_shadow_numVertices, &enemy_shadow_positions_vbo, &enemy_shadow_textureCoords_vbo, &enemy_shadow_normals_vbo, &enemy_shadow_indexBuffer, &dimObjectProgramId);
  }

  //--------------------------------------END OF ENEMY SHADOW--------------------------------------

  //------------------------------------------ENEMY BASE------------------------------------------
  textureUniformId = glGetUniformLocation(enemyProgramId, "textureSampler");
  
  glUseProgram(enemyProgramId);

  // Color Vectors
  object_color = glm::vec3(0.5f, 0.5f, 0.5f);

  // Object Color
  GLuint enemy_base_objectColor;
  GLuint enemy_base_lightColor;

  setObjectColorInShader(enemy_base_objectColor, "objectColor", enemyProgramId, object_color);
  setObjectColorInShader(enemy_base_lightColor, "lightColor", enemyProgramId, object_color);

  lightHeight = 2.50f;
  lightPos = glGetUniformLocation(enemyProgramId, "lightPos");
  glUniform3f(lightPos, playerCoord.x - enemyCoord.x, lightHeight - enemyCoord.y, playerCoord.z - enemyCoord.z);

  viewPos = glGetUniformLocation(enemyProgramId, "viewPos");
  glUniform3f(viewPos, playerCoord.x - enemyCoord.x, lightHeight - enemyCoord.y, playerCoord.z - enemyCoord.z);

  // Placement and size. This also allows mouse movment view.
  float enemy_scale_multiplier = 6.0f;
  glm::mat4 enemy_base_model = glm::mat4(1.0f);
  setModelMatrix(enemy_base_model, xAngle, yAngle, zAngle, glm::vec3(1, 0, 0), glm::vec3(0, 1, 0), glm::vec3(0, 0, 1),
                                0.0f, 2.4f, 0.0, 
                                enemy_scale_multiplier, 1.0f, enemy_scale_multiplier);


  // Transformations matrix
  glm::mat4 enemy_base_model_transformations = glm::mat4(1.0f);
  enemy_base_model_transformations = glm::translate(enemy_base_model_transformations, glm::vec3(bezierXCord_enemy_one/enemy_scale_multiplier, bezierYCord_enemy_one, bezierZCord_enemy_one/enemy_scale_multiplier));

  enemyCoord = glm::vec3(bezierXCord_enemy_one/enemy_scale_multiplier, bezierYCord_enemy_one, bezierZCord_enemy_one/enemy_scale_multiplier);
  
  // Model-view-projection matrix
  glm::mat4 enemy_base_mvp = projection * view * enemy_base_model * enemy_base_model_transformations;
  GLuint enemy_base_mvpMatrixId = glGetUniformLocation(enemyProgramId, "u_MVP");
  glUniformMatrix4fv(enemy_base_mvpMatrixId, 1, GL_FALSE, &enemy_base_mvp[0][0]);

  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, texture_id_enemy_base);
  glUniform1i(textureUniformId, 0);
  
  if (enemy_one_active) {
    setBuffersAndDraw(enemy_base_numVertices, &enemy_base_positions_vbo, &enemy_base_textureCoords_vbo, &enemy_base_normals_vbo, &enemy_base_indexBuffer, &enemyProgramId);
  }

  //----------------------------------------END OF ENEMY SHADOW----------------------------------------
  //----------------------------------------END OF ENEMY RENDER----------------------------------------

	// Make the draw buffer to display buffer (i.e. display what we have drawn) //if double buffered
	glutSwapBuffers();
}

static void reshape(int w, int h) {
    glViewport(0, 0, w, h);

    width = w;
    height = h;
}

static void drag(int x, int y) {
  if (!std::isinf(lastX) && !std::isinf(lastY)) {
    
    float dx = lastX - (float)x;
    float dy = lastY - (float)y;

  if (moving) {
      moveX += dx/1400.0f;
      moveY += dy/1400.0f;
    }
  } else {
    lastX = (float)x;
    lastY = (float)y;
  }
}

static void mouse(int button, int state, int x, int y) {
    if (button == GLUT_RIGHT_BUTTON && state == GLUT_DOWN) {
      lastX = std::numeric_limits<float>::infinity();
      lastY = std::numeric_limits<float>::infinity();
      moving = true;
    }

    if (button == GLUT_RIGHT_BUTTON && state == GLUT_UP) {
      lastX = std::numeric_limits<float>::infinity();
      lastY = std::numeric_limits<float>::infinity();
      moving = false;
    }
}

static void keyboard(unsigned char key, int x, int y) {
    std::cout << "Key pressed: " << key << std::endl;
    if (key == 'r') {
      lastX = 0.0f;
      lastY = 0.0f;

      moveX = 0.0f;
      moveY = 0.0f;

      bezierXCord = 0.0f;
      bezierYCord = 0.0f;
      bezierZCord = 0.0f;

      std::vector<glm::vec3> points;
      points.push_back(glm::vec3(moveX, 0, moveY));
      points.push_back(glm::vec3(moveX, 0, moveY));
      getJumpVertices(points, player_path, player_path_vertices);
      points.pop_back();
      points.pop_back();  

      enemy_one_collision_count = 0;
      enemy_one_active = true;

      createTexture("textures/ground.jpg", &texture_id_ground);
    }
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);
    glutInitWindowSize(1024, 768);//1024 × 768
    glutCreateWindow("CSCI3090U Final Project");
    glutIdleFunc(&update);
    glutDisplayFunc(&render);
    glutReshapeFunc(&reshape);
    glutMotionFunc(&drag);
    glutMouseFunc(&mouse);
    glutKeyboardFunc(&keyboard);

    glewInit();
    if (!GLEW_VERSION_2_0) {
        std::cerr << "OpenGL 2.0 not available" << std::endl;
        return 1;
    }
    std::cout << "Using GLEW " << glewGetString(GLEW_VERSION) << std::endl;
		std::cout << "Using OpenGL " << glGetString(GL_VERSION) << std::endl;

    createGeometry();
      
    createTexture("textures/ground.jpg", &texture_id_ground);
    createTexture("textures/hat.png", &texture_id_hat);
    createTexture("textures/snow.jpg", &texture_id_base);
    createTexture("textures/snow.jpg", &texture_id_sphere);
    createTexture("textures/gold.jpg", &texture_id_enemy_base);

    ShaderProgram program;
    program.loadShaders("shaders/vertex.glsl", "shaders/fragment.glsl");
  	programId = program.getProgramId();

    ShaderProgram enemyProgram;
    program.loadShaders("shaders/vertex.glsl", "shaders/enemy.glsl");
  	enemyProgramId = program.getProgramId();

    ShaderProgram lightprogram;
    lightprogram.loadShaders("shaders/vertex.glsl", "shaders/lightfragment.glsl");
    lightProgramId = lightprogram.getProgramId();

    ShaderProgram dimobjectprogram;
    dimobjectprogram.loadShaders("shaders/vertex.glsl", "shaders/dimobjectfragment.glsl");
    dimObjectProgramId = dimobjectprogram.getProgramId();

    glutMainLoop();

    return 0;
}
