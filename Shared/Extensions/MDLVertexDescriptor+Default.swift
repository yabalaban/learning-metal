//
//  MDLVertexDescriptor+Default.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

extension MDLVertexDescriptor {
    static var defaultLayout: MDLVertexDescriptor {
        let vertexDescriptor = MDLVertexDescriptor()
        var offset = 0
        vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition, format: .float3, offset: 0, bufferIndex: 0)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1] = MDLVertexAttribute(name: MDLVertexAttributeNormal, format: .float3, offset: offset, bufferIndex: 0)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: offset)
        return vertexDescriptor
    }
}