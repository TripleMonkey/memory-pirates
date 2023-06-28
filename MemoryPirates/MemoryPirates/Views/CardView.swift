//
//  CardView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/27/23.
//

import SwiftUI

struct CardView: View {
    
    @StateObject var gameVM = GameViewModel()
    @State var imageName = "startingImage"
    var card: Card
    var cardValue: String
    
    init(card: Card) {
        self.card = card
        self.cardValue = card.value
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .onTapGesture {
                card.faceUp.toggle()
                print("Card face up: \(card.faceUp)")
                self.imageName = card.faceUp ? cardValue : "startingImage"
            }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(imageString: "cardFace134"))
    }
}
