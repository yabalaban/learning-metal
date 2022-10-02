//
//  HouseGameScene.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

struct HouseGameScene: GameScene {
   private static let vertexDescriptor: MDLVertexDescriptor = .uvLayout
   
   let models: [Model]
   private(set) var camera: Camera = PlayerCamera()
   private var defaultView: Transform {
       Transform(
           position: [0, 1.5, -5],
           rotation: .zero
       )
   }
   private unowned let library: MTLLibrary
   
   init(modelRegistry: ModelRegistry, library: MTLLibrary) {
       self.library = library
       let house = modelRegistry.get(type: .house, vertexDescriptor: Self.vertexDescriptor)
       var plane = modelRegistry.get(type: .plane, vertexDescriptor: Self.vertexDescriptor)
       plane.scale = 40
       plane.tiling = 16
       models = [house, plane]
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

