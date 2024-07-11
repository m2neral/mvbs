#version 460 compatibility

out float height;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform vec3 cameraPosition;

void main(){
  vec4 pos = gl_ModelViewProjectionMatrix * gl_Vertex; 
  height = (gbufferModelViewInverse * gbufferProjectionInverse * pos).y;
  height /= 100;
  height += 0.5;
  gl_Position = pos;
}
