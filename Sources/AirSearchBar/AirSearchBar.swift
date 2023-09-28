//
//  AirSearchBar.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/23.
//  Copyright © 2020 Air Apps. All rights reserved.

import Combine
import SwiftUI

public struct AirSearchBar: View {
    @FocusState var focused: Bool

    @ObservedObject var viewModel: AirSearchBarViewModel

    public init(viewModel: AirSearchBarViewModel) {
        self.viewModel = viewModel
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
            viewModel.isSearching = true
        }
        .onDisappear {
            viewModel.isSearching = false
            viewModel.searchingText = ""
        }
    }
}

private extension AirSearchBar {
    // MARK: - Core Component
    func renderSearchBar() -> some View {
        LazyVStack(spacing: Constants.Padding.padding8) {
            if viewModel.shouldShowSearchResults {
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
                text: $viewModel.searchingText,
                onEditingChanged: { _ in },
                onCommit: {
                    // Handle search here if needed
                }
            )
            .onAppear {
                focused = true
            }
            .padding(.leading, Constants.Padding.padding2)
            .background(.clear)
            .padding(.trailing, Constants.Padding.padding8)
            .focused($focused)
            .frame(height: Constants.customSearchBarHeight)

            Button(action: {
                viewModel.searchingText = ""
            }) {
                Image(systemName: Constants.SystemImage.xMarkCircleFill)
                    .foregroundColor(Constants.Colors.xMarkCircleFillForegroundColor)
            }
            .padding(.vertical, Constants.Padding.padding8)
            .padding(.horizontal, Constants.Padding.padding16)
            .opacity(viewModel.searchingText.isEmpty ? 0 : 1)
        }
        .background(.white)
        .cornerRadius(Constants.defaultCornerRadius, corners: viewModel.shouldShowSearchResults ? [.bottomLeft, .bottomRight] : [.allCorners])
        .padding(.horizontal, Constants.Padding.padding16)
        .padding(.bottom, Constants.Padding.padding32)
        .frame(height: Constants.customSearchBarHeight)
    }

    // MARK: - Results view
    func renderSearchResultsView() -> some View {
        LazyVStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { item in
                        HStack {
                            item.title.boldDifferenceFrom(viewModel.searchingText)
                                .font(Font.system(size: 17, weight: .light, design: .rounded))
                                .padding([.leading, .trailing])
                                .padding(.top, Constants.Padding.padding12)
                        }.onTapGesture {
                            viewModel.didSelectSearch(result: item)
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
