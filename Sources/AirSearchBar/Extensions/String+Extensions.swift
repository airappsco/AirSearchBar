//
//  String+Extensions.swift
//  AirSearchBar
//
//  Created by Gabriel on 28/09/23.
//  Copyright © 2020 Air Apps. All rights reserved.

import SwiftUI

public extension String {
    func commonSuffix(with other: String) -> String {
        let selfReversed = String(self.reversed())
        let otherReversed = String(other.reversed())
        var commonSuffix = ""

        for (selfChar, otherChar) in zip(selfReversed, otherReversed) {
            guard selfChar == otherChar else {
                break
            }

            commonSuffix.append(selfChar)
        }

        return String(commonSuffix.reversed())
    }

    func boldDifferenceFrom(_ original: String) -> Text {
        let commonPrefix = self.commonPrefix(with: original)
        let commonSuffix = self.commonSuffix(with: original)

        let prefixText = Text(commonPrefix)
        let suffixText = Text(commonSuffix)
        let differenceText = Text(self.dropFirst(commonPrefix.count).dropLast(commonSuffix.count)).bold()

        return prefixText + differenceText + suffixText
    }
}
