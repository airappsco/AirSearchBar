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
                AirSearchBar(text: $searchText, isSearching: $isSearching)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
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
