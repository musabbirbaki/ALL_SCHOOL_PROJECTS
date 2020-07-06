#version 330

uniform sampler2D textureSampler;       // texture

uniform vec3 objectColor;
uniform vec3 lightColor;

uniform vec3 lightPos;
uniform vec3 viewPos;

// struct Material {
//     vec3 ambient;
//     vec3 diffuse;
//     vec3 specular;
//     float shininess;
// }; 
  
// uniform Material material;

in vec3 Normal;
in vec3 FragPos; 
varying vec2 v_TextureCoords;       // texture
varying vec3 v_Normal;

out vec4 FragColor;


void main()
{   
    ////Ambient light
    float ambientStrength = 0.1f;
    vec3 ambient = ambientStrength * lightColor;
    // vec3 result = ambient * objectColor;
    // FragColor = vec4(result, 1.0);

    //diffusing light
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPos - FragPos);  
    float diff = max(dot(norm, lightDir), 0.0f);
    vec3 diffuse = diff * lightColor;
    // vec3 result = (ambient + diffuse) * objectColor;
    // FragColor = vec4(result, 1.0);

    //specular light
    float specularStrength = 0.5f;
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 64);
    vec3 specular = specularStrength * spec * lightColor; 

    // Added texture
    vec4 baseColour = vec4(texture(textureSampler, v_TextureCoords).rgb, 1.0);
    vec3 result = (ambient + diffuse + specular) * baseColour.xyz;
    // vec3 result = (ambient + diffuse + specular) * objectColor;
    FragColor = vec4(result, 1.0);


//New
    // ambient
    // vec3 ambient = lightColor * material.ambient;
  	
    // // diffuse 
    // vec3 norm = normalize(Normal);
    // vec3 lightDir = normalize(lightPos - FragPos);
    // float diff = max(dot(norm, lightDir), 0.0);
    // vec3 diffuse = lightColor * (diff * material.diffuse);
    
    // // specular
    // vec3 viewDir = normalize(viewPos - FragPos);
    // vec3 reflectDir = reflect(-lightDir, norm);  
    // float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // vec3 specular = lightColor * (spec * material.specular);  
        
    // vec3 result = ambient + diffuse + specular;
    // FragColor = vec4(result, 1.0);

} 