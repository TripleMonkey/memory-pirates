//
//  PlayButton.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/28/23.
//

import SwiftUI

struct PlayButton: View {
    
    @StateObject var gameVM = GameViewModel.shared
    
    var body: some View {
        Button {
            gameVM.startGame()
        } label: {
            Label("Play", systemImage: "play.fill")
                .padding()
                .frame(minWidth: UIScreen.main.bounds.width*0.4)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton()
    }
}
