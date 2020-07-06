#version 330

/*
    This shader is mainly for the lamp object  (lamp's cone, stand) that shouldn't be receiving light
*/

uniform vec3 objectColor;
uniform vec3 lightColor;

uniform vec3 lightPos;
uniform vec3 viewPos;

in vec3 Normal;
in vec3 FragPos; 

out vec4 FragColor;


void main()
{   
    ////Ambient light
    // float ambientStrength = 1.0f;
    // vec3 ambient = ambientStrength * lightColor;
    // vec3 result = ambient * objectColor;
    FragColor = vec4(objectColor, 1.0);
} 