//
//  Hardware.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

final class Hardware {
    lazy var device: MTLDevice = {
        guard let device =  MTLCreateSystemDefaultDevice() else {
            fatalError("GPU is not supported")
        }
        return device
    }()
    lazy var commandQueue: MTLCommandQueue = {
        guard let queue = device.makeCommandQueue() else {
            fatalError("GPU is not supported")
        }
        return queue
    }()
    lazy var library: MTLLibrary = {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Default library is missing")
        }
        return library
    }()
    lazy var depthStencilState: MTLDepthStencilState? = {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return device.makeDepthStencilState(descriptor: descriptor)
    }()
}
