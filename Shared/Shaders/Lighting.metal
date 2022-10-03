//
//  Lighting.metal
//  learning-metal
//
//  Created by Alexander Balaban.
//

#include <metal_stdlib>
#import "Lighting.h"

using namespace metal;

float3 phongLighting(float3 normal, float3 position, constant Params &params, constant Light *lights, float3 baseColor) {
    float3 diffuse = 0;
    float3 ambient = 0;
    float3 specular = 0;
    
    float shininess = 32;
    float3 materialSpecularColor = float3(1, 1, 1);
    
    for (uint i = 0; i < params.lightCount; i++) {
        Light light = lights[i];
        switch (light.type) {
            case Sun: {
                float3 direction = normalize(-light.position);
                float intensity = saturate(-dot(direction, normal));
                diffuse += light.color * baseColor * intensity;
                if (intensity > 0) {
                    float3 reflection = reflect(direction, normal);
                    float3 viewDirection = normalize(params.cameraPosition);
                    float3 specularIntensity = pow(saturate(dot(reflection, viewDirection)), shininess);
                    specular += light.specularColor * materialSpecularColor * specularIntensity;
                }
                break;
            }
            case Point: {
                float d = distance(light.position, position);
                float3 direction = normalize(light.position - position);
                float attenuation = 1.0 / (light.attenuation.x + light.attenuation.y * d + light.attenuation.z * d * d);
                float intensity = saturate(dot(direction, normal));
                float3 color = light.color * baseColor * intensity;
                color *= attenuation;
                diffuse += color;
                break;
            }
            case Spot: {
                float d = distance(light.position, position);
                float3 direction = normalize(light.position - position);
                float3 coneDirection = normalize(light.coneDirection);
                float spot = dot(direction, -coneDirection);
                if (spot > cos(light.coneAngle)) {
                    float attenuation = 1.0 / (light.attenuation.x + light.attenuation.y * d + light.attenuation.z * d * d);
                    attenuation *= pow(spot, light.coneAttenuation);
                    float intensity = saturate(dot(direction, normal));
                    float3 color = light.color * baseColor * intensity;
                    color *= attenuation;
                    diffuse += color;
                }
                break;
            }
            case Ambient: {
                ambient += light.color;
                break;
            }
            case unused: {
                break;
            }
        }
    }
    return diffuse + specular + ambient;
}
