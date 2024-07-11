#version 460

in vec3 vaPosition;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform vec3 shadowLightPosition;

out vec3 fragPos;
out vec3 lightCent;

void main(){
  lightCent = shadowLightPosition;
  fragPos = vaPosition;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);
}
