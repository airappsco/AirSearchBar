//
//  Constants.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 Air Apps. All rights reserved.
//

import SwiftUI

public enum Constants {
    public static let customSearchBarHeight: CGFloat = 56
    public static let searchResultsViewMaxHeight: CGFloat = 236
    public static let defaultCornerRadius: CGFloat = 28
    public static let dividerHeight: CGFloat = 0.5

    public enum Padding {
        public static let padding2: CGFloat = 2
        public static let padding8: CGFloat = 8
        public static let padding12: CGFloat = 12
        public static let padding16: CGFloat = 16
        public static let padding32: CGFloat = 32
    }

    public enum SystemImage {
        public static let magnifyingglass = "magnifyingglass"
        public static let xMarkCircleFill = "xmark.circle.fill"
    }
}

extension Color {
    public static let defaultShadow: Color = .black.opacity(0.2)
    public static let magnifyingglassIconColor = Color(red: 0.04, green: 0.52, blue: 1)
    public static let xMarkCircleFillForegroundColor = Color(red: 0.75, green: 0.75, blue: 0.76)
    public static var dividerBackgroundColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1.0) : UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 1.0) })
    }
    public static var foregroundColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? .white : .black })
    }

    public static var backgroundColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0) : .white })
    }
}
