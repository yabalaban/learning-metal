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
}

final class ModelRegistry {
    lazy var models: [ModelType: Model] = {
        [
            .train: Model(name: "train.usd", device: Renderer.device),
            .house: Model(name: "lowpoly-house.obj", device: Renderer.device),
            .sonic: Model(name: "sonic-the-hedgehog.obj", device: Renderer.device),
        ]
    }()
    private unowned var device: MTLDevice
    
    init(device: MTLDevice) {
        self.device = device
    }
}
