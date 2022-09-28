//
//  Vertex.metal
//  learning-metal
//
//  Created by Alexander Balaban.
//

#include <metal_stdlib>

using namespace metal;

typedef struct {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
} Uniforms;

typedef struct {
    uint width;
    uint height;
} Params;

struct VertexIn {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
};

vertex VertexOut vertex_model(VertexIn in [[stage_in]],
                              constant Uniforms &uniforms [[buffer(11)]]) {
    return (VertexOut) {
        .position = uniforms.projectionMatrix
            * uniforms.viewMatrix
            * uniforms.modelMatrix
            * in.position,
        .normal = in.normal
    };
}

constant float3 vertices[6] = {
    float3(-1,  1,  0),    // triangle 1
    float3( 1, -1,  0),
    float3(-1, -1,  0),
    float3(-1,  1,  0),    // triangle 2
    float3( 1,  1,  0),
    float3( 1, -1,  0)
};

vertex VertexOut vertex_plain(uint vertexID [[vertex_id]]) {
    return (VertexOut) {
        .position = float4(vertices[vertexID] * 0.8, 1)
    };
}
