//
//  SplashView.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import SwiftUI

struct SplashView: View {

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("AppIconPreview")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .accessibilityLabel("Expense Tracker logo")

                Text("Expense Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityLabel("Expense Tracker app name")

                Text("Track your daily spending easily")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    SplashView()
}
