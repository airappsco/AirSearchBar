//
//  View+Extensions.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 Air Apps. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
