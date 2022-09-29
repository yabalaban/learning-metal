//
//  MetalView.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import SwiftUI
import MetalKit

struct MetalView: View {
    @State private var renderer: Renderer
    @State private var metalView: MTKView

    init() {
        let view = MTKView()
        _renderer = State(initialValue: Renderer(view: view))
        _metalView = State(initialValue: view)
    }
    
    var body: some View {
        VStack {
            MetalViewRepresentable(
                view: $metalView,
                renderer: renderer
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
        
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MetalView()
            Text("Metal View")
        }
    }
}
