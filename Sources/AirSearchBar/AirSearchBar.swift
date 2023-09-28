//
//  AirSearchBar.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/23.
//  Copyright © 2020 Air Apps. All rights reserved.

import Combine
import SwiftUI

import Foundation
import Combine

enum AutoCompleteError: Error {
    case notFound
}

public struct SpotlightItem: Identifiable, Hashable {
    public var id = UUID()
    var name: String
}

class SpotlightSearchModel {
    public var dataSource: [SpotlightItem]
    public var results: [SpotlightItem] = []

    init(dataSource: [String]) {
        self.dataSource = dataSource.map { SpotlightItem(name:$0) }
    }
}

// MARK: - Private Methods
extension SpotlightSearchModel {
    public func searchItems(forKeyword searchingText: String) -> Void {
        if self.dataSource.count >= 1 {
            let founds = self.dataSource
                .filter {
                    if searchingText == "" {
                        return false
                    } else {
                        return $0
                            .name
                            .lowercased()
                            .contains(searchingText.lowercased())
                    }
            }

            self.results = founds

        }
    }

}

public class AirSearchBarViewModel: ObservableObject {
    // MARK: - Model
    @Published private var model: SpotlightSearchModel

    // MARK: - Variables
    @Published var searchingText: String = ""

    public var didSearchKeyword: ((String) -> Void)? = nil
    public var results: [SpotlightItem] {
        model.results
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    public init(initialDataSource: [String],
                didSearchKeyword: ((String) -> Void)? = nil) {
        self.model = SpotlightSearchModel(dataSource: initialDataSource)
        self.didSearchKeyword = didSearchKeyword

        self.bind()
    }
}

// MARK: - Public Methods
extension AirSearchBarViewModel {
    public func update(dataSource: [String]) {
        model.dataSource = dataSource.map { SpotlightItem(name:$0) }
    }
}

// MARK: - Private Methods
extension AirSearchBarViewModel {
    private func bind() {

        $searchingText
            .debounce(for: .seconds(0.0),
                      scheduler: DispatchQueue.global(qos:.userInitiated))
            .sink(receiveValue: { [weak self] searchText in
                self?.model.searchItems(forKeyword:searchText)
                self?.didSearchKeyword?(searchText)
            })
            .store(in: &cancellables)
    }
}


public struct AirSearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    @FocusState var focused: Bool
    @State var shouldShowTableView: Bool = false
    @State var forceHideTableView = false

    @ObservedObject var viewModel: AirSearchBarViewModel = .init(initialDataSource: [])

    public init(text: Binding<String>, isSearching: Binding<Bool>) {
        _text = text
        _isSearching = isSearching
    }

    public var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                renderSearchBar()
            }
            .compositingGroup()
            .shadow(color: Constants.Colors.defaultShadow, radius: 25, x: 0, y: 20)
        }
        .padding(.top, Constants.Padding.padding8)
        .background(Color.clear)
        .onAppear {
            isSearching = true
        }
        .onDisappear {
            isSearching = false
            text = ""
        }
    }
}

private extension AirSearchBar {
    // MARK: - Core Component
    func renderSearchBar() -> some View {
        LazyVStack(spacing: Constants.Padding.padding8) {
            if shouldShowTableView {
                renderSearchResultsView()
            }

            renderCustomSearchBar()
        }
    }

    // MARK: - Custom search bar
    func renderCustomSearchBar() -> some View {
        HStack {
            Image(systemName: Constants.SystemImage.magnifyingglass)
                .foregroundColor(Constants.Colors.magnifyingglassIcon)
                .padding(.leading, Constants.Padding.padding16)

            TextField(
                "Search",
                text: $text,
                onEditingChanged: { _ in },
                onCommit: {
                    // Handle search here if needed
                }
            )
            .onAppear {
                shouldShowTableView = text.isEmpty == false
                focused = true
            }
            .onChange(of: text, perform: { value in
                viewModel.searchingText = value
                shouldShowTableView = text.isEmpty == false
            })
            .onChange(of: forceHideTableView, perform: { value in
                shouldShowTableView = false
            })
            .padding(.leading, Constants.Padding.padding2)
            .background(.clear)
            .padding(.trailing, Constants.Padding.padding8)
            .focused($focused)

            Button(action: {
                self.text = ""
            }) {
                Image(systemName: Constants.SystemImage.xMarkCircleFill)
                    .foregroundColor(Constants.Colors.xMarkCircleFillForegroundColor)
            }
            .padding(.vertical, Constants.Padding.padding8)
            .padding(.horizontal, Constants.Padding.padding16)
            .opacity(text.isEmpty ? 0 : 1)
        }
        .background(.white)
        .cornerRadius(Constants.defaultCornerRadius, corners: shouldShowTableView ? [.bottomLeft, .bottomRight] : [.allCorners])
        .padding(.horizontal, Constants.Padding.padding16)
        .padding(.bottom, Constants.Padding.padding32)
        .frame(height: Constants.customSearchBarHeight)
    }

    // MARK: - Results view
    func renderSearchResultsView() -> some View {
        LazyVStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        HStack {
                            result.name.boldDifferenceFrom(text)
                                .font(Font.system(size: 17, weight: .light, design: .rounded))
                                .padding([.leading, .trailing])
                                .padding(.top, Constants.Padding.padding12)
                        }.onTapGesture {
                            self.text = result.name
                            forceHideTableView.toggle()
                        }
                    }
                }
                .padding([.bottom, .top])
            }
            .frame(maxHeight: Constants.searchResultsViewMaxHeight)
            .padding(.horizontal, Constants.Padding.padding12)

            renderDivider()

        }
        .background(.white)
        .cornerRadius(Constants.defaultCornerRadius, corners: [.topLeft, .topRight])
        .padding(.horizontal, Constants.Padding.padding16)
        .padding(.bottom, -Constants.Padding.padding8)
    }

    // MARK: - Divider
    func renderDivider() -> some View {
        Rectangle()
            .foregroundColor(Constants.Colors.dividerBackgroundColor)
            .frame(maxWidth: .infinity, minHeight: Constants.dividerHeight, maxHeight: Constants.dividerHeight)
            .padding(.horizontal, Constants.Padding.padding16)
            .padding(.bottom)
    }
}

public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
