/*
 Empty List View Modifier and Extension
 Created by Nigel Krajewski on 10/28/23.
 */

import SwiftUI

/// View Modifier to display message when list contains no items
struct EmptyListMessage: ViewModifier {
    
    /// number of items in list to be used with a list view
    let listCount: Int
    /// string message to display when list is empty
    let message: String
    
    @ViewBuilder
    /// Displays list content or text placeholder
    /// - Parameter content: Content of list to be displayed in list view
    /// - Returns: list content or text placeholder if list is empty
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

// List View extension to use dot notation for implementing modifier on List view
extension List {
    /// View extension to add empty list message to list view when list is empty.
    /// - Parameters:
    ///   - listCount: Int count of current list data to display
    ///   - message: String output that will be shown when list is empty
    /// - Returns: Returns list content when list is not empty and Text view message in place of content when list is empty
    func emptyListMessage(listCount: Int, message: String) -> some View
    {
        return modifier(EmptyListMessage(listCount: listCount, message: message))
    }
}


/*
 Copyright 2023 Nigel Krajewski
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
