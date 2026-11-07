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
    
    let columnCount = 5
    
    // Flexible columns with no minimum width so the grid can shrink to fit the available space
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(maximum: 100), spacing: 1.0), count: columnCount)
    }
    
    var rowCount: Int {
        let cardCount = gameVM.currentDeck.cards.count
        return max(1, (cardCount + columnCount - 1) / columnCount)
    }
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: columns, spacing: 1.0) {
                ForEach(gameVM.currentDeck.cards) { card in
                    CardView(card: card)
                        .scaleEffect(gameVM.previewCards && largeScale ? 1.2 : 1.0)
                }
            }
            // Card images are square, so the grid as a whole is columns:rows.
            // Fitting to this ratio keeps the grid within both the available width and height.
            .aspectRatio(CGFloat(columnCount) / CGFloat(rowCount), contentMode: .fit)
            .onReceive(countDownTimer, perform: { _ in
                count -= 1
                largeScale.toggle()
                if count == 0 {
                    count = 5
                }
            })
            .padding()
            //.frame(minHeight: UIScreen.main.bounds.height*0.6)
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
