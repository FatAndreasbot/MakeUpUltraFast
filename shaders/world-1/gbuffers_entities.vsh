#version 120
#extension GL_EXT_gpu_shader4 : enable
/* MakeUp - gbuffers_entities.vsh
Render: Droped objects, mobs and things like that

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NETHER
#define GBUFFER_ENTITIES
#define CAVEENTITY_V
#define NO_SHADOWS

#include "/common/solid_blocks_vertex.glsl"
