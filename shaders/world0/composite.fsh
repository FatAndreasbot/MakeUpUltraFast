#version 130
/* MakeUp Ultra Fast - composite.fsh
Render: DoF

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NO_SHADOWS

#include "/lib/config.glsl"
#include "/lib/color_utils.glsl"

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform float far;
uniform float near;
uniform float blindness;
uniform ivec2 eyeBrightnessSmooth;
uniform int current_hour_floor;
uniform int current_hour_ceil;
uniform float current_hour_fract;
uniform int isEyeInWater;
uniform float rainStrength;

#if DOF == 1
  uniform float centerDepthSmooth;
  uniform float inv_aspect_ratio;
  uniform float pixel_size_x;
  uniform float pixel_size_y;
  uniform float viewWidth;
  uniform float viewHeight;
  uniform float frameTimeCounter;
  uniform sampler2D colortex5;
  uniform float fov_y_inv;
#endif

// Varyings (per thread shared variables)
varying vec2 texcoord;

#include "/lib/depth.glsl"
#include "/lib/luma.glsl"

#if DOF == 1
  #include "/lib/dither.glsl"
  #include "/lib/blur.glsl"
#endif

void main() {
  // vec4 average_data = texture(colortex2, texcoord);

  vec3 block_color = texture(colortex0, texcoord).rgb;
  float d = texture(depthtex0, texcoord).r;
  float linear_d = ld(d);

  #if DOF == 1
    block_color = noised_blur(
      vec4(block_color, d),
      colortex0,
      texcoord,
      DOF_STRENGTH
      );

  #endif

  if (blindness > .01) {
    block_color =
    mix(block_color, vec3(0.0), blindness * linear_d * far * .12);
  }

  // Exposure
  float candle_bright = (eyeBrightnessSmooth.x * 0.004166666666666667) * 0.075;
  float exposure_coef =
    mix(
      ambient_exposure[current_hour_floor],
      ambient_exposure[current_hour_ceil],
      current_hour_fract
    );
  float exposure =
    ((eyeBrightnessSmooth.y * 0.004166666666666667) * exposure_coef) + candle_bright;

  // Map from 1.0 - 0.0 to 1.3 - 6.8
  exposure = (exposure * -5.5) + 6.8;

  // block_color.rgb *= exposure;

  // Bloom source
  float bloom_luma = smoothstep(0.7, 0.9, luma(block_color * exposure));
  // bloom_luma = pow(bloom_luma, 2.0);

  /* DRAWBUFFERS:01234567 */
  gl_FragData[1] = vec4(block_color, d);
  // gl_FragData[2] = average_data;
  gl_FragData[7] = vec4(block_color * bloom_luma * exposure, 1.0);
  // gl_FragData[7] = vec4(0.0);
}
