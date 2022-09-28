//
//  Options.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import SwiftUI

enum RenderChoice: Hashable {
    case stage(StageType)
    case plain
}

final class Options: ObservableObject {
    @Published var renderChoice: RenderChoice
    
    init(stageType: StageType) {
        renderChoice = .stage(stageType)
    }
    
    init() {
        renderChoice = .plain
    }
    
    static var plain: Options {
        return Options()
    }
}
