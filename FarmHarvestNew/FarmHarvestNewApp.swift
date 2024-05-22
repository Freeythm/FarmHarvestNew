//
//  FarmHarvestNewApp.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI
import SwiftData

@main
struct FarmHarvestNewApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Farm.self,
            NewPayments.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environment(FarmViewModel())
    }
}
