//
//  SearchModel.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 AirApps. All rights reserved.
//

import Foundation
import SwiftUI

public struct SearchItem: Identifiable, Hashable {
    public var id = UUID()
    var title: String

    public init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}

class SearchModel {
    @Binding public var dataSource: [SearchItem]
    public var results: [SearchItem] = []

    init(dataSource: Binding<[SearchItem]>) {
        _dataSource = dataSource
    }
}
