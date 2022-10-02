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
