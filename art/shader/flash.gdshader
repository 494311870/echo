shader_type canvas_item;
uniform float hurt_intensity : hint_range(0, 1) = 0.0; // 控制混合强度（0为原色，1为全白）
uniform vec4 hurt_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);   // 闪白颜色（可自定义）

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    COLOR = mix(original_color, hurt_color, hurt_intensity * original_color.a); // 混合颜色，保留透明度
}