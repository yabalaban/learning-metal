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
    @State var modelType: ModelType = .house
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                HStack {
                    MetalView(options: Options(modelType: modelType))
                        .border(Color.black, width: Style.borderWidth)
                        .frame(width: Style.frameSize, height: Style.frameSize)
                    MetalView(options: .plain)
                        .border(Color.black, width: Style.borderWidth)
                        .frame(width: Style.frameSize, height: Style.frameSize)
                }
            }
            Picker(
                selection: $modelType,
                label: Text("Model")) {
                    Text("House").tag(ModelType.house)
                    Text("Train").tag(ModelType.train)
                    Text("Sonic").tag(ModelType.sonic)
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
