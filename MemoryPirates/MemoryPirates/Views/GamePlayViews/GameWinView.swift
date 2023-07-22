//
//  GameWinView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 7/18/23.
//

import SwiftUI

struct GameWinView: View {
    
    var body: some View {
        VStack {
            Image("completionImage")
                .resizable()
                .scaledToFit()
            Text("YOU WIN!")
                .font(.largeTitle)
                .fontWeight(.black)
                .fontDesign(.rounded)
                .foregroundColor(.white)
                .shadow(color: .red, radius: 5.0)
        }
    }
}

struct GameWinView_Previews: PreviewProvider {
    static var previews: some View {
        GameWinView()
    }
}
