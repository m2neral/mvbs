#version 460 compatibility

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

uniform sampler2D lightmap;
uniform sampler2D texture;

void main(){
  vec4 color = texture2D(texture, texcoord) * glcolor;
  gl_FragData[0] = color;
}
