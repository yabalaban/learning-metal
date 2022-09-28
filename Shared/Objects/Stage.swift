//
//  Stage.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import Foundation

enum StageType: Hashable {
    case house
    case sonic
    case train
}

struct Stage {
    let models: [ModelType: Model]
}
