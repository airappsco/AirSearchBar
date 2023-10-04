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
    @State private var searchText = ""
    @State private var isSearching = true

    @State private var analyticsSubject: PassthroughSubject<AirSearchBar.AirSearchBarAnalytics, Never>? = .init()

    var analyticsPublisher: AnyPublisher<AirSearchBar.AirSearchBarAnalytics, Never> {
        analyticsSubject?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }

    var body: some View {
        ZStack {
            // Your main content here
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
                    analyticsSubject: $analyticsSubject,
                    viewModel: AirSearchBarViewModel(
                        initialDataSource: ["Nebulizer", "Nebulize", "Nebulous", "Nebula"],
                        isSearching: $isSearching
                    ) { something in
                        print(something)
                    })
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: searchText, perform: { _ in
            print(searchText)
        })
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
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
