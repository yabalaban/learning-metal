//
//  TextureModel.metal
//  learning-metal
//
//  Created by Alexander Balaban.
//

#include <metal_stdlib>

#import "../Common.h"
#import "ShaderDefs.h"

using namespace metal;

vertex VertexOut vertex_texture_main(VertexIn in [[stage_in]],
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

fragment float4 fragment_texture_main(constant Params &params [[buffer(ParamsBuffer)]],
                                      VertexOut in [[stage_in]],
                                      texture2d<float> baseColorTexture [[texture(BaseColor)]]) {
    constexpr sampler textureSampler(filter::linear, address::repeat, mip_filter::linear, max_anisotropy(8));
    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
    return float4(baseColor, 1);
}
