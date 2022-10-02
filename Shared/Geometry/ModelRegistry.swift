//
//  ModelRegistry.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

final class ModelRegistry {
    enum ModelType: String {
        case sonic = "sonic-the-hedgehog.obj"
        case train = "train.usd"
        case house = "lowpoly-house.obj"
        case plane = "plane.obj"
    }
    
    private var loaded: [ModelType: Model] = [:]
    private let device: MTLDevice
    
    init(device: MTLDevice) {
        self.device = device
    }
    
    func get(type: ModelType, vertexDescriptor: MDLVertexDescriptor) -> Model {
        let model = loaded[type, default: create(type: type, vertexDescriptor: vertexDescriptor)]
        if loaded[type] == nil {
            loaded[type] = model
        }
        return model
    }
    
    private func create(type: ModelType, vertexDescriptor: MDLVertexDescriptor) -> Model {
        return Model(name: type.rawValue, device: device, vertexDescriptor: vertexDescriptor)
    }
}
