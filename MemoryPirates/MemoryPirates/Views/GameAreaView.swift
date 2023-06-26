//
//  GameAreaView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

struct GameAreaView: View {
    
    @StateObject var gameVM = GameViewModel()
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 70, maximum: 100), spacing: 1.0, alignment: .center)
    ]
    
    var body: some View {
        Group {
            LazyVGrid(columns: columns) {
                ForEach(gameVM.currentGame.cardValues, id: \.description) { card in
                    Image("startingImage")
                        .resizable()
                        .scaledToFill()
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


struct gameCard: View {
    
    @State var showingValue = false
    
    var cardValue: String
    
    var body: some View {
        if showingValue {
            Image(cardValue)
        } else {
            Image("startingImage")
        }
    }
    
}
