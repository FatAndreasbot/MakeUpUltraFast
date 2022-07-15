#include "/lib/config.glsl"

// Pseudo-uniforms uniforms
uniform int worldTime;
uniform int frameCounter;
uniform float viewWidth;
uniform float viewHeight;

#include "/iris_uniforms/pixel_size_x.glsl"
#include "/iris_uniforms/pixel_size_y.glsl"
#include "/iris_uniforms/frame_mod.glsl"
#include "/iris_uniforms/taa_offset.glsl"
#include "/iris_uniforms/light_mix.glsl"

#if defined THE_END
  #include "/lib/color_utils_end.glsl"
#elif defined NETHER
  #include "/lib/color_utils_nether.glsl"
#else
  #include "/lib/color_utils.glsl"
#endif

/* Config, uniforms, ins, outs */
uniform vec3 sunPosition;
uniform int isEyeInWater;
// uniform float light_mix;
uniform float far;
uniform float rainStrength;
uniform ivec2 eyeBrightnessSmooth;

#ifdef DYN_HAND_LIGHT
  uniform int heldItemId;
  uniform int heldItemId2;
#endif

#ifdef UNKNOWN_DIM
  uniform sampler2D lightmap;
#endif

#if defined FOLIAGE_V || defined THE_END || defined NETHER
  uniform mat4 gbufferModelView;
#endif

#if defined FOLIAGE_V || defined SHADOW_CASTING || (defined MATERIAL_GLOSS && !defined NETHER)
  uniform mat4 gbufferModelViewInverse;
#endif

#if defined MATERIAL_GLOSS && !defined NETHER
  uniform vec3 moonPosition;
#endif

#if defined SHADOW_CASTING && !defined NETHER
  uniform mat4 shadowModelView;
  uniform mat4 shadowProjection;
  uniform vec3 shadowLightPosition;
#endif

#if WAVING == 1
  uniform vec3 cameraPosition;
  uniform float frameTimeCounter;
#endif

varying vec2 texcoord;
varying vec4 tint_color;
varying float frog_adjust;
varying vec3 direct_light_color;
varying vec3 candle_color;
varying float direct_light_strenght;
varying vec3 omni_light;

#if defined GBUFFER_TERRAIN || defined GBUFFER_HAND
  varying float emmisive_type;
#endif

#ifdef FOLIAGE_V
  varying float is_foliage;
#endif

#if defined SHADOW_CASTING && !defined NETHER
  varying vec3 shadow_pos;
  varying float shadow_diffuse;
#endif

#if defined MATERIAL_GLOSS && !defined NETHER
  varying vec3 flat_normal;
  varying vec3 sub_position3;
  varying vec2 lmcoord_alt;
  varying float gloss_factor;
  varying float gloss_power;
  varying float luma_factor;
  varying float luma_power;
#endif

#if defined MATERIAL_GLOSS && !defined NETHER
  attribute vec4 at_tangent;
#endif

#if defined FOLIAGE_V || defined GBUFFER_TERRAIN || defined GBUFFER_HAND || (defined MATERIAL_GLOSS && !defined NETHER)
  attribute vec4 mc_Entity;
#endif

#if WAVING == 1
  attribute vec2 mc_midTexCoord;
#endif

#if AA_TYPE > 0
  // #include "/src/taa_offset.glsl"
#endif

#include "/lib/basic_utils.glsl"

#if defined SHADOW_CASTING && !defined NETHER
  #include "/lib/shadow_vertex.glsl"
#endif

#if WAVING == 1
  #include "/lib/vector_utils.glsl"
#endif

#include "/lib/luma.glsl"

void main() {
  // Pseudo-uniforms section
  float day_moment = day_moment();
  float day_mixer = day_mixer(day_moment);
  float night_mixer = night_mixer(day_moment);
  float light_mix = light_mix();
  #if AA_TYPE > 0
    int frame_mod = frame_mod();
    vec2 pixel_size = vec2(pixel_size_x(), pixel_size_y());
    vec2 taa_offset = taa_offset(frame_mod, pixel_size);
  #endif

  vec2 eye_bright_smooth = vec2(eyeBrightnessSmooth);
  
  #include "/src/basiccoords_vertex.glsl"
  #include "/src/position_vertex.glsl"
  #include "/src/light_vertex.glsl"
  #include "/src/fog_vertex.glsl"

  #if defined GBUFFER_TERRAIN || defined GBUFFER_HAND
    emmisive_type = 0.0;
    if (mc_Entity.x == ENTITY_EMMISIVE || mc_Entity.x == ENTITY_S_EMMISIVE) {
      emmisive_type = 1.0;
    }
  #endif

  #if defined SHADOW_CASTING && !defined NETHER
    #include "/src/shadow_src_vertex.glsl"
  #endif

  #if defined FOLIAGE_V && !defined NETHER
    #ifdef SHADOW_CASTING
      if (is_foliage > .2) {
        direct_light_strenght = mix(direct_light_strenght, original_direct_light_strenght, clamp((gl_Position.z / SHADOW_LIMIT) * 2.0 - 0.5, 0.0, 1.0));
      }
    #endif
  #endif

  #if defined MATERIAL_GLOSS && !defined NETHER
    luma_factor = 1.0;
    luma_power = 2.0;
    gloss_power = 6.0;
    gloss_factor = 1.05;

    if (mc_Entity.x == ENTITY_SAND) {  // Sand-like block
      luma_power = 4.0;
    } else if (mc_Entity.x == ENTITY_METAL) {  // Metal-like block
      luma_factor = 1.35;
      luma_power = 3.0;
      gloss_power = 10.0;
    } else if (mc_Entity.x == ENTITY_FABRIC) {  // Fabric-like blocks
      gloss_power = 3.0;
      gloss_factor = 0.1;
    }

    flat_normal = normal;
    sub_position3 = sub_position.xyz;

    lmcoord_alt = lmcoord;
    
  #endif

  #if defined GBUFFER_ENTITY_GLOW
    gl_Position.z *= 0.01;
  #endif
}
