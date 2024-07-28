shader_type spatial;

uniform float time : hint_range(0.0, 10.0);
uniform vec4 color : source_color = vec4(0.1, 0.0, 0.2, 1.0);

void fragment() {
    vec2 uv = FRAGCOORD.xy / vec2(512.0, 512.0);
    float noise = sin(uv.x * 10.0 + time) * cos(uv.y * 10.0 + time);
    float intensity = (sin(uv.y * 10.0 + time * 2.0) + 1.0) / 2.0;
    vec4 final_color = color * (0.5 + 0.5 * noise);
    final_color.rgb *= intensity;
    ALBEDO = final_color.rgb;
}
