//
//  ContentView.swift
//  Shared
//
//  Created by Alexander Balaban.
//

import SwiftUI

private struct Style {
    static let borderWidth: CGFloat = 2
    static let frameSize: CGFloat = 400
}

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                MetalView()
                    .border(Color.black, width: Style.borderWidth)
                    .frame(width: Style.frameSize, height: Style.frameSize)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
