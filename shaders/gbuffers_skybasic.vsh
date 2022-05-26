#version 120
/* MakeUp - gbuffers_skybasic.vsh
Render: Sky

Javier Garduño - GNU Lesser General Public License v3.0
*/

#ifdef USE_BASIC_SH
  #define UNKNOWN_DIM
#endif
#define GBUFFER_SKYBASIC
#define NO_SHADOWS

#include "/common/skybasic_vertex.glsl"
