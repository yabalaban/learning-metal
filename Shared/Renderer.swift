//
//  Renderer.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

struct RendererState {
    let choice: RenderChoice
}

final class Renderer: NSObject {
    struct Constants {
        static let fov: Float = 70
        static let near: Float = 0.1
        static let far: Float = 100
    }
    
    var state: RendererState
    var pipelineStates: [RenderChoice: MTLRenderPipelineState]
    var timer: Float = 0.0
    var uniforms = Uniforms()
    var params = Params()
    
    init(view: MTKView, state: RendererState) {
        self.state = state
        self.pipelineStates = cls.populatePipelineStates(colorPixelFormat: view.colorPixelFormat)
        super.init()
        view.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
        view.depthStencilPixelFormat = .depth32Float
        view.device = cls.device
        view.delegate = self
        mtkView(view, drawableSizeWillChange: view.bounds.size)
    }
}

// MARK: - Drawing
extension Renderer {
    func renderModel(stageType: StageType, encoder: MTLRenderCommandEncoder) {
        guard let stage = cls.stageRegistry.stages[stageType] else { fatalError() }
        updateViewMatrix(for: stageType)
        for (type, var model) in stage.models {
            updateModelMatrix(for: type, model: &model)
            encoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 11)
            model.render(encoder: encoder, uniforms: &uniforms, params: &params)
        }
    }
    
    func renderPlain(encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(&params, length: MemoryLayout<Params>.stride, index: ParamsBuffer.index)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
    }
    
    func updateViewMatrix(for stageType: StageType) {
        let translation: float3
        switch stageType {
        case .train:
            translation = [0, 0, -2]
        case .house:
            translation = [0, 1.5, -5]
        case .sonic:
            translation = [0, 15, -32]
        }
        uniforms.viewMatrix = float4x4(translation: translation).inverse
    }
    
    func updateModelMatrix(for modelType: ModelType, model: inout Model) {
        switch modelType {
        case .train:
            model.position.y = -0.6
            model.rotation.y = sin(timer)
        case .house:
            model.rotation.y = sin(timer)
        case .sonic:
            model.position.y = -0.6
            model.rotation.y = sin(timer) + Float(180).degreesToRadians
        case .plane:
            model.scale = 40
            model.rotation.y = sin(timer)
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
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor),
              let pipelineState = pipelineStates[state.choice] else { return }
        
        timer += 0.005
        
        renderEncoder.setDepthStencilState(cls.depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        if case let .stage(stageType) = state.choice {
            renderModel(stageType: stageType, encoder: renderEncoder)
        } else {
            renderPlain(encoder: renderEncoder)
        }
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

// MARK: - Single setup
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
    static var stageRegistry: StageRegistry = {
        StageRegistry(modelRegistry: ModelRegistry(device: cls.device))
    }()
    
    static func populatePipelineStates(colorPixelFormat: MTLPixelFormat) -> [RenderChoice: MTLRenderPipelineState] {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        let plainPipelineState: MTLRenderPipelineState = {
            pipelineDescriptor.vertexFunction = cls.library.makeFunction(name: "vertex_plain")
            pipelineDescriptor.fragmentFunction = cls.library.makeFunction(name: "fragment_plain")
            do {
                return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            } catch {
                fatalError(error.localizedDescription)
            }
        }()

        let modelPipelineState: MTLRenderPipelineState = {
            pipelineDescriptor.vertexFunction = cls.library.makeFunction(name: "vertex_model")
            pipelineDescriptor.fragmentFunction = cls.library.makeFunction(name: "fragment_model")
            pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
            do {
                return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            } catch {
                fatalError(error.localizedDescription)
            }
        }()
        
        let textureModelPipelineState: MTLRenderPipelineState = {
            pipelineDescriptor.vertexFunction = cls.library.makeFunction(name: "vertex_texture_model")
            pipelineDescriptor.fragmentFunction = cls.library.makeFunction(name: "fragment_texture_model")
            pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.uvLayout
            do {
                return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            } catch {
                fatalError(error.localizedDescription)
            }
        }()
        
        return [
            .plain: plainPipelineState,
            .stage(.house): textureModelPipelineState,
            .stage(.sonic): textureModelPipelineState,
            .stage(.train): modelPipelineState,
        ]
    }
}
