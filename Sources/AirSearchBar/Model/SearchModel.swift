//
//  SearchModel.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 Air Apps. All rights reserved.
//

import Foundation

@available(iOS 15.0, *)
struct SearchItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
}

@available(iOS 15.0, *)
class SearchModel: ObservableObject {
    @Published var dataSource: [SearchItem]
    var results: [SearchItem] = []

    init(dataSource: [String]) {
        self.dataSource = dataSource.map { .init(title: $0) }
    }
}
