//
//  SonicGameScene.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

struct SonicGameScene: GameScene {
   private static let vertexDescriptor: MDLVertexDescriptor = .uvLayout
   
   let models: [Model]
   private(set) var camera: Camera = PlayerCamera()
   private var defaultView: Transform {
       Transform(
           position: [0, 15, -32],
           rotation: .zero
       )
   }
   private unowned let library: MTLLibrary
   
   init(modelRegistry: ModelRegistry, library: MTLLibrary) {
       self.library = library
       var sonic = modelRegistry.get(type: .sonic, vertexDescriptor: Self.vertexDescriptor)
       sonic.rotation.y = Float(180).degreesToRadians
       models = [sonic]
       camera.transform = defaultView
   }
   
   mutating func update(deltaTime: Float) {
       camera.update(deltaTime: deltaTime)
   }
   
   mutating func update(size: CGSize) {
       camera.update(size: size)
   }
   
   mutating func setup(pipelineDescriptor: inout MTLRenderPipelineDescriptor) {
       pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_texture_main")
       pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_texture_main")
       pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(Self.vertexDescriptor)
   }
}

