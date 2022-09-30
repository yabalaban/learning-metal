//
//  Camera.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import CoreGraphics

protocol Camera: Transformable {
    var projectionMatrix: float4x4 { get }
    var viewMatrix: float4x4 { get }
    
    mutating func update(size: CGSize)
    mutating func update(deltaTime: Float)
}

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
        
        if input.leftMouseDown {
            rotation.x += input.mouseDelta.y * Settings.mousePanSensitivity
            rotation.y += input.mouseDelta.x * Settings.mousePanSensitivity
            rotation.x = max(-.pi / 2, min(rotation.x, .pi / 2))
            input.mouseDelta = .zero
        }
    }
    
}

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
    
    private let minDistance: Float = 0
    private let maxDistance: Float = 20
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

struct OrthographicCamera: Camera, Movement {
    let input: InputController
    var transform = Transform()
    private var aspect: CGFloat = 1
    private var viewSize: CGFloat = 10
    private var near: Float = 0.1
    private var far: Float = 100
    
    var viewMatrix: float4x4 {
        (float4x4(translation: position) * float4x4(rotation: rotation)).inverse
    }
    var projectionMatrix: float4x4 {
        let rect = CGRect(x: -viewSize * aspect * 0.5, y: viewSize * 0.5, width: viewSize * aspect, height: viewSize)
        return float4x4(orthographic: rect, near: near, far: far)
    }
    
    init(input: InputController) {
        self.input = input
    }
    
    mutating func update(size: CGSize) {
      aspect = size.width / size.height
    }
    
    mutating func update(deltaTime: Float) {
      let transform = updateInput(deltaTime: deltaTime)
      position += transform.position
      let zoom = input.mouseScroll.x + input.mouseScroll.y
      viewSize -= CGFloat(zoom)
      input.mouseScroll = .zero
    }
}
