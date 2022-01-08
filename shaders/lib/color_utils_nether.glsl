/* MakeUp - color_utils.glsl
Usefull data for color manipulation.

Javier Garduño - GNU Lesser General Public License v3.0
*/

uniform float day_moment;
uniform float day_mixer;
uniform float night_mixer;

#define OMNI_TINT 0.5
#define AMBIENT_MIDDLE_COLOR vec3(0.0529638 , 0.04843891, 0.03753393)
#define AMBIENT_DAY_COLOR vec3(0.0529638 , 0.04843891, 0.03753393)
#define AMBIENT_NIGHT_COLOR vec3(0.0529638 , 0.04843891, 0.03753393)

#define HI_MIDDLE_COLOR vec3(0.0479638 , 0.04343892, 0.04253394)
#define HI_DAY_COLOR vec3(0.0479638 , 0.04343892, 0.04253394)
#define HI_NIGHT_COLOR vec3(0.0479638 , 0.04343892, 0.04253394)

#define LOW_MIDDLE_COLOR vec3(0.0479638 , 0.04343892, 0.04253394)
#define LOW_DAY_COLOR vec3(0.0479638 , 0.04343892, 0.04253394)
#define LOW_NIGHT_COLOR vec3(0.0479638 , 0.04343892, 0.04253394)

#define WATER_COLOR vec3(0.018, 0.12 , 0.18)

#if COLOR_SCHEME == 0  // Legacy
  #define CANDLE_BASELIGHT vec3(0.24975, 0.19392353, 0.0999)
#elif COLOR_SCHEME == 1  // Cocoa
  #define CANDLE_BASELIGHT vec3(0.24975, 0.19392353, 0.0999)
#elif COLOR_SCHEME == 2  // Captain
  #define CANDLE_BASELIGHT vec3(0.24975, 0.19392353, 0.0999)
#elif COLOR_SCHEME == 3  // Shoka
  #define CANDLE_BASELIGHT vec3(0.24975, 0.19392353, 0.0999)
#elif COLOR_SCHEME == 4  // Ethereal
  #define CANDLE_BASELIGHT vec3(0.27475, 0.17392353, 0.0899)
#elif COLOR_SCHEME == 5  // Vivid
  #define CANDLE_BASELIGHT vec3(0.29975, 0.15392353, 0.0799)
#endif

vec3 day_blend(vec3 middle, vec3 day, vec3 night) {
  // f(x) = min(-((x-.25)^2)∙20 + 1.25, 1)
  // g(x) = min(-((x-.75)^2)∙50 + 3.125, 1)

  vec3 day_color = mix(middle, day, day_mixer);
  vec3 night_color = mix(middle, night, night_mixer);

  return mix(day_color, night_color, step(0.5, day_moment));
}

float day_blend_float(float middle, float day, float night) {
  // f(x) = min(-((x-.25)^2)∙20 + 1.25, 1)
  // g(x) = min(-((x-.75)^2)∙50 + 3.125, 1)

  float day_value = mix(middle, day, day_mixer);
  float night_value = mix(middle, night, night_mixer);

  return mix(day_value, night_value, step(0.5, day_moment));
}

// Ambient color luma per hour in exposure calculation
const float ambient_exposure[25] =
  float[25](
  1.0, // 6
  1.0, // 7
  1.0, // 8
  1.0, // 9
  1.0, // 10
  1.0, // 11
  1.0, // 12
  1.0, // 13
  1.0, // 14
  1.0, // 15
  1.0, // 16
  1.0, // 17
  1.0, // 18
  1.0, // 19
  1.0, // 20
  1.0, // 21
  1.0, // 22
  1.0, // 23
  1.0, // 24
  1.0, // 1
  1.0, // 2
  1.0, // 3
  1.0, // 4
  1.0, // 5
  1.0 // 6
  );

// Fog parameter per hour
const float fog_density[25] =
  float[25](
  1.0, // 6
  1.0, // 7
  1.0, // 8
  1.0, // 9
  1.0, // 10
  1.0, // 11
  1.0, // 12
  1.0, // 13
  1.0, // 14
  1.0, // 15
  1.0, // 16
  1.0, // 17
  1.0, // 18
  1.0, // 19
  1.0, // 20
  1.0, // 21
  1.0, // 22
  1.0, // 23
  1.0, // 24
  1.0, // 1
  1.0, // 2
  1.0, // 3
  1.0, // 4
  1.0, // 5
  1.0 // 6
  );
