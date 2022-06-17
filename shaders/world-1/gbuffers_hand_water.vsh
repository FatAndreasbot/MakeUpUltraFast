#version 120
#extension GL_EXT_gpu_shader4 : enable
/* MakeUp - gbuffers_hand_water.vsh
Render: Translucent hand objects

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NETHER
#define GBUFFER_HAND_WATER
#define NO_SHADOWS

#include "/common/solid_blocks_vertex.glsl"
