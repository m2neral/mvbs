#version 460

in vec3 vaPosition;
uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;

out vec3 fragPos;

void main(){
  fragPos = vaPosition;
  fragPos.y -= 1.5;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition,1);
}
