shader_type canvas_item;

uniform sampler2D overlay_tex : repeat_enable, filter_nearest;
uniform float tex_scale = 90.0;
varying vec2 world_position;

void vertex() {
  world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float scale = 1.0 / tex_scale;
	
  bool is_red = (COLOR.r == 1.0 && COLOR.b == 0.0 && COLOR.g == 0.0 && COLOR.a == 1.0);

  if (is_red) {
    vec4 overlay_color = texture(overlay_tex, world_position * scale);
    COLOR = overlay_color;
  }
}