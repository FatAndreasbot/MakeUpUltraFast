#include "/lib/config.glsl"

#ifdef THE_END
  #include "/lib/color_utils_end.glsl"
#elif defined NETHER
  #include "/lib/color_utils_nether.glsl"
#else
  #include "/lib/color_utils.glsl"
#endif

uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

varying vec4 tint_color;
varying vec2 texcoord;

#include "/lib/luma.glsl"
#include "/lib/basic_utils.glsl"

#if AA_TYPE > 0
  #include "/src/taa_offset.glsl"
#endif

void main() {
  #include "/src/basiccoords_vertex.glsl"
  #include "/src/position_vertex.glsl"
  tint_color = gl_Color;
}
