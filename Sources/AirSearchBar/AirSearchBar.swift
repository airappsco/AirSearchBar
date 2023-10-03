//
//  AirSearchBar.swift
//  AirSearchBar
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 AirApps. All rights reserved.
//

import Combine
import SwiftUI

public struct AirSearchBar: View {
    @FocusState var focused: Bool

    @ObservedObject var viewModel: AirSearchBarViewModel
    @ObservedObject var style: Style

    @Binding public var analyticsSubject: PassthroughSubject<AirSearchBarAnalytics, Never>?
    @Binding public var isSearching: Bool

    public init(
        style: Style,
        isSearching: Binding<Bool>,
        analyticsSubject: Binding<PassthroughSubject<AirSearchBarAnalytics, Never>?>? = nil,
        viewModel: AirSearchBarViewModel
    ) {
        self.viewModel = viewModel
        self.style = style
        _isSearching = isSearching
        _analyticsSubject = analyticsSubject ?? Binding.constant(nil)
    }

    public var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                renderSearchBar()
            }
            .compositingGroup()
            .shadow(color: style.shadowColor, radius: 25, x: 0, y: 20)
        }
        .padding(.top, Constants.Padding.padding8)
        .background(.clear)
        .onAppear {
            logAnalytics(event: .didStartSearching)
            isSearching = true
        }
        .onDisappear {
            isSearching = false
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
                .foregroundColor(style.accentColor)
                .padding(.leading, Constants.Padding.padding16)

            renderSearchBarTextField()

            Button(
                action: {
                    viewModel.searchingText = ""
                },
                label: {
                    Image(systemName: Constants.SystemImage.xMarkCircleFill)
                        .foregroundColor(style.clearButtonColor)
                }
            )
            .padding(.vertical, Constants.Padding.padding8)
            .padding(.horizontal, Constants.Padding.padding16)
            .opacity(viewModel.searchingText.isEmpty ? 0 : 1)
        }
        .background(style.backgroundColor)
        .cornerRadius(Constants.defaultCornerRadius, corners: viewModel.shouldShowSearchResults ? [.bottomLeft, .bottomRight] : [.allCorners])
        .padding(.horizontal, Constants.Padding.padding16)
        .padding(.bottom, Constants.Padding.padding32)
        .frame(height: Constants.customSearchBarHeight)
    }

    // MARK: - Search bar text field
    func renderSearchBarTextField() -> some View {
        TextField(
            style.placeholder,
            text: $viewModel.searchingText,
            onEditingChanged: { _ in },
            onCommit: {
                logAnalytics(event: .didFinishSearching, parameters: [.keyword: viewModel.searchingText])
                viewModel.didFinishSearchKeyword?.send(viewModel.searchingText)
                isSearching = false
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
    }

    // MARK: - Results view
    func renderSearchResultsView() -> some View {
        LazyVStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { item in
                        HStack {
                            item.title.boldDifferenceFrom(viewModel.searchingText)
                                .font(style.font)
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
        .background(style.backgroundColor)
        .cornerRadius(Constants.defaultCornerRadius, corners: [.topLeft, .topRight])
        .padding(.horizontal, Constants.Padding.padding16)
        .padding(.bottom, -Constants.Padding.padding8)
    }

    // MARK: - Divider
    func renderDivider() -> some View {
        Rectangle()
            .foregroundColor(style.dividerBackgroundColor)
            .frame(maxWidth: .infinity, minHeight: Constants.dividerHeight, maxHeight: Constants.dividerHeight)
            .padding(.horizontal, Constants.Padding.padding16)
            .padding(.bottom)
    }

    // MARK: - Log analytics
    func logAnalytics(
        event: AirSearchBarAnalyticsEvent,
        parameters: [AirSearchBarAnalyticsParameter: AnalyticsProperty] = [:]
    ) {
        analyticsSubject?.send((event, parameters))
    }
}

public extension AirSearchBar {
    class Style: ObservableObject {
        @Published public var backgroundColor: AnyShapeStyle
        @Published public var foregroundColor: Color
        @Published public var shadowColor: Color
        @Published public var accentColor: Color
        @Published public var clearButtonColor: Color
        @Published public var dividerBackgroundColor: Color
        @Published public var font: Font
        @Published public var placeholder: String

        public init(
            backgroundColor: AnyShapeStyle = .init(Color.backgroundColor),
            foregroundColor: Color = Color.foregroundColor,
            shadowColor: Color = Color.defaultShadow,
            accentColor: Color = Color.magnifyingglassIconColor,
            clearButtonColor: Color = Color.xMarkCircleFillForegroundColor,
            dividerBackgroundColor: Color = Color.dividerBackgroundColor,
            font: Font = Font.system(size: 17, weight: .regular),
            placeholder: String
        ) {
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.shadowColor = shadowColor
            self.accentColor = accentColor
            self.clearButtonColor = clearButtonColor
            self.dividerBackgroundColor = dividerBackgroundColor
            self.font = font
            self.placeholder = placeholder
        }
    }
}

public extension AirSearchBar {
    typealias AirSearchBarAnalytics = (
        AirSearchBarAnalyticsEvent,
        [AirSearchBarAnalyticsParameter: AnalyticsProperty]
    )
}
