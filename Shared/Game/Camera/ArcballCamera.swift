//
//  ArcballCamera.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import CoreGraphics

struct ArcballCamera: Camera {
    let input: InputController
    var transform = Transform()
    var projectionMatrix: float4x4 {
        float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
    }
    var viewMatrix: float4x4 {
        let matrix: float4x4
        if target == position {
            matrix = (float4x4(translation: target) * float4x4(rotationYXZ: rotation)).inverse
        } else {
            matrix = float4x4(eye: position, center: target, up: [0, 1, 0])
        }
        return matrix
    }
    var target: float3 = .zero
    var distance: Float = 2.5
    private(set) var fov = Float(70).degreesToRadians
    private(set) var aspect: Float = 1.0
    private(set) var near: Float = 0.1
    private(set) var far: Float = 100
    
    private let minDistance: Float = 0
    private let maxDistance: Float = 20
    
    init(input: InputController = .shared) {
        self.input = input
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float) {
        distance -= (input.mouseScroll.x + input.mouseScroll.y) * Settings.mouseScrollSensitivity
        distance = min(maxDistance, distance)
        distance = max(minDistance, distance)
        input.mouseScroll = .zero
        
        if input.leftMouseDown {
            rotation.x += input.mouseDelta.y * Settings.mousePanSensitivity
            rotation.y += input.mouseDelta.x * Settings.mousePanSensitivity
            rotation.x = max(-.pi / 2, min(rotation.x, .pi / 2))
            input.mouseDelta = .zero
        }
        
        let rotate = float4x4(rotationYXZ: [-rotation.x, rotation.y, 0])
        let distance = float4(0, 0, -distance, 0)
        let rotated = rotate * distance
        position = target + rotated.xyz
    }
}
