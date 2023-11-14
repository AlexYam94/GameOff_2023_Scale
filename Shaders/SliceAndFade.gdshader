//https://godotshaders.com/shader/slice-and-fade-out/

shader_type canvas_item;

uniform vec2 direction = vec2(.0, .5);

uniform float fadeValue : hint_range(0., 1.);

uniform float fade : hint_range(0., 1.);

uniform float strip = 4.;

void fragment() {
	float offset = -fadeValue;
	vec2 norm = direction;
	vec2 pixels = SCREEN_UV / SCREEN_PIXEL_SIZE;
	vec2 pdir = vec2(norm.y, -norm.x);
	vec2 corrected_uv = UV + ((float(int(dot(pdir, pixels) / strip) & 0x1) * 2.) - 1.) * offset * pdir;
	vec4 color = texture(TEXTURE, corrected_uv);
	color.a *= clamp(1. - offset/fade, 0., 1.);
	COLOR = color;
}