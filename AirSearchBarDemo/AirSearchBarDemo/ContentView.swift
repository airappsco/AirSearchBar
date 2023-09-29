//
//  ContentView.swift
//  AirSearchBarDemo
//
//  Created by Gabriel on 26/09/23.
//

import AirSearchBar
import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var isSearching = true

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
        .onChange(of: searchText, perform: { value in
            print(searchText)
        })
        .navigationBarItems(trailing:
                                Button("Cancel") {
            hideKeyboard()
            isSearching = false
        }
            .foregroundColor(.blue)
            .padding(.trailing, 16)
            .opacity(isSearching ? 1 : 0)
        )
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
