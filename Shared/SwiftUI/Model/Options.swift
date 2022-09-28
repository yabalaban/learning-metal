//
//  Options.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import SwiftUI

enum RenderChoice: Hashable {
    case model(ModelType)
    case plain
}

final class Options: ObservableObject {
    @Published var renderChoice: RenderChoice
    
    init(modelType: ModelType) {
        renderChoice = .model(modelType)
    }
    
    init() {
        renderChoice = .plain
    }
    
    static var plain: Options {
        return Options()
    }
}
