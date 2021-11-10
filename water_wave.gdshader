shader_type canvas_item;
render_mode unshaded;

uniform vec4 water_color : hint_color = vec4(0.16, 0.3, 0.58, 0.85);
uniform vec4 foam_color : hint_color = vec4(1, 1, 1, 0.8);

void fragment() {
	vec4 input = texture(TEXTURE, UV);
	
	if (input.a == 0.0) return;
	
	vec2 tiled_uvs = UV * 100.0;
	vec2 displacement = vec2(
		cos(TIME * 5.0 + tiled_uvs.x + tiled_uvs.y) * 0.001,
		cos(TIME + tiled_uvs.x + tiled_uvs.y) * 0.001
	);
	vec4 refraction = texture(SCREEN_TEXTURE, SCREEN_UV + displacement);
	vec4 water = mix(vec4(water_color.rgb, 1.0), refraction, 1.0 - water_color.a);
	
	// water = vec4(displacement * 1000.0, 0.0, 1.0);
	
	
	bool use_red = int(TIME) % 2 == 0;
	
	if(use_red){
		if (input.r > 0.5) {
			COLOR = foam_color;
		}else if(input.b > 0.5){
			COLOR = water;
		}else {
			COLOR = vec4(0);
		}
	}else {
		if(input.g > 0.5){
			COLOR = foam_color;
		}else {
			COLOR = water;
		}
	}
}