//
//  TrainGameScene.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

struct TrainGameScene: GameScene {
    private static let vertexDescriptor: MDLVertexDescriptor = .uvLayout
    
    let models: [Model]
    private(set) var camera: Camera = PlayerCamera()
    private var defaultView: Transform {
        Transform(
            position: [0, 0, -2],
            rotation: .zero
        )
    }
    private unowned let library: MTLLibrary
    
    init(modelRegistry: ModelRegistry, library: MTLLibrary) {
        self.library = library
        var train = modelRegistry.get(type: .train, vertexDescriptor: Self.vertexDescriptor)
        train.position.y = -0.6
        models = [train]
        camera.transform = defaultView
    }
    
    mutating func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func setup(pipelineDescriptor: inout MTLRenderPipelineDescriptor) {
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_model_main")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_model_main")
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(Self.vertexDescriptor)
    }
}
