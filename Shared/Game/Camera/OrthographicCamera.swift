//
//  OrthographicCamera.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import CoreGraphics

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

