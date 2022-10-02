//
//  Train.metal
//  learning-metal
//
//  Created by Alexander Balaban.
//

#include <metal_stdlib>

#import "../Common.h"
#import "ShaderDefs.h"

using namespace metal;

vertex VertexOut vertex_model_main(VertexIn in [[stage_in]],
                                   constant Uniforms &uniforms [[buffer(UniformsBuffer)]]) {
    return (VertexOut) {
        .position = uniforms.projectionMatrix
        * uniforms.viewMatrix
        * uniforms.modelMatrix
        * in.position,
            .normal = in.normal
    };
}

fragment float4 fragment_model_main(constant Params &params [[buffer(ParamsBuffer)]],
                                    VertexOut in [[stage_in]]) {
    float4 sky = float4(0.34, 0.9, 1.0, 1.0);
    float4 earth = float4(0.29, 0.58, 0.2, 1.0);
    float intensity = in.normal.y * 0.5 + 0.5;
    return mix(earth, sky, intensity);
}
