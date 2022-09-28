//
//  Model.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

final class Model: Transformable {
    let mesh: MTKMesh
    var transform = Transform()
    
    init(name: String, device: MTLDevice, vertexDescriptor: MDLVertexDescriptor = .defaultLayout) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else {
            fatalError("Model: \(name) not found")
        }
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: vertexDescriptor, bufferAllocator: allocator)
        guard let mdlMesh = asset.childObjects(of: MDLMesh.self).first as? MDLMesh else {
            fatalError("No mesh available")
        }
        do {
            self.mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - Rendering
extension Model {
    func render(encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        for submesh in mesh.submeshes {
            encoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: submesh.indexBuffer.offset
            )
        }
    }
}

