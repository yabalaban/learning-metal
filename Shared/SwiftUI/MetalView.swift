//
//  MetalView.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import SwiftUI
import MetalKit

struct MetalView: View {
    @State private var gameController: GameController
    @State private var metalView: MTKView
    private let options: Options

    init(options: Options) {
        let view = MTKView()
        _gameController = State(initialValue: GameController(metalView: view, options: options))
        _metalView = State(initialValue: view)
        self.options = options
    }
    
    var body: some View {
        VStack {
            MetalViewRepresentable(
                view: $metalView,
                gameController: gameController,
                options: options
            )
        }
    }
}

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalViewRepresentable: ViewRepresentable {
    @Binding var view: MTKView
    let gameController: GameController?
    let options: Options
    
#if os(macOS)
    func makeNSView(context: Context) -> some NSView {
        return view
    }
    func updateNSView(_ uiView: NSViewType, context: Context) {
        updateMetalView()
    }
#elseif os(iOS)
    func makeUIView(context: Context) -> MTKView {
        view
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        updateMetalView()
    }
#endif

    func updateMetalView() {
        gameController?.update(options: options, metalView: view)
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MetalView(options: Options(scene: .house))
            Text("Metal View")
        }
    }
}
