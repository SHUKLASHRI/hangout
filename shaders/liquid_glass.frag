#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

float sdf(vec2 p, vec2 b, float r) {
    vec2 d = abs(p) - b + vec2(r);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - r;   
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uSize;
    
    vec2 glassSize = uSize;
    vec2 glassCenter = uSize * 0.5;
    vec2 glassCoord = fragCoord - glassCenter;
    
    // Smooth rounded rectangle SDF
    float size = min(glassSize.x, glassSize.y);
    float inversedSDF = -sdf(glassCoord, glassSize * 0.5, 24.0) / size;
    
    if (inversedSDF < 0.0) {
        fragColor = texture(uTexture, uv);
        return;
    }
    
    // Liquid Distortion Logic (as per AmirHossein Aghajari's article)
    vec2 normalizedGlassCoord = normalize(glassCoord);
    
    // 1. Remap distance from center
    float distFromCenter = 1.0 - clamp(inversedSDF / 0.4, 0.0, 1.0);
    
    // 2. Create Lens Distortion Curve
    float distortion = 1.0 - sqrt(1.0 - pow(distFromCenter, 2.0));
    
    // 3. Calculate Pixel Offset (Bulge effect)
    vec2 offset = distortion * normalizedGlassCoord * glassSize * 0.1;
    vec2 glassColorCoord = fragCoord - offset;
    
    // 4. Edge-Only Chromatic Aberration
    float edge = smoothstep(0.0, 0.1, inversedSDF);
    vec2 shift = normalizedGlassCoord * (1.0 - edge) * 5.0;
    
    // 5. Sample background with aberration
    vec2 uvR = (glassColorCoord - shift) / uSize;
    vec2 uvG = glassColorCoord / uSize;
    vec2 uvB = (glassColorCoord + shift) / uSize;
    
    float r = texture(uTexture, uvR).r;
    float g = texture(uTexture, uvG).g;
    float b = texture(uTexture, uvB).b;
    
    vec3 color = vec3(r, g, b);
    
    // Subtle tinting and lighting
    color *= 0.98;
    
    fragColor = vec4(color, 1.0);
}
