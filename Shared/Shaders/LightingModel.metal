//
//  ColorModel.metal
//  learning-metal
//
//  Created by Alexander Balaban.
//

#include <metal_stdlib>
#import "Lighting.h"

using namespace metal;

struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
    float3 color [[attribute(Color)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 uv;
    float3 color;
    float3 worldPosition;
    float3 worldNormal;
};

vertex VertexOut vertex_lighting_main(const VertexIn in [[stage_in]],
                                      constant Uniforms &uniforms [[buffer(UniformsBuffer)]]) {
    return (VertexOut) {
        .position = uniforms.projectionMatrix
            * uniforms.viewMatrix
            * uniforms.modelMatrix
            * in.position,
        .uv = in.uv,
        .color = in.color,
        .worldPosition = (uniforms.modelMatrix * in.position).xyz,
        .worldNormal = uniforms.normalMatrix * in.normal,
    };
}

fragment float4 fragment_lighting_main(const VertexOut in [[stage_in]],
                                       constant Params &params [[buffer(ParamsBuffer)]],
                                       constant Light *lights [[buffer(LightBuffer)]],
                                       texture2d<float> baseColorTexture [[texture(BaseColor)]]) {
    constexpr sampler textureSampler(filter::linear, address::repeat, mip_filter::linear, max_anisotropy(8));
    float3 baseColor;
    if (is_null_texture(baseColorTexture)) {
        baseColor = in.color;
    } else {
        baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
    }
    float3 normalDirection = normalize(in.worldNormal);
    float3 color = phongLighting(normalDirection,
                                 in.worldPosition,
                                 params,
                                 lights,
                                 baseColor);
    return float4(color, 1);
}
