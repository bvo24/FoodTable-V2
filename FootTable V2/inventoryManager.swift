//
//  inventoryManager.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/12/24.
//

import SwiftUI

class InventoryManager: ObservableObject {
    private let savePath = URL.documentsDirectory.appendingPathComponent("inventory")
    
    @Published var inventory: [inventoryItem] = []
    
    init() {
        loadInventory()
    }
    
    func addInventoryItem(_ item: inventoryItem) {
        inventory.append(item)
        saveInventory()
    }
    
    func removeInventoryItem(at index: Int) {
        inventory.remove(at: index)
        saveInventory()
    }
    
    private func loadInventory() {
        do {
            let data = try Data(contentsOf: savePath)
            inventory = try JSONDecoder().decode([inventoryItem].self, from: data)
        } catch {
            inventory = []
        }
    }

    private func saveInventory() {
        do {
            let data = try JSONEncoder().encode(inventory)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
}
