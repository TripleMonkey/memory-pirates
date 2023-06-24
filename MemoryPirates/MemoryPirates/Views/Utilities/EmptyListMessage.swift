//
//  EmptyListMessage.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import SwiftUI

// View Modifier to display message when list contains no items
struct EmptyListMessage: ViewModifier {
    
    let listCount: Int
    let message: String
    
    @State var tapped: Bool = false
    
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if listCount > 0 {
            // Show list content
            content
        } else {
            // Short message
            Text(message)
                .padding()
        }
    }
}

extension View {
    func emptyListMessage(for listCount: Int, message: String) -> some View
    {
        return modifier(EmptyListMessage(listCount: listCount, message: message))
    }
}
