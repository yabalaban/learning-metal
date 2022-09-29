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

fragment float4 fragment_main(constant Params &params [[buffer(ParamsBuffer)]],
                              VertexOut in [[stage_in]],
                              texture2d<float> baseColorTexture [[texture(BaseColor)]]) {
    constexpr sampler textureSampler(filter::linear, address::repeat, mip_filter::linear, max_anisotropy(8));
    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
    return float4(baseColor, 1);
}
