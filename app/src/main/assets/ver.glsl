attribute vec3 a_position;
attribute vec4 a_color;
attribute vec3 a_normal;
attribute vec2 a_tex_coord;
uniform vec3 u_camera;
uniform mat4 u_m_matrix;
uniform mat4 u_mvp_matrix;
uniform vec4 u_ambient_color;
varying vec2 v_tex_coord;
varying vec4 v_model_color;
uniform bool u_surface0_;
uniform float u_s0_shininess;
uniform bool u_surface1_;
uniform float u_s1_shininess;
uniform bool u_surface2_;
uniform float u_s2_shininess;
uniform bool u_light0_;
uniform bool u_l0_is_point_light;
uniform vec4 u_l0_color;
uniform vec3 u_l0_pos_or_dir;
varying vec4 v_l0_diffuse;
varying vec4 v_l0_specular;

void diffuse_color(in vec3 vecNormal,in vec3 vecLight,in vec4 lightColor,inout vec4 diffuse)
{
  float nDotViewPosition = max(0.0, dot(vecNormal, vecLight));
  diffuse = lightColor * nDotViewPosition;
}

void specular_color(in vec3 normal,in vec3 vecLight,in vec3 vecEye,in float shininess,in vec4 lightColor,inout vec4 specular)
{
  vec3 vecHalf = normalize(vecLight + vecEye);
  float nDotViewHalfVector = dot(normal, vecHalf);
  float powerFactor = max(0.0, pow(nDotViewHalfVector, shininess));
  specular = lightColor * powerFactor;
}

void light(in vec3 normal,in bool isPointLight,in vec3 lightLocOrDir,in vec4 lightColor,in float shininess,inout vec4 diffuse,inout vec4 specular)
{
  vec3 newPos = (u_m_matrix * vec4(a_position, 1)).xyz;
  vec3 normalTarget = a_position + normal;
  vec3 vecNormal = normalize((u_m_matrix * vec4(normalTarget, 1)).xyz - newPos);
  vec3 vecEye = normalize(u_camera - newPos);
  vec3 vecLight = normalize(isPointLight ? (lightLocOrDir - newPos) : lightLocOrDir * vec3(-1, -1, -1));
  diffuse_color(vecNormal, vecLight, lightColor, diffuse);
  specular_color(vecNormal, vecLight, vecEye, shininess, lightColor, specular);
}

void main() {
  gl_Position = u_mvp_matrix * vec4(a_position, 1);
  v_tex_coord = a_tex_coord;
  v_model_color = a_color;
  vec4 d = vec4(0, 0, 0, 0);
  vec4 s = vec4(0, 0, 0, 0);
  if (u_surface0_) {
    if (u_light0_) {
        light(normalize(a_normal),u_l0_is_point_light,u_l0_pos_or_dir,u_l0_color,u_s0_shininess,d,s);
        v_l0_diffuse = d;v_l0_specular = s;
      }
    } else if (u_surface1_) {
      if (u_light0_) {
        light(normalize(a_normal),u_l0_is_point_light,u_l0_pos_or_dir,u_l0_color,u_s1_shininess,d,s);
        v_l0_diffuse = d;
        v_l0_specular = s;
        }
      } else if (u_surface2_) {
        if (u_light0_) {
          light(normalize(a_normal),u_l0_is_point_light,u_l0_pos_or_dir,u_l0_color,u_s2_shininess,d,s);
          v_l0_diffuse = d;
          v_l0_specular = s;
      }
    }
}
