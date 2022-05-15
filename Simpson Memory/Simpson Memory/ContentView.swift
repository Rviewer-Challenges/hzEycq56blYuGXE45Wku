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
    @State private var currentBoardConfig: Board = Board(columns: 4, rows: 4)
    @State private var moves: [String] = Array(repeating: "", count: 16)
    @State private var difficulty: TypeBoard = .easy
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("3")
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("1")
                        }
                    }
                    Picker("Choose difficulty", selection: $difficulty) {
                        Text("Easy").tag(TypeBoard.easy)
                        Text("Medium").tag(TypeBoard.medium)
                        Text("Hard").tag(TypeBoard.hard)
                    }.pickerStyle(.segmented).onChange(of: difficulty) { _ in
                        self.changeBoard()
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: currentBoardConfig.columns), spacing: 15) {
                        ForEach(0..<moves.count, id: \.self) { index in
                            ZStack {
                                Color.blue
                                ZStack {
                                    Color.gray.opacity(0.5)
                                    Image("simpsons_smithers")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                    .opacity(moves[index] == "" ? 1 : 0)
                                Image("simpsons_bart1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .opacity(moves[index] != "" ? 1 : 0)
                            }
                            .frame(width: getWidth(), height: getHeight(proxy), alignment: .center)
                            .cornerRadius(15)
                            .rotation3DEffect(
                                .init(degrees: moves[index] != "" ? 180 : 0),
                                axis: (x: 0.0, y: 1.0, z: 0.0),
                                anchor: .center,
                                anchorZ: 0.0,
                                perspective: 1.0
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0.0, y: 0.0)
                            .onTapGesture(perform: {
                                withAnimation(Animation.easeIn(duration: 0.5)) {
                                    if moves[index] == "" {
                                        moves[index] = "X"
                                    } else {
                                        moves[index] = ""
                                    }
                                }
                            })
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(15)
                .navigationTitle("Simpsons Memo")
                .navigationBarHidden(true)
            }
        }
    }
    
    // MARK: CALCULATE WIDTH & HEIGHT
    func getWidth() -> CGFloat {
        let width = UIScreen.main.bounds.width - (30 + 30)
        return width / CGFloat(currentBoardConfig.columns)
    }
    
    func getHeight(_ proxyReader: GeometryProxy) -> CGFloat {
        let padding = currentBoardConfig.rows == 4 ? 150 : 180
        let calculatedHeight = (proxyReader.size.height - CGFloat(padding)) / CGFloat(currentBoardConfig.rows)
        return calculatedHeight < 0 ? 129.25 : calculatedHeight
    }
    
    func changeBoard() {
        switch difficulty {
        case .easy:
            currentBoardConfig = Board(columns: 4, rows: 4)
            moves = Array(repeating: "", count: 16)
        case .medium:
            currentBoardConfig = Board(columns: 4, rows: 6)
            moves = Array(repeating: "", count: 24)
        case .hard:
            currentBoardConfig = Board(columns: 5, rows: 6)
            moves = Array(repeating: "", count: 30)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
