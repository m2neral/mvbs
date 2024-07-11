#version 460

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;
uniform sampler2D colortex0; //inColor
uniform sampler2D colortex3; 
uniform sampler2D colortex5; 
uniform sampler2D depthtex0; 

in vec2 texCoord;
uniform sampler2D shadowtex0;

uniform float near;
float nearTest = near;
uniform float far;
float farTest = far;


float LinearizeDepth(float depth) 
{
    float z = depth * 2.0 - 1.0; 
    return (2.0 * nearTest * farTest) / (farTest + nearTest - z * (farTest - nearTest));	
}


void main(){
  vec2 testCoord = texCoord;
  vec4 textureColor = texture(colortex0, testCoord);
  vec4 skyvsground = texture(colortex5, testCoord);
  vec3 color = textureColor.xyz;
  vec3 blur = vec3(0.0);
  for(int x = -2; x < 3; x++){
    for(int y = -2; y < 3; y++){
      vec2 offsetN = vec2(x, y) / 1080.0;
      vec3 offColor = texture(colortex0, testCoord + offsetN).xyz;
      float avgLuminance = offColor.r * 0.3 + offColor.g * 0.59 + offColor.b * 0.11;
        blur += offColor * avgLuminance * 1.5;
    }
  }
  blur /= 25.0;
  color += blur / 3.0;
  vec4 depthColor = texture(depthtex0, testCoord);
  vec4 skyColor = texture(colortex3, testCoord);
  float depth = LinearizeDepth(depthColor.x) / farTest;
  if(skyvsground.x == 1){
    color = color + depth * 1.5 * skyColor.xyz;
  }else{
    color = skyColor.xyz;
  }
  
  outColor0 = vec4(color, textureColor.w);
}

