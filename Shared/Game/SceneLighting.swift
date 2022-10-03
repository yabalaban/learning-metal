//
//  SceneLighting.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

struct SceneLighting {
    static var `default`: Light {
        var light = Light()
        light.position = [0, 0, 0]
        light.color = [1, 1, 1]
        light.specularColor = [0.6, 0.6, 0.6]
        light.attenuation = [1, 0, 0]
        light.type = Sun
        return light
    }
    
    let sunlight: Light = {
        var light = SceneLighting.default
        light.position = [1, 2, -2]
        return light
    }()
    let ambient: Light = {
        var light = SceneLighting.default
        light.color = [0.05, 0.1, 0]
        light.type = Ambient
        return light
    }()
    let redLight: Light = {
        var light = SceneLighting.default
        light.position = [-0.8, 0.76, -0.18]
        light.color = [1, 0, 0]
        light.attenuation = [0.5, 2, 1]
        light.type = Point
        return light
    }()
    let spotlight: Light = {
        var light = SceneLighting.default
        light.position = [-0.64, 0.64, -1.07]
        light.color = [1, 0, 1]
        light.attenuation = [1, 0.5, 0]
        light.coneAngle = Float(40).degreesToRadians
        light.coneDirection = [0.5, -0.7, 1]
        light.coneAttenuation = 8
        light.type = Spot
        return light
    }()
    var lights: [Light] = []
    
    init() {
        lights = [sunlight, ambient, redLight, spotlight]
    }
}
