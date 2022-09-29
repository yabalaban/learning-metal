//
//  Renderer.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

final class Renderer: NSObject {
    struct Constants {
        static let fov: Float = 70
        static let near: Float = 0.1
        static let far: Float = 100
    }
    
    lazy var scene: GameScene = {
        let modelRegistry = ModelRegistry(device: cls.device)
        return GameScene(modelRegistry: modelRegistry)
    }()
    
    var pipelineState: MTLRenderPipelineState
    var timer: Float = 0.0
    var uniforms = Uniforms()
    var params = Params()
    
    init(view: MTKView) {
        self.pipelineState = cls.createPipelineState(colorPixelFormat: view.colorPixelFormat)
        super.init()
        view.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
        view.depthStencilPixelFormat = .depth32Float
        view.device = cls.device
        view.delegate = self
        mtkView(view, drawableSizeWillChange: view.bounds.size)
    }
}

// MARK: - Rendering
extension Renderer {
    func render(encoder: MTLRenderCommandEncoder) {
        let translation: float3 = [0, 1.5, -5]
        uniforms.viewMatrix = float4x4(translation: translation).inverse
        scene.update(deltaTime: timer)
        for model in scene.models {
            model.render(encoder: encoder, uniforms: &uniforms, params: &params)
        }
    }
}

// MARK: - MTKViewDelegate
extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        params.height = UInt32(size.height)
        params.width = UInt32(size.width)
        
        let aspect = Float(view.bounds.width / view.bounds.height)
        uniforms.projectionMatrix = float4x4(
            projectionFov: Constants.fov.degreesToRadians,
            near: Constants.near,
            far: Constants.far,
            aspect: aspect
        )
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        timer += 0.005
        
        renderEncoder.setDepthStencilState(cls.depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        render(encoder: renderEncoder)
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

// MARK: - Setup
extension Renderer {
    typealias cls = Renderer
    
    static var device: MTLDevice = {
        guard let device =  MTLCreateSystemDefaultDevice() else {
            fatalError("GPU is not supported")
        }
        return device
    }()
    static var commandQueue: MTLCommandQueue = {
        guard let queue = device.makeCommandQueue() else {
            fatalError("GPU is not supported")
        }
        return queue
    }()
    static var library: MTLLibrary = {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Default library is missing")
        }
        return library
    }()
    static var depthStencilState: MTLDepthStencilState? = {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return device.makeDepthStencilState(descriptor: descriptor)
    }()
    
    static func createPipelineState(colorPixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexFunction = cls.library.makeFunction(name: "vertex_main")
        pipelineDescriptor.fragmentFunction = cls.library.makeFunction(name: "fragment_main")
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.uvLayout
        do {
            return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
