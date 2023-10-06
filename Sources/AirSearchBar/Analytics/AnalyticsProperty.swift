//
//  AnalyticsProperty.swift
//  AirSearchBar
//
//  Created by Gabriel on 03/10/2023.
//  Copyright © 2023 Air Apps. All rights reserved.
//

import Foundation

public protocol AnalyticsProperty {}

extension AnalyticsProperty {
    public var stringValue: String? {
        if let value = self as? String {
            return value
        } else  if let value = self as? Int {
            return value.description
        } else  if let value = self as? Double {
            return value.description
        } else  if let value = self as? Float {
            return value.description
        } else  if let value = self as? Bool {
            return value.description
        } else  if let value = self as? Date {
            return value.description
        } else {
            return nil
        }
    }
}

extension String: AnalyticsProperty {}
extension Int: AnalyticsProperty {}
extension Double: AnalyticsProperty {}
extension Float: AnalyticsProperty {}
extension Bool: AnalyticsProperty {}
extension Date: AnalyticsProperty {}
extension Array: AnalyticsProperty {}
