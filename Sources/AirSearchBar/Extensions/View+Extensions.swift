//
//  View+Extensions.swift
//  AirSearchBar
//
//  Created by Gabriel on 28/09/23.
//  Copyright © 2020 Air Apps. All rights reserved.

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
