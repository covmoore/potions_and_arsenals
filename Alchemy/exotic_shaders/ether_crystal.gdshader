shader_type spatial;

uniform float time : hint_range(0.0, 10.0) = 0.0;
uniform vec4 base_color : source_color = vec4(0.5, 0.7, 1.0, 0.8);
uniform vec4 glow_color : source_color = vec4(0.8, 0.9, 1.0, 1.0);
uniform float glow_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float noise_scale : hint_range(0.1, 10.0) = 2.0;

void fragment() {
    vec3 world_pos = VERTEX;
    float noise = sin(world_pos.x * noise_scale + time) * cos(world_pos.y * noise_scale + time);
    float glow = smoothstep(0.4, 0.6, noise * glow_intensity);
    
    vec4 color = mix(base_color, glow_color, glow);
    ALBEDO = color.rgb;
    ALPHA = color.a;
    
    EMISSION = color.rgb * glow;
}
