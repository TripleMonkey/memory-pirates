//
//  CardView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/27/23.
//

import SwiftUI

struct CardView: View {
    
    @StateObject var gameVM = GameViewModel.shared
    
    @State var imageName = "startingImage"
    var card: Card
    var cardValue: String
    var position: CardPosition
    
    
    init(card: Card) {
        self.card = card
        self.cardValue = card.value
        self.position = .faceDown
    }
    
    var body: some View {
        
        Image(imageName)
            .resizable()
            .scaledToFit()
            .opacity(gameVM.cardOpacity)
            .onTapGesture {
                // Only allow tap gesture from starting image
                if self.imageName == "startingImage" &&
                   !gameVM.playButtonIsActive {
                self.card.position = gameVM.handleCardTap(tappedCard: card)
               // Set image according to position
                switch card.position {
                case .faceDown:
                    self.imageName = "startingImage"
                case .faceUp:
                    self.imageName = cardValue
                case .matched:
                    self.imageName = "matchedImage"
                }
                
//                    card.position = .faceUp
//                    self.imageName = cardValue
//                    gameVM.handleCardTap(tappedCard: card)
//                }
//                //gameVM.currentMove.append(card)
//                gameVM.checkCard(card: card)
//                // Set image according to position
//                switch card.position {
//                case .faceDown:
//                    self.imageName = "startingImage"
//                case .faceUp:
//                    self.imageName = cardValue
//                case .matched:
//                    self.imageName = "matchedImage"
                }
            }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(imageString: "cardFace134"))
    }
}
