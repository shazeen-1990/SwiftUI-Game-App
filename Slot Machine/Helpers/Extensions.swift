//
//  Extensions.swift
//  Slot Machine
//
//  Created by Shazeen Thowfeek on 08/04/2024.
//

import SwiftUI

extension Text {
    func scoreLabelStyle()->Text{
        self
            .foregroundColor(.white)
            .font(.system(size: 10, design: .rounded))
    }
    
    func scoreNumberStyle() -> Text {
        self
            .foregroundColor(.white)
            .font(.system(.title, design: .rounded))
            .fontWeight(.heavy)
    }
}
