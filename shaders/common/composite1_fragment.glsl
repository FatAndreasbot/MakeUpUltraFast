/* Config, uniforms, ins, outs */
#include "/lib/config.glsl"

#ifdef THE_END
  #include "/lib/color_utils_end.glsl"
#elif defined NETHER
  #include "/lib/color_utils_nether.glsl"
#else
  #include "/lib/color_utils.glsl"
#endif

uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform int frame_mod;
uniform float inv_aspect_ratio;

#ifdef DOF
  uniform float centerDepthSmooth;
  uniform float pixel_size_x;
  uniform float pixel_size_y;
  uniform float viewWidth;
  uniform float viewHeight;
  uniform float fov_y_inv;
#endif

#ifdef DOF
  const bool colortex1MipmapEnabled = true;
#endif

// Varyings (per thread shared variables)
varying vec2 texcoord;

#include "/lib/bloom.glsl"

#if defined BLOOM || defined DOF
  #include "/lib/dither.glsl"
#endif

#ifdef DOF
  #include "/lib/blur.glsl"
#endif

#ifdef BLOOM
  const bool colortex2MipmapEnabled = true;
#endif

void main() {
  vec4 block_color = texture2D(colortex1, texcoord);

  #if defined BLOOM || defined DOF
    #if AA_TYPE > 0
      float dither = shifted_dither_grad_noise(gl_FragCoord.xy);
    #else
      float dither = eclectic_dither(gl_FragCoord.xy);
    #endif
  #endif

  #ifdef DOF
    block_color.rgb = noised_blur(
      block_color,
      colortex1,
      texcoord,
      DOF_STRENGTH,
      dither
      );
  #endif

  #ifdef BLOOM
    vec3 bloom = mipmap_bloom(colortex2, texcoord, dither);
    block_color.rgb += bloom;
  #endif

  /* DRAWBUFFERS:1 */
  gl_FragData[0] = block_color;
}
