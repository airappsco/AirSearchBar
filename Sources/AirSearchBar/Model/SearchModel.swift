//
//  SearchModel.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 AirApps. All rights reserved.
//

import Foundation

struct SearchItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
}

class SearchModel: ObservableObject {
    @Published var dataSource: [SearchItem]
    var results: [SearchItem] = []

    init(dataSource: [String]) {
        self.dataSource = dataSource.map { .init(title: $0) }
    }
}
