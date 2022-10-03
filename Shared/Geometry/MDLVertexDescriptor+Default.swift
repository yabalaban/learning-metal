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
        vertexDescriptor.attributes[Position.index] = MDLVertexAttribute(name: MDLVertexAttributePosition, format: .float3, offset: offset, bufferIndex: VertexBuffer.index)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.attributes[Normal.index] = MDLVertexAttribute(name: MDLVertexAttributeNormal, format: .float3, offset: offset, bufferIndex: VertexBuffer.index)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.layouts[VertexBuffer.index] = MDLVertexBufferLayout(stride: offset)
        
        return vertexDescriptor
    }
    
    static var uvLayout: MDLVertexDescriptor {
        let vertexDescriptor = self.defaultLayout
        
        var offset = 0
        vertexDescriptor.attributes[UV.index] = MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate, format: .float2, offset: offset, bufferIndex: UVBuffer.index)
        offset += MemoryLayout<float2>.stride
        vertexDescriptor.layouts[UVBuffer.index] = MDLVertexBufferLayout(stride: offset)
        
        return vertexDescriptor
    }
    
    static var colorLayout: MDLVertexDescriptor {
        let vertexDescriptor = self.uvLayout
        
        var offset = 0
        vertexDescriptor.attributes[Color.index] = MDLVertexAttribute(name: MDLVertexAttributeColor, format: .float3, offset: offset, bufferIndex: ColorBuffer.index)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.layouts[ColorBuffer.index] = MDLVertexBufferLayout(stride: offset)
        
        return vertexDescriptor
    }
}
