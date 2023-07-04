//
//  GameAreaView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct GameAreaGridView: View {
    
    @StateObject private var gameVM = GameViewModel.shared
    
//    var openingCards: Deck {
//        Deck(cards: DeckViewModel().assignValues(cardCount: 30))
//    }
    
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
                }
            }
            .padding()
            .frame(minHeight: UIScreen.main.bounds.height*0.6)
            .background(Image("foggyWater")
                .resizable()
                .scaledToFill())
            if gameVM.playButtonIsActive {
                PlayButton()
            }
        }
    }
}

struct GameAreaView_Previews: PreviewProvider {
    static var previews: some View {
        GameAreaGridView()
    }
}
