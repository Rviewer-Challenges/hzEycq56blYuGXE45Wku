//
//  ContentView.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 03/05/22.
//

import SwiftUI

struct ContentView: View {
    @State private var moves: [String] = Array(repeating: "", count: 16)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
                ForEach(0..<16, id: \.self) { index in
                    ZStack {
                        Color.blue
                        Color.black
                            .opacity(moves[index] == "" ? 1 : 0)
                        Image("simpsons_bart1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(moves[index] != "" ? 1 : 0)
                    }
                    .frame(width: getWidth(), height: getHeight(), alignment: .center)
                    .cornerRadius(15)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
                    .onTapGesture(perform: {
                        withAnimation(Animation.easeIn(duration: 0.5)) {
                            moves[index] = "X"
                        }
                    })
                }
            }
            .padding(15)
        }
    }
    
    // MARK: CALCULATE WIDTH & HEIGHT
    func getWidth() -> CGFloat {
        let width = UIScreen.main.bounds.width - (30 + 30)
        return width / 4
    }
    
    func getHeight() -> CGFloat {
        let width = UIScreen.main.bounds.height - (200 + 60)
        return width / 4
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
