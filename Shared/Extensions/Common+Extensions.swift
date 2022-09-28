//
//  Common+Extensions.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

extension Attributes {
    var index: Int {
        return Int(self.rawValue)
    }
}

extension BufferIndices {
    var index: Int {
        return Int(self.rawValue)
    }
}

extension TextureIndices {
    var index: Int {
        return Int(self.rawValue)
    }
}
