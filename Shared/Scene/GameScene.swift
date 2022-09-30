//
//  GameScene.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

struct GameScene {
    private let inputController: InputController
    private(set) var models: [Model] = []
    private(set) lazy var camera = PlayerCamera(input: inputController)
    
    init(modelRegistry: ModelRegistry, inputController: InputController = .shared) {
        self.inputController = inputController
        models = [.house, .plane].compactMap { modelRegistry.models[$0] }
        camera.position = [0, 1.5, -5]
    }
}

// MARK: - Update
extension GameScene {
    mutating func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
}

