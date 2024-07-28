shader_type spatial;

uniform vec4 color1 : source_color = vec4(1.0, 0.8, 0.5, 1.0);
uniform vec4 color2 : source_color = vec4(0.5, 1.0, 0.8, 1.0);
uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.5, 1.0);
uniform float glow_strength : hint_range(0.0, 1.0) = 0.8;
uniform float sparkle_speed : hint_range(0.0, 10.0) = 1.0;
uniform float sparkle_intensity : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    // Base color with gradient effect
    float time = TIME * 0.5;
    vec3 gradient = mix(color1.rgb, color2.rgb, sin(VERTEX.y + time) * 0.5 + 0.5);

    // Adding glow effect
    vec3 glow = glow_color.rgb * glow_strength;

    // Combining base color and glow
    vec3 final_color = gradient + glow;

    ALBEDO = final_color;
    EMISSION = glow;
    ALPHA = 1.0;;
}
