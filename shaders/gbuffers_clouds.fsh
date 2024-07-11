#version 460

/* DRAWBUFFERS:3 */
layout(location = 0) out vec4 outColor0;
in vec3 fragPos;
void main(){
  float height = fragPos.y;
  vec3 color = (height * 0.2 + 0.55) * vec3(1.0, 0.9, 0.9);
  outColor0 = vec4(color, 0.5);
}
