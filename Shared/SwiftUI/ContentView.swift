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
    @State var stageType: StageType = .house
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                HStack {
                    MetalView(options: Options(stageType: stageType))
                        .border(Color.black, width: Style.borderWidth)
                        .frame(width: Style.frameSize, height: Style.frameSize)
                    MetalView(options: .plain)
                        .border(Color.black, width: Style.borderWidth)
                        .frame(width: Style.frameSize, height: Style.frameSize)
                }
            }
            Picker(
                selection: $stageType,
                label: Text("Stage")) {
                    Text("House").tag(StageType.house)
                    Text("Sonic").tag(StageType.sonic)
                    Text("Train").tag(StageType.train)
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
