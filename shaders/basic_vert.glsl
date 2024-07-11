#version 460

in vec3 vaPosition;
in vec3 vaNormal;
in vec2 vaUV0;
in ivec2 vaUV2;
in vec4 vaColor;
in vec3 mc_Entity;

uniform int worldTime;
uniform float frameTimeCounter;

uniform mat4 gbufferModelViewInverse;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;

out vec2 texCoord;
out vec3 foliageColor;
out vec2 lightMapCoords;
out vec3 fragPos;
out vec3 fragNormal;
out float blockID;

#if defined(CHUNK) || defined(WATER)
uniform vec3 chunkOffset;
#endif

void main(){
  texCoord = vaUV0;
  foliageColor = vaColor.rgb;
  lightMapCoords = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);
  fragNormal = vaNormal;
  blockID = mc_Entity.x;

#if defined(CHUNK) || defined(WATER)
  if(mc_Entity.x == 10011.0){
    fragPos = vaPosition;
    fragPos += chunkOffset;
    float waveOffset = sin(frameTimeCounter + (fragPos.x + fragPos.z) / 2.0);
    waveOffset += sin(3*(frameTimeCounter) + (fragPos.x + fragPos.z) / 2.0);
    waveOffset += sin(frameTimeCounter + (fragPos.x + fragPos.z) / 2.0) / 2.0;
    fragPos.y += waveOffset / 20.0;
  }else{
    fragPos = vaPosition + chunkOffset;
  }
  gl_Position = projectionMatrix * modelViewMatrix * vec4(fragPos,1);
#else
  fragPos = vaPosition;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition,1);
#endif

}
