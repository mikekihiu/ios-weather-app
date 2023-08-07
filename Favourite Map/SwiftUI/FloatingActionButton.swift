//
//  FloatingActionButton.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 07/08/2023.
//

import SwiftUI

struct FloatingActionButton: View {
    var body: some View {
        Image(systemName: "square.and.arrow.up")
            .foregroundColor(.white)
            .padding(16)
            .background(Color.blue)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
}

struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionButton()
    }
}
