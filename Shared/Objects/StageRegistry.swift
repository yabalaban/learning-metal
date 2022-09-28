//
//  StageRegistry.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

final class StageRegistry {
    lazy var stages: [StageType: Stage] = {
        [
            .house: Stage(models: [.house, .plane].reduce(into: [:], { $0[$1] = modelRegistry.models[$1] })),
            .sonic: Stage(models: [.sonic].reduce(into: [:], { $0[$1] = modelRegistry.models[$1] })),
            .train: Stage(models: [.train].reduce(into: [:], { $0[$1] = modelRegistry.models[$1] })),
        ]
    }()
    private let modelRegistry: ModelRegistry
    
    init(modelRegistry: ModelRegistry) {
        self.modelRegistry = modelRegistry
    }
}

