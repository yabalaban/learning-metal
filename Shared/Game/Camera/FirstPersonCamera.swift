//
//  FirstPersonCamera.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import CoreGraphics

struct FirstPersonCamera: Camera, Movement {
    let input: InputController
    var transform = Transform()
    var projectionMatrix: float4x4 {
        float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
    }
    var viewMatrix: float4x4 {
        (float4x4(translation: position) * float4x4(rotation: rotation)).inverse
    }
    private var aspect: Float = 1.0
    private var fov = Float(70).degreesToRadians
    private var near: Float = 0.1
    private var far: Float = 100
    
    init(input: InputController) {
        self.input = input
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float) {
        let transform = updateInput(deltaTime: deltaTime)
        rotation += transform.rotation
        position += transform.position
    }
}
