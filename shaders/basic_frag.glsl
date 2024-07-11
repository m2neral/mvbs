#version 460

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform float alphaTestRef;
uniform sampler2D shadowtex0;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform mat4 gbufferProjection;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

/* DRAWBUFFERS:05 */
layout(location = 0) out vec4 outColor0;
layout(location = 1) out vec4 outColor1;

in vec2 texCoord;

in vec3 foliageColor;
in vec2 lightMapCoords;
in vec3 fragPos;
in vec3 fragNormal;
flat in float blockID;

vec3 eyeCameraPosition = cameraPosition + gbufferModelViewInverse[3].xyz;


float ShadowCalculation(vec4 fragPosLightSpace, vec3 lightDir){
  vec3 projCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
  float factor = length(projCoords.xy) + 0.10;
  projCoords = vec3(projCoords.xy / factor, projCoords.z * 0.5) * 0.5 + 0.5;
  float shadow = 0.0;
  float closestDepth = texture(shadowtex0, projCoords.xy).r;

  float depthCur = closestDepth;
  
  float currentDepth = projCoords.z;

    if(dot(fragNormal, lightDir) > 0.2){
    for(int x = -3; x < 4; x++){
      for(int y = -3; y < 4; y++){
        vec2 offset = vec2(x,y) / 4096.0;

        depthCur = texture(shadowtex0, projCoords.xy + offset).r;
        shadow += currentDepth - 0.0003 > depthCur ? 1.0 : 0.0;
      }
    }
    shadow /= 49.0;
    }
  return shadow;
}


float contrast(float mValue, float mScale, float mMidPoint) {
	return clamp( (mValue - mMidPoint) * mScale + mMidPoint, 0.1, 0.9);
}

float contrast(float mValue, float mScale) {
	return contrast(mValue,  mScale, .75);
}

vec3 contrast(vec3 mValue, float mScale, float mMidPoint) {
	return vec3( contrast(mValue.r, mScale, mMidPoint), contrast(mValue.g, mScale, mMidPoint), contrast(mValue.b, mScale, mMidPoint) );
}

vec3 contrast(vec3 mValue, float mScale) {
	return contrast(mValue, mScale, .75);
}

vec3 czm_saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}


void main(){

  vec3 fragWorldPos = fragPos + cameraPosition;

  vec3 lightColor = (texture(lightmap, lightMapCoords)).xyz;
  lightColor = lightColor * vec3(1.0, 0.8, 0.7);
  vec4 outputColorData = texture(gtexture, texCoord);
  vec3 blockColor = outputColorData.xyz * foliageColor;
  blockColor = contrast(blockColor, 1.2);
  vec3 greyScaleColor = czm_saturation(blockColor, 0);
  vec3 specularColor = contrast(greyScaleColor, 1.5);

  vec3 sunDirection;
#if defined(CHUNK) || defined(WATER)
  vec3 sunPos = (gbufferModelViewInverse * vec4(shadowLightPosition, 1.0)).xyz;
  sunDirection = normalize(sunPos);
#else
  sunDirection = normalize(shadowLightPosition);
#endif

  vec3 ambientLight = vec3(0.6) * blockColor;

  float diffuse = dot(fragNormal, sunDirection);
  vec3 diffuseLight = vec3(0.3) * diffuse * blockColor;

  vec3 viewDir = normalize(cameraPosition - fragWorldPos);
  vec3 reflectDir = reflect(-sunDirection, fragNormal);
  float spec = pow(max(dot(viewDir, reflectDir), 0.0), 1.0);
  vec3 specularLight = 0.4 * spec * specularColor;

  vec4 fragPosLightSpace = shadowProjection * shadowModelView * vec4(fragPos, 1.0);

  float shadow = ShadowCalculation(fragPosLightSpace, sunDirection);

  vec3 outputColor;
  if(blockID == 10010.0){
    ambientLight = outputColorData.xyz;
  }
#if defined(CHUNK) || defined(WATER)
  outputColor = (ambientLight + (1.0 - shadow) * (diffuseLight + specularLight)) * lightColor;
#else
  outputColor = (ambientLight + diffuseLight + specularLight) * lightColor;
#endif
  float transparency = outputColorData.a;
  if(transparency < alphaTestRef){
    discard;
  }
  
#ifdef TEXTURED
  if(outputColor.x == 0.0 && outputColor.y == 0.0 && outputColor.z == 0.0){
    transparency = transparency / 2.0;
  }
#endif
  outputColor += contrast(outputColor, 1.1) / 5.0;
  outColor0 = vec4(outputColor, transparency);
  outColor1 = outputColor != vec3(0.0) ? vec4(vec3(1.0), transparency) : vec4(vec3(0.0), transparency);
}
