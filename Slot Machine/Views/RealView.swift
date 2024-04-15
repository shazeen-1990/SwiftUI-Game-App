//
//  RealView.swift
//  Slot Machine
//
//  Created by Shazeen Thowfeek on 08/04/2024.
//

import SwiftUI

struct RealView: View {
    
    var body: some View {
        
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

#Preview {
    RealView()
        .previewLayout(.fixed(width: 220, height: 220))
}
