//
//  ContentView.swift
//  AirSearchBarDemo
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 Air Apps. All rights reserved.
//

import AirSearchBar
import Combine
import SwiftUI

struct ContentView: View {
    @State private var isSearching = true

    let airSearchBarViewModel = AirSearchBarViewModel(
        initialDataSource: ["Nebulizer", "Nebulize", "Nebulous", "Nebula"]
    )

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
                    viewModel: airSearchBarViewModel
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
        .onReceive(airSearchBarViewModel.analyticsSubject, perform: { event in
            print(event)
        })
        .onReceive(airSearchBarViewModel.didSearchKeywordSubject, perform: { keyword in
            if keyword.isEmpty == false {
                airSearchBarViewModel.update(dataSource: ["Star Wars"])
                print("didSearchKeywordPublisher: \(keyword)")
            }
        })
        .onReceive(airSearchBarViewModel.didFinishSearchKeywordSubject, perform: { keyword in
            print("didFinishSearchKeywordPublisher: \(keyword)")
        })
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
