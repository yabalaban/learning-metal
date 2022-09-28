//
//  Model.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

final class Model: Transformable {
    let meshes: [Mesh]
    let name: String
    var transform = Transform()
    var tiling: UInt32 = 1
    
    init(name: String, device: MTLDevice, tiling: UInt32 = 1, vertexDescriptor: MDLVertexDescriptor = .defaultLayout) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else {
            fatalError("Model: \(name) not found")
        }
        self.name = name
        self.tiling = tiling

        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: vertexDescriptor, bufferAllocator: allocator)
        do {
            let (mdlMeshes, mtkMeshes) = try MTKMesh.newMeshes(asset: asset, device: device)
            meshes = zip(mdlMeshes, mtkMeshes).map { Mesh(mdlMesh: $0.0, mtkMesh: $0.1, device: device) }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - Rendering
extension Model {
    func render(encoder: MTLRenderCommandEncoder, uniforms: inout Uniforms, params: inout Params) {
        params.tiling = tiling
        uniforms.modelMatrix = transform.modelMatrix
        
        encoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: UniformsBuffer.index)
        encoder.setFragmentBytes(&params, length: MemoryLayout<Params>.stride, index: ParamsBuffer.index)

        meshes.forEach { mesh in
            mesh.vertexBuffers.enumerated().forEach { (index, buffer) in
                encoder.setVertexBuffer(buffer, offset: 0, index: index)
            }
            mesh.submeshes.forEach { submesh in
                encoder.setFragmentTexture(submesh.textures.baseColor, index: BaseColor.index)
                encoder.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer,
                    indexBufferOffset: submesh.indexBufferOffset
                )
            }
        }
    }
}
