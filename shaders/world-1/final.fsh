#version 130
/* MakeUp - final.fsh
Render: Final renderer

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NO_SHADOWS

#include "/lib/config.glsl"

// Do not remove comments. It works!
/*

colortex0 - Main color canvas
colortex1 - Antialiasing auxiliar
colortex2 - Bloom auxiliar
colortex3 - TAA Averages history
gaux1 - Sreen-Space-Reflection texture
colortex5 - Blue noise texture
gaux3 - Perlin noise texture
colortex7 - Not used

const int colortex0Format = R11F_G11F_B10F;
const int colortex1Format = RGBA16F;
const int colortex2Format = R11F_G11F_B10F;
const int colortex3Format = RGBA16F;
const int gaux1Format = RGB8;
const int colortex5Format = R8;
const int gaux3Format = R8;
const int colortex7Format = R8;
*/

// 'Global' constants from system
uniform sampler2D colortex0;

// Varyings (per thread shared variables)
varying vec2 texcoord;

#if BLOOM == 1
  varying float exposure;
#endif

#include "/lib/color_utils.glsl"
#include "/lib/basic_utils.glsl"
#include "/lib/tone_maps.glsl"

#if CHROMA_ABER == 1
  #include "/lib/aberration.glsl"
#endif

void main() {
  #if CHROMA_ABER == 1
    vec3 block_color = color_aberration();
  #else
    vec3 block_color = texture(colortex0, texcoord).rgb;
  #endif

  block_color *= exposure;
  block_color = lottes_tonemap(block_color, exposure + 0.5);

  gl_FragColor = vec4(block_color, 1.0);
}
