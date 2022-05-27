//
//  GameView.swift
//  Simpson Memory
//
//  Created by Jonathan Torres on 20/05/22.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Picker("Choose difficulty", selection: $viewModel.difficulty) {
                    Text("Easy").tag(TypeBoard.easy)
                    Text("Medium").tag(TypeBoard.medium)
                    Text("Hard").tag(TypeBoard.hard)
                }.pickerStyle(.segmented).onChange(of: viewModel.difficulty) { _ in
                    viewModel.changeBoard()
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: viewModel.currentBoard.columns), spacing: 15) {
                    ForEach(0..<viewModel.currentBoard.total, id: \.self) { index in
                        BoardItemView(proxy: proxy, move: viewModel.moves[index], face: viewModel.faces[index], board: viewModel.currentBoard)
                        .onTapGesture(perform: {
                            withAnimation(Animation.easeIn(duration: 0.5)) {
                                viewModel.processPlayerMove(for: index)
                            }
                        })
                    }
                }
                .disabled(viewModel.isBoardDisable)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(15)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(viewModel.points)")
                }
            }
            .alert("You Win!", isPresented: $viewModel.isWinner) {
                Button("Yujuuuu", role: .cancel) { viewModel.reset() }
            }
        }.onAppear {
            viewModel.initBorad()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .preferredColorScheme(.dark)
    }
}
