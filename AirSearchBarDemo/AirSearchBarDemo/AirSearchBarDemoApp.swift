//
//  AirSearchBarDemoApp.swift
//  AirSearchBarDemo
//
//  Created by Gabriel on 26/09/2023.
//  Copyright © 2023 Air Apps. All rights reserved.
//

import SwiftUI

@main
struct AirSearchBarDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .toolbarTitleDisplayMode(.inline)
                    .navigationBarTitle("Search Example")
            }
        }
    }
}
