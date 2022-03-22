/* MakeUp - dither.glsl
Dither and hash functions

*/

float hash12(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

float timed_hash12(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract(0.3 * frame_mod + ((p3.x + p3.y) * p3.z));
}

float r_dither(vec2 frag) {
  return fract(dot(frag, vec2(0.75487766624669276, 0.569840290998)));
}

float shifted_r_dither(vec2 frag) {
  return fract((0.7 * frame_mod) + dot(frag, vec2(0.75487766624669276, 0.569840290998)));
}

float eclectic_r_dither(vec2 frag) {
  vec3 p3 = fract(vec3(frag.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  float p4 = fract((p3.x + p3.y) * p3.z) * 0.14;

  return fract(p4 + dot(frag, vec2(0.75487766624669276, 0.569840290998)));
}

float shifted_eclectic_r_dither(vec2 frag) {
  vec3 p3 = fract(vec3(frag.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  float p4 = fract((p3.x + p3.y) * p3.z) * 0.1;

  return fract((0.7 * frame_mod) + p4 + dot(frag, vec2(0.75487766624669276, 0.569840290998)));
}

float dither17(vec2 pos) {
  return fract(dot(vec3(pos, 0.0), vec3(0.11764705882352941, 0.4117647058823529, 1.3529411764705883)));
}

float shifted_dither17(vec2 pos) {
  return fract((0.25 * frame_mod) + dot(vec3(pos, 0.0), vec3(0.11764705882352941, 0.4117647058823529, 1.3529411764705883)));
}

float eclectic_dither17(vec2 frag) {
  vec3 p3 = fract(vec3(frag.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  float p4 = fract((p3.x + p3.y) * p3.z) * 0.14;

  return fract(p4 + dot(vec3(frag.xy, 0.0), vec3(2.0, 7.0, 23.0) / 17.0));
}

float shifted_eclectic_dither17(vec2 frag) {
  vec3 p3 = fract(vec3(frag.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  float p4 = fract((p3.x + p3.y) * p3.z) * 0.075;

  return fract((0.25 * frame_mod) + p4 + dot(vec3(frag.xy, 0.0), vec3(2.0, 7.0, 23.0) / 17.0));
}

float dither_grad_noise(vec2 p) {
  return fract(52.9829189 * fract(0.06711056 * p.x + 0.00583715 * p.y));
}

float shifted_dither_grad_noise(vec2 p) {
  return fract(0.3975 * frame_mod + (52.9829189 * fract(0.06711056 * p.x + 0.00583715 * p.y)));
}

float eclectic_dither(vec2 frag) {
  vec3 p3 = fract(vec3(frag.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  float p4 = fract((p3.x + p3.y) * p3.z) * 0.14;

  return fract(p4 + (52.9829189 * fract(0.06711056 * frag.x + 0.00583715 * frag.y)));
}

float shifted_eclectic_dither(vec2 frag) {
  vec3 p3 = fract(vec3(frag.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  float p4 = fract((p3.x + p3.y) * p3.z) * 0.14;

  return fract((0.3975 * frame_mod) + p4 + (52.9829189 * fract(0.06711056 * frag.x + 0.00583715 * frag.y)));
}

float grid_noise(vec2 p) {
  return fract(
    dot(
      p - vec2(0.5, 0.5),
      vec2(0.0625, .277777777777777777778) + 0.25
      )
    );
}

float shifted_grid_noise(vec2 p) {
  return fract(0.4 * frame_mod +
    dot(
      p - vec2(0.5, 0.5),
      vec2(0.0625, .277777777777777777778) + 0.25
      )
    );
}

float shifted_eclectic_grid_noise(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  float p4 = fract((p3.x + p3.y) * p3.z) * 0.05;
  
  return fract(0.4 * frame_mod + p4 +
    dot(
      p - vec2(0.5, 0.5),
      vec2(0.0625, .277777777777777777778) + 0.25
      )
    );
}

// float texture_noise_64(vec2 p, sampler2D noise) {
//   return texture(noise, p * 0.015625).r;
// }

// float shifted_texture_noise_64(vec2 p, sampler2D noise) {
//   float dither = texture(noise, p * 0.015625).r;
//   return fract(0.6 * frame_mod + dither);
// }

// float phi_noise(vec2 uv_f)
// {
//   uvec2 uv = uvec2(uv_f);
  
//   if (((uv.x ^ uv.y) & 4u) == 0u) uv = uv.yx;

//   const uint r0 = 3242174893u;
//   const uint r1 = 2447445397u;

//   uint h = (uv.x * r0) + (uv.y * r1);

//   uv = uv >> 2u;
//   uint l = ((uv.x * r0) ^ (uv.y * r1)) * r1;

//   return float(l + h) * 2.3283064365386963e-10;
// }

// float shifted_phi_noise(vec2 uv_f)
// {
//   uvec2 uv = uvec2(uv_f);

//   if (((uv.x ^ uv.y) & 4u) == 0u) uv = uv.yx;

//   const uint r0 = 3242174893u;
//   const uint r1 = 2447445397u;

//   uint h = (uv.x * r0) + (uv.y * r1);

//   uv = uv >> 2u;
//   uint l = ((uv.x * r0) ^ (uv.y * r1)) * r1;

//   return fract(0.7 * frame_mod + (float(l + h) * 2.3283064365386963e-10));
// }
