//
//  ContentView.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 03/05/22.
//

import SwiftUI

enum TypeBoard {
    case easy
    case medium
    case hard
}

struct Board {
    var columns: Int
    var rows: Int
}

struct ContentView: View {
    @State private var moves: [String] = Array(repeating: "", count: 9)
    @State private var difficulty: TypeBoard = .easy
    
    var body: some View {
        NavigationView {
        VStack {
            Picker("Choose difficulty", selection: $difficulty) {
                Text("Easy").tag(TypeBoard.easy)
                Text("Medium").tag(TypeBoard.medium)
                Text("Hard").tag(TypeBoard.hard)
            }.pickerStyle(.segmented)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
                ForEach(0..<moves.count, id: \.self) { index in
                    ZStack {
                        Color.blue
                        Color.red
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
        }
        .padding(15)
        .navigationTitle("Simpsons Memo")
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
