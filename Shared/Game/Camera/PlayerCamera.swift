//
//  PlayerCamera.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import CoreGraphics

struct PlayerCamera: Camera, Movement {
    let input: InputController
    var transform = Transform()
    var projectionMatrix: float4x4 {
        float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
    }
    var viewMatrix: float4x4 {
        let rotate = float4x4(rotationYXZ: [-rotation.x, rotation.y, 0])
        return (float4x4(translation: position) * rotate).inverse
    }
    private var aspect: Float = 1.0
    private var fov = Float(70).degreesToRadians
    private var near: Float = 0.1
    private var far: Float = 100
    
    init(input: InputController = .shared) {
        self.input = input
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float) {
        let transform = updateInput(deltaTime: deltaTime)
        rotation += transform.rotation
        position += transform.position
        
        if input.leftMouseDown {
            rotation.x += input.mouseDelta.y * Settings.mousePanSensitivity
            rotation.y += input.mouseDelta.x * Settings.mousePanSensitivity
            rotation.x = max(-.pi / 2, min(rotation.x, .pi / 2))
            input.mouseDelta = .zero
        }
    }
    
}
