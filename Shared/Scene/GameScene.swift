//
//  GameScene.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

struct GameScene {
    private(set) var models: [Model] = []
    
    init(modelRegistry: ModelRegistry) {
        self.models = [.house, .plane].compactMap { modelRegistry.models[$0] }
    }
}

// MARK: - Update
extension GameScene {
    mutating func update(deltaTime: Float) {
        for var model in models {
            model.rotation.y = sin(deltaTime)
        }
    }
}

