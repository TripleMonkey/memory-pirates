//
//  Card.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/25/23.
//

import Foundation
import SwiftUI

class Card: Identifiable {
    
    let id: UUID = UUID()
    let value: String
    
    // Card position
    //var faceUp = false
    var position: CardPosition = .faceDown
    
    init(imageString: String) {
        value = imageString
    }
}

enum CardPosition {
    case faceUp, faceDown, matched
}
