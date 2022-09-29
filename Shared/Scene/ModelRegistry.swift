//
//  ModelRegistry.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

enum ModelType: Hashable {
    case train
    case house
    case sonic
    case plane
}

final class ModelRegistry {
    lazy var models: [ModelType: Model] = {
        [
            .house: Model(name: "lowpoly-house.obj", device: device, vertexDescriptor: .uvLayout),
            .train: Model(name: "train.usd", device: device),
            .sonic: Model(name: "sonic-the-hedgehog.obj", device: device, vertexDescriptor: .uvLayout),
            .plane: Model(name: "plane.obj", device: device, tiling: 16, scale: 40, vertexDescriptor: .uvLayout)
        ]
    }()
    private unowned var device: MTLDevice
    
    init(device: MTLDevice) {
        self.device = device
    }
}
