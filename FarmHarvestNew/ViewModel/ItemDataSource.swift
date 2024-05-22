//
//  ItemDataSource.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI
import SwiftData

final class ItemDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shard = ItemDataSource()

    @MainActor
    init() {
        self.modelContainer = try! ModelContainer(for: Farm.self)
        self.modelContext = modelContainer.mainContext
    }

    // MARK: FetchItems ------------------------
    func fetchItems() -> [Farm] {
        do {
            return try modelContext.fetch(FetchDescriptor<Farm>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // MARK: AppendItem --------------------------
    func appendItem(model: Farm) {
        modelContext.insert(model)
        SaveData()
    }

    // MARK: RemoveItem -------------------------
    func removeItem(_ item: Farm) {
        modelContext.delete(item)
        SaveData()
    }

    // MARK: SaveItem ----------------------------
    func SaveData() {
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
