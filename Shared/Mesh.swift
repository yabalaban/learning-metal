//
//  Mesh.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

struct Mesh {
    let vertexBuffers: [MTLBuffer]
    let submeshes: [Submesh]
}

extension Mesh {
    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh, device: MTLDevice) {
        vertexBuffers = mtkMesh.vertexBuffers.map { $0.buffer }
        submeshes = zip(mdlMesh.submeshes!, mtkMesh.submeshes).map { meshes in
            Submesh(mdlSubmesh: meshes.0 as! MDLSubmesh, mtkSubmesh: meshes.1, device: device)
        }
    }
}

struct Submesh {
    struct Textures {
        let baseColor: MTLTexture?
    }
    
    let indexCount: Int
    let indexType: MTLIndexType
    let indexBuffer: MTLBuffer
    let indexBufferOffset: Int
    let textures: Textures
}

extension Submesh {
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh, device: MTLDevice) {
        indexCount = mtkSubmesh.indexCount
        indexType = mtkSubmesh.indexType
        indexBuffer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffset = mtkSubmesh.indexBuffer.offset
        textures = Textures(material: mdlSubmesh.material, device: device)
    }
}

private extension Submesh.Textures {
    init(material: MDLMaterial?, device: MTLDevice) {
        func property(with semantic: MDLMaterialSemantic) -> MTLTexture? {
            guard let property = material?.property(with: semantic),
                  property.type == .string,
                  let filename = property.stringValue
            else { return nil }
            return TextureController.texture(name: filename, device: device)
        }
        
        baseColor = property(with: MDLMaterialSemantic.baseColor)
    }
}

