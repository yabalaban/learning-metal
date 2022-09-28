//
//  MetalView.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import SwiftUI
import MetalKit

struct MetalView: View {
    let options: Options
    @State private var renderer: Renderer
    @State private var metalView: MTKView

    init(options: Options) {
        let view = MTKView()
        let state = RendererState(choice: options.renderChoice)
        _renderer = State(initialValue: Renderer(view: view, state: state))
        _metalView = State(initialValue: view)
        self.options = options
    }
    
    var body: some View {
        VStack {
            MetalViewRepresentable(
                view: $metalView,
                renderer: renderer,
                options: options
            )
        }
    }
}

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
typealias MyMetalView = NSView
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
typealias MyMetalView = UIView
#endif

struct MetalViewRepresentable: ViewRepresentable {
    @Binding var view: MTKView
    let renderer: Renderer?
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
        renderer?.state = RendererState(choice: options.renderChoice)
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MetalView(options: Options())
            Text("Metal View")
        }
    }
}
