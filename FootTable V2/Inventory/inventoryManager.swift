//
//  inventoryManager.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/12/24.
//

import SwiftUI

class InventoryManager: ObservableObject {
    //Saved in a document directory
    private let savePath = URL.documentsDirectory.appendingPathComponent("inventory")
    
    @Published var inventory: [inventoryItem] = []
    
    init() {
        loadInventory()
    }
    
    func addInventoryItem(_ item: inventoryItem) {
        inventory.append(item)
        saveInventory()
    }
    
    //Find the id where the item we have is equal to the id in the array and then just swap in the new item for the old one
    func updateInventoryItem(item : inventoryItem){
        if let index = inventory.firstIndex(where: { $0.id == item.id}) {
            inventory[index] = item
            saveInventory()
        }
    }
    
    
    func removeInventoryItem(at index: IndexSet) {
        inventory.remove(atOffsets: index)
        saveInventory()
    }
    
    func loadInventory() {
        do {
            let data = try Data(contentsOf: savePath)
            inventory = try JSONDecoder().decode([inventoryItem].self, from: data)
        } catch {
            inventory = []
        }
    }

    func saveInventory() {
        do {
            let data = try JSONEncoder().encode(inventory)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
}
