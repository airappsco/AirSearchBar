//
//  Constants.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/23.
//  Copyright © 2020 Air Apps. All rights reserved.

import SwiftUI

enum Constants {
    static let customSearchBarHeight: CGFloat = 56
    static let searchResultsViewMaxHeight: CGFloat = 236
    static let defaultCornerRadius: CGFloat = 28
    static let dividerHeight: CGFloat = 0.5

    enum Padding {
        static let padding2: CGFloat = 2
        static let padding8: CGFloat = 8
        static let padding12: CGFloat = 12
        static let padding16: CGFloat = 16
        static let padding32: CGFloat = 32
    }

    enum SystemImage {
        static let magnifyingglass = "magnifyingglass"
        static let xMarkCircleFill = "xmark.circle.fill"
    }

    enum Colors {
        static let defaultShadow: Color = .black.opacity(0.2)
        static let magnifyingglassIcon = Color(red: 0.04, green: 0.52, blue: 1)
        static let xMarkCircleFillForegroundColor = Color(red: 0.75, green: 0.75, blue: 0.76)
        static let dividerBackgroundColor: Color = {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return Color(red: 0.41, green: 0.41, blue: 0.41)
            } else {
                return Color(red: 0.68, green: 0.68, blue: 0.68)
            }
        }()
    }
}
