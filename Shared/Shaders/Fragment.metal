//
//  Fragment.metal
//  learning-metal
//
//  Created by Alexander Balaban.
//

#include <metal_stdlib>

#import "../Common.h"
#import "../ShaderDefs.h"

using namespace metal;

fragment float4 fragment_plain(constant Params &params [[buffer(12)]],
                               VertexOut in [[stage_in]]) {
    float radius = 0.2;
    float center = 0.5;
    float2 uv = in.position.xy / params.width;
    
    if (step(length(uv - center), radius)) {
        return float4(0.12, 0.25, 0.75, 1);
    } else {
        float3 red = float3(1, 0, 0);
        float3 blue = float3(0, 0, 1);
        float smooth = smoothstep(0, params.width, in.position.x);
        float3 color = mix(red, blue, smooth);
        return float4(color, 1);
    }
}

fragment float4 fragment_model(constant Params &params [[buffer(12)]],
                               VertexOut in [[stage_in]]) {
    float4 sky = float4(0.34, 0.9, 1.0, 1.0);
    float4 earth = float4(0.29, 0.58, 0.2, 1.0);
    float intensity = in.normal.y * 0.5 + 0.5;
    return mix(earth, sky, intensity);
}
