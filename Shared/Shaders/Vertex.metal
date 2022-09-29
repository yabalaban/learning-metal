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

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]]) {
    return (VertexOut) {
        .position = uniforms.projectionMatrix
            * uniforms.viewMatrix
            * uniforms.modelMatrix
            * in.position,
        .normal = in.normal,
        .uv = in.uv
    };
}
