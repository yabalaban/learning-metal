//
//  ShaderDefs.h
//  learning-metal
//
//  Created by Alexander Balaban.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
};

struct VertexInExt {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
};

struct VertexOutExt {
    float4 position [[position]];
    float3 normal;
    float2 uv;
};
