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
    var faceUp = false
    
    init(imageString: String) {
        value = imageString
    }
}

