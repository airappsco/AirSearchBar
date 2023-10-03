//
//  AirSearchBarViewModel.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 AirApps. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public class AirSearchBarViewModel: ObservableObject {
    // MARK: - Model
    @Published private var model: SearchModel

    // MARK: - Variables
    @Published var searchingText: String = ""

    @Binding public var didSearchKeyword: PassthroughSubject<String, Never>?
    @Binding public var didFinishSearchKeyword: PassthroughSubject<String, Never>?

    var shouldForceHideSearchResults = false
    public var results: [SearchItem] {
        model.results
    }

    public var shouldShowSearchResults: Bool {
        results.isEmpty
        ? false
        : (results.count == 1 && results.first?.title == searchingText) == false
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    public init(
        initialDataSource: Binding<[SearchItem]>,
        didSearchKeyword: Binding<PassthroughSubject<String, Never>?>? = nil,
        didFinishSearchKeyword: Binding<PassthroughSubject<String, Never>?>? = nil
    ) {
        self.model = SearchModel(dataSource: initialDataSource)
        _didSearchKeyword = didSearchKeyword ?? Binding.constant(nil)
        _didFinishSearchKeyword = didFinishSearchKeyword ?? Binding.constant(nil)

        self.bind()
    }

    func didSelectSearch(result: SearchItem) {
        searchingText = result.title
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
                        self?.didSearchKeyword?.send(searchText)
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
                            .contains(searchingText.lowercased())
                    }
                }

            self.model.results = founds
        }
    }
}
