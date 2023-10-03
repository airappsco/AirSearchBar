//
//  ContentView.swift
//  AirSearchBarDemo
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 AirApps. All rights reserved.
//

import AirSearchBar
import Combine
import SwiftUI

struct ContentView: View {
    @State private var isSearching = true

    @State private var analyticsSubject: PassthroughSubject<AirSearchBar.AirSearchBarAnalytics, Never>? = .init()
    @State private var didSearchKeywordSubject: PassthroughSubject<String, Never>? = .init()
    @State private var didFinishSearchKeywordSubject: PassthroughSubject<String, Never>? = .init()

    var analyticsPublisher: AnyPublisher<AirSearchBar.AirSearchBarAnalytics, Never> {
        analyticsSubject?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }

    var didSearchKeywordPublisher: AnyPublisher<String, Never> {
        didSearchKeywordSubject?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }

    var didFinishSearchKeywordPublisher: AnyPublisher<String, Never> {
        didFinishSearchKeywordSubject?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }

    @State var searchDataSource: [SearchItem] = [""].map { .init(title: $0) }

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            Button {
                isSearching = true
            } label: {
                Text("Tap to search")
            }

            if isSearching {
                AirSearchBar(
                    style: .init(placeholder: "Search..."), 
                    isSearching: $isSearching,
                    analyticsSubject: $analyticsSubject,
                    viewModel: AirSearchBarViewModel(
                        initialDataSource: $searchDataSource,
                        didSearchKeyword: $didSearchKeywordSubject,
                        didFinishSearchKeyword: $didFinishSearchKeywordSubject
                    )
                )
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarItems(
            trailing:
                Button("Cancel") {
                    hideKeyboard()
                    isSearching = false
                }
                .foregroundColor(.blue)
                .padding(.trailing, 16)
                .opacity(isSearching ? 1 : 0)
        )
        .onReceive(analyticsPublisher, perform: { event in
            print(event)
        })
        .onReceive(didSearchKeywordPublisher, perform: { keyword in
            if keyword.isEmpty == false {
                searchDataSource = [.init(title: "navigation"), .init(title: "nagotioation")]
                print("didSearchKeywordPublisher: \(keyword)")
            }
        })
        .onReceive(didFinishSearchKeywordPublisher, perform: { keyword in
            print("didFinishSearchKeywordPublisher: \(keyword)")
        })
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
