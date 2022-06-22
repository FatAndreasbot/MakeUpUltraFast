/* Config, uniforms, ins, outs */
#include "/lib/config.glsl"

// Do not remove comments. It works!
/*

noisetex - Water normals
colortex0 - Main color canvas
colortex1 - Antialiasing auxiliar
colortex2 - Bloom auxiliar
colortex3 - TAA Averages history
gaux1 - Screen-Space-Reflection texture
gaux2 - Clouds texture
gaux3 - Exposure auxiliar
gaux4 - Fog auxiliar

const int noisetexFormat = RG8;
const int colortex0Format = R11F_G11F_B10F;
*/
#ifdef DOF
/*
const int colortex1Format = RGBA16F;
*/
#else
/*
const int colortex1Format = R11F_G11F_B10F;
*/
#endif
#ifdef BLOOM
/*
const int colortex2Format = R11F_G11F_B10F;
*/
#else
/*
const int colortex2Format = R8;
*/
#endif
#ifdef DOF
/*
const int colortex3Format = RGBA16F;
*/
#else
/*
const int colortex3Format = R11F_G11F_B10F;
*/
#endif
/*
const int gaux1Format = R11F_G11F_B10F;
const int gaux2Format = RG8;
const int gaux3Format = R16F;
const int gaux4Format = R11F_G11F_B10F;
*/

// Buffers clear
const bool colortex0Clear = false;
const bool colortex1Clear = false;
const bool colortex2Clear = false;
const bool colortex3Clear = false;
const bool gaux1Clear = false;
const bool gaux2Clear = false;
const bool gaux3Clear = false;
const bool gaux4Clear = false;

// 'Global' constants from system
uniform sampler2D colortex0;

#ifdef DEBUG_MODE
  uniform sampler2D shadowtex1;
  uniform sampler2D shadowcolor0;
  uniform sampler2D colortex3;
#endif

uniform sampler2D gaux3;
uniform sampler2D colortex1;
uniform float viewWidth;

// Varyings (per thread shared variables)
varying vec2 texcoord;
varying float exposure;

#include "/lib/basic_utils.glsl"
#include "/lib/tone_maps.glsl"

#ifdef COLOR_BLINDNESS
  #include "/lib/color_blindness.glsl"
#endif

#if CHROMA_ABER == 1
  #include "/lib/aberration.glsl"
#endif

void main() {
  #if CHROMA_ABER == 1
    vec3 block_color = color_aberration();
  #else
    vec3 block_color = texture2D(colortex0, texcoord).rgb;
  #endif

  block_color *= vec3(exposure);

  #if defined UNKNOWN_DIM
    block_color = custom_sigmoid_alt(block_color);
  #else
    block_color = custom_sigmoid(block_color);
  #endif
  
  // Color-grading ---

  // Saturation
  // float actual_luma = luma(block_color);
  // block_color = mix(vec3(actual_luma), block_color, 1.5);

  // Color-blindness correction
  #ifdef COLOR_BLINDNESS
    block_color = color_blindness(block_color);
  #endif

  #ifdef DEBUG_MODE
    // vec3 block_color;
    if (texcoord.x < 0.5 && texcoord.y < 0.5) {
      block_color = texture2D(shadowtex1, texcoord * 2.0).rrr;
    } else if (texcoord.x >= 0.5 && texcoord.y >= 0.5) {
      block_color = vec3(texture2D(gaux3, vec2(0.5)).r * 0.25);
    } else if (texcoord.x < 0.5 && texcoord.y >= 0.5) {
      block_color = texture2D(colortex0, ((texcoord - vec2(0.0, 0.5)) * 2.0)).rgb;
    } else if (texcoord.x >= 0.5 && texcoord.y < 0.5) {
      block_color = texture2D(shadowcolor0, ((texcoord - vec2(0.5, 0.0)) * 2.0)).rgb;
    } else {
      block_color = vec3(0.5);
    }

    gl_FragColor = vec4(block_color, 1.0);

  #else
    gl_FragColor = vec4(block_color, 1.0);
  #endif
}