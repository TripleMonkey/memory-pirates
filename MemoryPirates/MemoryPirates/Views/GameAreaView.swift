//
//  GameAreaView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct GameAreaView: View {
    
    @StateObject var gameVM = GameViewModel()
    
    var openingCards: Playthrough {
        Playthrough(cards: GameViewModel().assignValues(cardCount: 30))
    }
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 70, maximum: 100), spacing: 1.0, alignment: .center)
    ]
    
    var body: some View {
        Group {
            LazyVGrid(columns: columns) {
                ForEach(gameVM.currentGame?.cards ?? openingCards.cards) { card in
                    CardView(cardValue: card.value)
                }
            }
            .frame(height: UIScreen.main.bounds.height*0.5)
            .background(Image("foggyWater")
                .resizable()
                .scaledToFill())
        }
    }
}

struct GameAreaView_Previews: PreviewProvider {
    static var previews: some View {
        GameAreaView()
    }
}
