//
//  Renderer.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

final class Renderer: NSObject {
    private let hardware: Hardware
    private var pipelineState: MTLRenderPipelineState?
    private var uniforms = Uniforms()
    private var params = Params()
    
    init(view: MTKView, hardware: Hardware) {
        self.hardware = hardware
        super.init()
        view.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
        view.depthStencilPixelFormat = .depth32Float
        view.device = hardware.device
    }
}

// MARK: - Rendering
extension Renderer {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func setup(scene: inout GameScene, in view: MTKView) {
        pipelineState = createPipelineState(scene: &scene, colorPixelFormat: view.colorPixelFormat)
    }
    
    func draw(scene: inout GameScene, in view: MTKView) {
        guard let commandBuffer = hardware.commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor),
              let pipelineState = pipelineState
        else { return }
        
        updateUniforms(scene: &scene)
        
        renderEncoder.setDepthStencilState(hardware.depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        for model in scene.models {
            model.render(encoder: renderEncoder, uniforms: &uniforms, params: &params)
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    private func updateUniforms(scene: inout GameScene) {
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
    }
    
    private func createPipelineState(scene: inout GameScene, colorPixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
        var pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        scene.setup(pipelineDescriptor: &pipelineDescriptor)
        do {
            return try hardware.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
