#version 460 compatibility

in vec3 mc_Entity;

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;

const int shadowMapResolution = 4096;

vec3 distort(vec3 pos){
  float factor = length(pos.xy) + 0.10;
  return vec3(pos.xy / factor, pos.z * 0.5);
}

void main(){
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
  glcolor = gl_Color;

#ifdef EXCLUDE_FOLIAGE
  if(mc_Entity.x == 10000.0){
    gl_Position = vec4(10.0);
  }else{
#endif
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex; 
    gl_Position.xyz = distort(gl_Position.xyz);
#ifdef EXCLUDE_FOLIAGE
  }
#endif
}
