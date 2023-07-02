//
//  CardView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/27/23.
//

import SwiftUI

struct CardView: View {
    
    @StateObject private var gameVM = GameViewModel.shared
    
    @State var card: Card
    
    
    var body: some View {
        if card.matched {
            Image("matchedImage")
                .resizable()
                .scaledToFit()
        } else if card.faceUp {
            Image(card.value)
                .resizable()
                .scaledToFit()
        } else {
            Image("startingImage")
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    if !gameVM.playButtonIsActive {
                        gameVM.handleCardTap(tappedCard: card)
                    }
                }
        }
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(card: Card(imageString: "cardFace134"))
//    }
//}
