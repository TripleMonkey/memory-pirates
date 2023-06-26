//
//  Card.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/25/23.
//

import Foundation
import SwiftUI

class Card: Identifiable {
    
    @State var faceUp = false
    
    let id: UUID = UUID()
    private let value: String
    var currentPosition = "startingImage"
    
    init(imageString: String) {
        value = imageString
    }
    
    func flipCard() {
        faceUp.toggle()
        if faceUp {
            currentPosition = value
        } else {
            currentPosition = "startingImage"
        }
    }
}

