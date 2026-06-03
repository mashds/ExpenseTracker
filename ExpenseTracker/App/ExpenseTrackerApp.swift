//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {

    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                ExpenseListView()
            }
        }
    }
}
