//
//  GameAreaView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct GameAreaGridView: View {
    
    @StateObject private var gameVM = GameViewModel.shared
    
    var countDownTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var count = 5
    @State var largeScale = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 70, maximum: 100), spacing: 1.0, alignment: .leading),
        GridItem(.flexible(minimum: 70, maximum: 100), spacing: 1.0, alignment: .leading),
        GridItem(.flexible(minimum: 70, maximum: 100), spacing: 1.0, alignment: .leading),
        GridItem(.flexible(minimum: 70, maximum: 100), spacing: 1.0, alignment: .leading),
        GridItem(.flexible(minimum: 70, maximum: 100), spacing: 1.0, alignment: .leading)
        
    ]
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: columns) {
                ForEach(gameVM.currentDeck.cards) { card in
                    CardView(card: card)
                        .scaleEffect(gameVM.previewCards && largeScale ? 1.2 : 1.0)
                }
            }
            .onReceive(countDownTimer, perform: { _ in
                count -= 1
                largeScale.toggle()
                if count == 0 {
                    count = 5
                }
            })
            .padding()
            .frame(minHeight: UIScreen.main.bounds.height*0.6)
            .background(Image("foggyWater")
                .resizable()
                .scaledToFill())
            if gameVM.playButtonIsActive {
                PlayButton()
            }
            if !gameVM.playButtonIsActive && gameVM.matchCount == 15 {
                GameWinView()
            }
        }
    }
}

struct GameAreaView_Previews: PreviewProvider {
    static var previews: some View {
        GameAreaGridView()
    }
}
