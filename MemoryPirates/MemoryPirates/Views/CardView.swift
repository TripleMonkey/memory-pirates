//
//  CardView.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/27/23.
//

import SwiftUI

struct CardView: View {
    
    @State var imageName = "startingImage"
    var cardValue: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .onTapGesture {
                self.imageName = self.imageName == cardValue ? "startingImage" : cardValue
            }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardValue: "cardFace12")
    }
}
