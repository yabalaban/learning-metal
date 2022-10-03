//
//  GameScene.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

protocol GameScene {
    var models: [Model] { get }
    var camera: Camera { get }
    var lighting: SceneLighting { get }
    
    mutating func update(deltaTime: Float)
    mutating func update(size: CGSize)
    mutating func setup(pipelineDescriptor: inout MTLRenderPipelineDescriptor)
}
