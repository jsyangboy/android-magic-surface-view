precision mediump float;
uniform vec4 u_ambient_color;
uniform bool u_surface0_;
uniform sampler2D u_s0_t_body;
uniform bool u_surface1_;
uniform sampler2D u_s1_t_body;
uniform bool u_surface2_;
uniform sampler2D u_s2_t_body;
uniform bool u_light0_;
varying vec4 v_l0_diffuse;
varying vec4 v_l0_specular;
varying vec2 v_tex_coord;
varying vec4 v_model_color;
vec4 s0_t_color() {
    return texture2D(u_s0_t_body, v_tex_coord.st);
}
vec4 s1_t_color() {
    return texture2D(u_s1_t_body, v_tex_coord.st);
}
vec4 s2_t_color() {
    return texture2D(u_s2_t_body, v_tex_coord.st);
}
vec4 t_color() {
    vec4 color = vec4(1.0);
    if (u_surface0_) {
        color = s0_t_color();
    } else if (u_surface1_) {
        color = s1_t_color();
    } else if (u_surface2_) {
        color = s2_t_color();
    }
    return color;
}
vec4 l_color(vec4 color) {
    vec4 r = vec4(0.0);
    if (u_light0_) {
        r = r + (color * v_l0_diffuse + color * v_l0_specular);
    }
    return r;
}
vec4 frag_color() {
    vec4 c = t_color() * v_model_color;
    return c * u_ambient_color + l_color(c);
}
void main() {
    vec4 c = frag_color();
    gl_FragColor = c;
}
