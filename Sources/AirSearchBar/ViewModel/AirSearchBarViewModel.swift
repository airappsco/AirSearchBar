//
//  AirSearchBarViewModel.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/23.
//  Copyright © 2020 Air Apps. All rights reserved.

import Foundation
import Combine

public class AirSearchBarViewModel: ObservableObject {
    // MARK: - Model
    @Published private var model: SearchModel

    // MARK: - Variables
    @Published var searchingText: String = ""

    public var didSearchKeyword: ((String) -> Void)? = nil
    public var results: [SearchItem] {
        model.results
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    public init(initialDataSource: [String],
                didSearchKeyword: ((String) -> Void)? = nil) {
        self.model = SearchModel(dataSource: initialDataSource)
        self.didSearchKeyword = didSearchKeyword

        self.bind()
    }
}

// MARK: - Public Methods
extension AirSearchBarViewModel {
    public func update(dataSource: [String]) {
        model.dataSource = dataSource.map { SearchItem(title: $0) }
    }
}

// MARK: - Private Methods
private extension AirSearchBarViewModel {
    func bind() {
        $searchingText
            .debounce(
                for: .seconds(0.0),
                scheduler: DispatchQueue.global(qos:.userInitiated)
            )
            .sink(
                receiveValue: { [weak self] searchText in
                    self?.searchItems(forKeyword:searchText)
                    self?.didSearchKeyword?(searchText)
                }
            )
            .store(in: &cancellables)
    }

    func searchItems(forKeyword searchingText: String) -> Void {
        if self.model.dataSource.count >= 1 {
            let founds = self.model.dataSource
                .filter {
                    if searchingText == "" {
                        return false
                    } else {
                        return $0
                            .title
                            .lowercased()
                            .contains(searchingText.lowercased())
                    }
                }

            self.model.results = founds
        }
    }
}
