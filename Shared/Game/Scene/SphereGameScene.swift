//
//  SphereGameScene.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

struct SphereGameScene: GameScene {
    private static let vertexDescriptor: MDLVertexDescriptor = .colorLayout
    
    let models: [Model]
    var camera: Camera {
        arcballCamera
    }
    let lighting = SceneLighting()
    private var arcballCamera: ArcballCamera = {
        var arcball = ArcballCamera()
        arcball.distance = 4.0
        return arcball
    }()
    private var defaultView: Transform {
        Transform(
            position: [-1.18, 1.57, -1.28],
            rotation: [-0.73, 13.3, 0.0]
        )
    }
    private unowned let library: MTLLibrary
    private var gizmo: Model
    private var sphere: Model
    
    init(modelRegistry: ModelRegistry, library: MTLLibrary) {
        self.library = library
        sphere = modelRegistry.get(type: .sphere, vertexDescriptor: Self.vertexDescriptor)
        gizmo = modelRegistry.get(type: .gizmo, vertexDescriptor: Self.vertexDescriptor)
        models = [gizmo, sphere]
        arcballCamera.transform = defaultView
    }
    
    mutating func update(deltaTime: Float) {
        let input = InputController.shared
        if input.keysPressed.contains(.one) {
            arcballCamera.transform = Transform()
        }
        if input.keysPressed.contains(.two) {
            arcballCamera.transform = defaultView
        }
        arcballCamera.update(deltaTime: deltaTime)
        updateGizmo()
    }
    
    mutating func update(size: CGSize) {
        arcballCamera.update(size: size)
    }
    
    mutating func setup(pipelineDescriptor: inout MTLRenderPipelineDescriptor) {
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_lighting_main")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_lighting_main")
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(Self.vertexDescriptor)
    }
    
    mutating func updateGizmo() {
        var forwardVector: float3 {
            let lookat = float4x4(eye: camera.position, center: .zero, up: [0, 1, 0])
            return [
                lookat.columns.0.z, lookat.columns.1.z, lookat.columns.2.z
            ]
        }
        var rightVector: float3 {
            let lookat = float4x4(eye: camera.position, center: .zero, up: [0, 1, 0])
            return [
                lookat.columns.0.x, lookat.columns.1.x, lookat.columns.2.x
            ]
        }
        
        gizmo.position = (forwardVector - rightVector) * 4
        gizmo.scale = 0.5
    }
}

