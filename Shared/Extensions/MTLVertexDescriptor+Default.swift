//
//  MTLVertexDescriptor+Default.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

extension MTLVertexDescriptor {
    static var defaultLayout: MTLVertexDescriptor? {
        MTKMetalVertexDescriptorFromModelIO(.defaultLayout)
    }
    
    static var uvLayout: MTLVertexDescriptor? {
        MTKMetalVertexDescriptorFromModelIO(.uvLayout)
    }
}
