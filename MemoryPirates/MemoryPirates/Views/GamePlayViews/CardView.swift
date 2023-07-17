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
    
    var scaleAnimation: Animation {
        .easeIn(duration: 5.0)
        .repeatCount(5)
    }
    
    var body: some View {
        if card.matched {
            Image("matchedImage")
                .resizable()
                .scaledToFit()
                .opacity(0.7)
        } else if card.faceUp {
            Image(card.value)
                .resizable()
                .scaledToFit()
                .scaleEffect(gameVM.previewCards ? 0.5 : 1.0, anchor: .center)
                .animation(scaleAnimation, value: gameVM.previewCards)
        } else if !card.faceUp && !card.matched {
            Image("startingImage")
                .resizable()
                .scaledToFit()
                .opacity(gameVM.playButtonIsActive ? 0.5 : 1.0)
                .onTapGesture {
                    if !gameVM.playButtonIsActive {
                        gameVM.handleCardTap(tappedCard: card)
                    }
                }
        }
    }
}
