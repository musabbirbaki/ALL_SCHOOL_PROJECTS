#version 330

uniform sampler2D textureSampler;       // texture

varying vec2 v_TextureCoords;       // texture
varying vec3 v_Normal;

// just light color
out vec4 FragColor;

void main()
{
    vec4 baseColour = vec4(texture(textureSampler, v_TextureCoords).rgb, 1.0);
    FragColor = vec4(baseColour.xyz, 1.0); // set all 4 vector values to 1.0
}