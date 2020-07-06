#version 330

// uniform mat4 u_MVPMatrix;
// uniform mat4 u_MVMatrix;
// uniform vec4 u_DiffuseColour;

// layout(location = 0) in vec4 position;
// layout(location = 1) in vec3 normal;

// out vec3 v_Position;
// out vec3 v_Normal;

// void main() {
//     // interpolate the eye space position and normal
//     v_Position = vec3(u_MVMatrix * position);
//     v_Normal = vec3(u_MVMatrix * vec4(normal, 0.0));

//     // perform the usual model-view-projection transformation for the vertex position
//     gl_Position = u_MVPMatrix * position;
// }

uniform mat4 u_MVP;

attribute vec4 position;
attribute vec2 textureCoords;
attribute vec3 normal;

// --Texture-- 
uniform sampler2D textureSampler;
varying vec2 v_TextureCoords;
varying vec3 v_Normal;

out vec3 Normal;
out vec3 FragPos;

void main() {

    //places the object
    gl_Position = u_MVP * position;

    // --Texture--
    v_TextureCoords = textureCoords;
    v_Normal = normal;

    //Outputs the object's normals
    Normal = normal;
    // Normal = mat3(transpose(inverse(u_MVP))) * normal;

    //Outputs the object's position
    FragPos = position.xyz;
}

