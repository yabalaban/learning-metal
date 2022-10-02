//
//  TextureController.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

enum TextureController {
    static var textures: [String: MTLTexture] = [:]

    static func loadTexture(filename: String, device: MTLDevice) -> MTLTexture {
        let loader = MTKTextureLoader(device: device)
        if let texture = try? loader.newTexture(name: filename.fileName, scaleFactor: 1.0, bundle: Bundle.main, options: nil) {
            return texture
        }
        
        let options: [MTKTextureLoader.Option: Any] = [
            .origin: MTKTextureLoader.Origin.bottomLeft,
            .SRGB: false,
            .generateMipmaps: NSNumber(booleanLiteral: true)
        ]
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Failed to load texture \(filename)")
        }
        do {
            return try loader.newTexture(URL: url, options: options)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func texture(name: String, device: MTLDevice) -> MTLTexture {
        let texture = textures[name, default: self.loadTexture(filename: name, device: device)]
        if textures[name] == nil {
            textures[name] = texture
        }
        return texture
    }
}


