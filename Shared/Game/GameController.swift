//
//  GameController.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import MetalKit

final class GameController: NSObject {
    private var options: Options {
        didSet { scene = makeScene() }
    }
    private let renderer: Renderer
    private let hardware: Hardware = Hardware()
    private var fps: Double = 0.0
    private var deltaTime: Double = 0.0
    private var lastTime: Double = CFAbsoluteTimeGetCurrent()
    
    private lazy var modelRegistry: ModelRegistry = {
        ModelRegistry(device: hardware.device)
    }()
    private lazy var scene: GameScene = {
        makeScene()
    }()
    
    init(metalView: MTKView, options: Options) {
        renderer = Renderer(view: metalView, hardware: hardware)
        self.options = options
        super.init()
        renderer.setup(scene: &scene, in: metalView)
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        fps = Double(metalView.preferredFramesPerSecond)
        metalView.delegate = self
    }
    
    private func makeScene() -> GameScene {
        let scene: GameScene
        switch options.scene {
        case .sphere:
            scene = SphereGameScene(modelRegistry: modelRegistry,
                                    library: hardware.library)
        case .train:
            scene = TrainGameScene(modelRegistry: modelRegistry,
                                   library: hardware.library)
        case .sonic:
            scene = SonicGameScene(modelRegistry: modelRegistry,
                                   library: hardware.library)
        case .house:
            scene = HouseGameScene(modelRegistry: modelRegistry,
                                   library: hardware.library)
        }
        return scene
    }
}

// MARK: - MTKViewDelegate
extension GameController: MTKViewDelegate {
    func update(options: Options, metalView: MTKView) {
        self.options = options
        renderer.setup(scene: &scene, in: metalView)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.update(size: size)
        renderer.mtkView(view, drawableSizeWillChange: size)
    }
    
    func draw(in view: MTKView) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = (currentTime - lastTime)
        lastTime = currentTime
        scene.update(deltaTime: Float(deltaTime))
        renderer.draw(scene: &scene, in: view)
    }
}
