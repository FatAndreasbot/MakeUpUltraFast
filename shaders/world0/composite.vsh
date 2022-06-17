#version 120
#extension GL_EXT_gpu_shader4 : enable
/* MakeUp - composite.fsh
Render: Bloom and volumetric light

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define COMPOSITE_SHADER

#include "/common/composite_vertex.glsl"
