//
//  AirSearchBarViewModel.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 Air Apps. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public class AirSearchBarViewModel: ObservableObject {
    // MARK: - Model
    @Published private var model: SearchModel

    // MARK: - Variables
    @Published var searchingText: String = ""
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Public variables
    public var didSearchKeywordSubject: PassthroughSubject<String, Never> = .init()
    public var didFinishSearchKeywordSubject: PassthroughSubject<String, Never> = .init()
    public var onEditingChanged: PassthroughSubject<Bool, Never> = .init()
    public var analyticsSubject: PassthroughSubject<AirSearchBar.AirSearchBarAnalytics, Never> = .init()
    public var shouldShowSearchResults: Bool {
        results.isEmpty
        ? false
        : (results.count == 1 && results.first?.title == searchingText) == false
    }

    var shouldForceHideSearchResults = false
    var results: [SearchItem] {
        model.results
    }

    // MARK: - Initializer
    public init(
        initialDataSource: [String]
    ) {
        self.model = SearchModel(dataSource: initialDataSource)
        self.bind()
    }

    // MARK: - Package internal methods
    func didSelectSearch(result: SearchItem) {
        searchingText = result.title
    }

    func logAnalytics(
        event: AirSearchBarAnalyticsEvent,
        parameters: [AirSearchBarAnalyticsParameter: AnalyticsProperty] = [:]
    ) {
        analyticsSubject.send((event, parameters))
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
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink(
                receiveValue: { [weak self] searchText in
                    self?.searchItems(forKeyword: searchText)

                    DispatchQueue.main.async {
                        self?.didSearchKeywordSubject.send(searchText)
                    }
                }
            )
            .store(in: &cancellables)
    }

    func searchItems(forKeyword searchingText: String) {
        if self.model.dataSource.count >= 1 {
            let founds = self.model.dataSource
                .filter {
                    if searchingText.isEmpty {
                        return false
                    } else {
                        return $0
                            .title
                            .lowercased()
                            .hasPrefix(searchingText.lowercased())
                    }
                }

            self.model.results = founds
        }
    }
}
