//
//  Vertex.metal
//  learning-metal
//
//  Created by Alexander Balaban.
//

#include <metal_stdlib>

#import "../Common.h"
#import "../ShaderDefs.h"

using namespace metal;

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
