#version 460


/* DRAWBUFFERS:3 */
layout(location = 0) out vec4 outColor0;

in vec3 fragPos;

flat in vec3 lightCent;

void main(){
  vec3 color = vec3(1.0, 0.7, 0.5);
  vec3 fromFragtoCent = normalize(lightCent - fragPos);
  float distToCent = length(lightCent - fragPos);
  float transparency = 1.0;

  if(distToCent < 1.0){
    transparency = 0.0;
  }else if(distToCent < 25.0){
    transparency *= distToCent / 25.0;
  }else{
    transparency = 1.0;
  }
  
  outColor0 = vec4(color, (1 - transparency) * 0.7);
}
