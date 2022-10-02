//
//  Options.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

struct Options: Hashable {
    enum Scene: Hashable {
        case house
        case train
        case sonic
    }
    
    let scene: Scene
}
