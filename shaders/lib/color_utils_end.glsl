/* MakeUp - color_utils.glsl
Usefull data for color manipulation.

Javier Garduño - GNU Lesser General Public License v3.0
*/

uniform float day_moment;
uniform float day_mixer;
uniform float night_mixer;

#define OMNI_TINT 0.5
#define AMBIENT_MIDDLE_COLOR vec3(0.068255, 0.054978, 0.068255)
#define AMBIENT_DAY_COLOR vec3(0.068255, 0.054978, 0.068255)
#define AMBIENT_NIGHT_COLOR vec3(0.068255, 0.054978, 0.068255)

#define HI_MIDDLE_COLOR vec3(0.0465375, 0.037485, 0.0465375)
#define HI_DAY_COLOR vec3(0.0465375, 0.037485, 0.0465375)
#define HI_NIGHT_COLOR vec3(0.0465375, 0.037485, 0.0465375)

#define LOW_MIDDLE_COLOR vec3(0.0465375, 0.037485, 0.0465375)
#define LOW_DAY_COLOR vec3(0.0465375, 0.037485, 0.0465375)
#define LOW_NIGHT_COLOR vec3(0.0465375, 0.037485, 0.0465375)

#define WATER_COLOR vec3(0.01647059, 0.13882353, 0.16470588)

#if BLOCKLIGHT_TEMP == 0
  #define CANDLE_BASELIGHT vec3(0.29975, 0.15392353, 0.0799)
#elif BLOCKLIGHT_TEMP == 1
  #define CANDLE_BASELIGHT vec3(0.27475, 0.17392353, 0.0899)
#elif BLOCKLIGHT_TEMP == 2
  #define CANDLE_BASELIGHT vec3(0.24975, 0.19392353, 0.0999)
#elif BLOCKLIGHT_TEMP == 3
  #define CANDLE_BASELIGHT vec3(0.22, 0.19, 0.14)
#else
  #define CANDLE_BASELIGHT vec3(0.19, 0.19, 0.19)
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
#define EXPOSURE_DAY 1.0
#define EXPOSURE_MIDDLE 1.0
#define EXPOSURE_NIGHT 1.0

// Fog parameter per hour
#if VOL_LIGHT == 1 || (VOL_LIGHT == 2 && defined SHADOW_CASTING)
    #define FOG_DENSITY 1.0
#else
  #define FOG_DAY 1.0
  #define FOG_MIDDLE 1.0
  #define FOG_NIGHT 1.0
#endif
