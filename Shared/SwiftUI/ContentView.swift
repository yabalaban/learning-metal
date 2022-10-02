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
    @State var gameScene: Options.Scene = .house
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                MetalView(options: Options(scene: gameScene))
                    .border(Color.black, width: Style.borderWidth)
                    .frame(width: Style.frameSize, height: Style.frameSize)
            }
            Picker(
                selection: $gameScene,
                label: Text("Scene")) {
                    Text("House").tag(Options.Scene.house)
                    Text("Sonic").tag(Options.Scene.sonic)
                    Text("Train").tag(Options.Scene.train)
                }
                .pickerStyle(SegmentedPickerStyle())
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
