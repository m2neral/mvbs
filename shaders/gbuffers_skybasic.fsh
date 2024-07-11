#version 460

/* DRAWBUFFERS:3 */
layout(location = 0) out vec4 outColor0;

uniform vec3 sunPosition;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

in float height;

void main(){
  vec3 sunPos = (gbufferModelViewInverse * vec4(sunPosition, 1.0)).xyz;
  vec3 skyColor = vec3(0.0, 0.9, 0.9);
  vec3 heightColor = (1.0 - height) * vec3(1.0, 0.0, 0.0);
  float sunStrength = sunPos.y / 200.0;
  sunStrength = max(-1.0, min(1.0, sunStrength));
  sunStrength = 1.0 - abs(sunStrength);
  sunStrength *= 2.0;
  outColor0 = vec4(skyColor + (heightColor * sunStrength), 1.0);
}
