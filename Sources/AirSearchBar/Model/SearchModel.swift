//
//  SearchModel.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 AirApps. All rights reserved.
//

import Foundation

public struct SearchItem: Identifiable, Hashable {
    public var id = UUID()
    var title: String
}

class SearchModel {
    public var dataSource: [SearchItem]
    public var results: [SearchItem] = []

    init(dataSource: [String]) {
        self.dataSource = dataSource.map { SearchItem(title: $0) }
    }
}
