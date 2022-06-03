/* Config, uniforms, ins, outs */
#include "/lib/config.glsl"

#ifdef THE_END
  #include "/lib/color_utils_end.glsl"
#elif defined NETHER
  #include "/lib/color_utils_nether.glsl"
#else
  #include "/lib/color_utils.glsl"
#endif

uniform sampler2D colortex0;
uniform sampler2D gaux3;
uniform sampler2D depthtex0;
uniform int isEyeInWater;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform float pixel_size_x;
uniform float pixel_size_y;
uniform float rainStrength;
uniform ivec2 eyeBrightnessSmooth;
uniform float far;
uniform float near;

#ifdef NETHER
  uniform vec3 fogColor;
#endif

in vec2 texcoord;

#include "/lib/depth.glsl"

void main() {
  vec4 block_color = texture2D(colortex0, texcoord);
  vec4 effects_color = texture2D(gaux3, texcoord);

  float d = texture2D(depthtex0, texcoord).r;
  float linear_d = ld(d);

  vec2 eye_bright_smooth = vec2(eyeBrightnessSmooth);
  vec3 view_vector;

  #if defined THE_END
    if (linear_d > 0.9999) {  // Only sky
      block_color = vec4(HI_DAY_COLOR, 1.0);
    }
  #elif defined NETHER
    if (linear_d > 0.9999) {  // Only sky
      block_color = vec4(mix(fogColor * 0.1, vec3(1.0), 0.04), 1.0);
    }
  #else
    if (linear_d > 0.9999 && isEyeInWater == 1) {  // Only sky and water
      vec4 screen_pos =
        vec4(
          gl_FragCoord.xy * vec2(pixel_size_x, pixel_size_y),
          gl_FragCoord.z,
          1.0
        );
      vec4 fragposition = gbufferProjectionInverse * (screen_pos * 2.0 - 1.0);

      vec4 world_pos = gbufferModelViewInverse * vec4(fragposition.xyz, 0.0);
      view_vector = normalize(world_pos.xyz);
    }
  #endif

  vec3 result;
  #if !defined NETHER
    if (linear_d > 0.9999) {
      result = effects_color.rgb;
    } else {
      result = mix(vec3(0.0), block_color.rgb , effects_color.a);
    }
  #else
    result = block_color.rgb;
  #endif

  #if defined THE_END || defined NETHER
    #define NIGHT_CORRECTION 1.0
  #else
    #define NIGHT_CORRECTION day_blend_float(1.0, 1.0, 0.1)
  #endif

  // Cielo bajo el agua
  if (isEyeInWater == 1) {
    if (linear_d > 0.9999) {
      result = mix(
        NIGHT_CORRECTION * WATER_COLOR * ((eye_bright_smooth.y * .8 + 48) * 0.004166666666666667),
        result,
        max(clamp(view_vector.y - 0.1, 0.0, 1.0), rainStrength)
      );
    }
  }

  /* DRAWBUFFERS:14 */
  gl_FragData[0] = vec4(result, d);
  gl_FragData[1] = vec4(result, 1.0);
}