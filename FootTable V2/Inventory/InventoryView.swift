//
//  InventoryView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/11/24.
//

import SwiftUI

struct InventoryView: View {
    @StateObject var inventoryManager = InventoryManager()
    @State private var refreshID = UUID()

    var body: some View {
        
            NavigationStack {
                List {
                    ForEach(inventoryManager.inventory) { item in
                        NavigationLink(destination: inventoryItemEditView(inventoryManager: inventoryManager, inventoryItem: item)) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.stock)
                                    .foregroundStyle(item.stock == "High" ? .green : item.stock == "Medium" ? .yellow : .red)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .onDelete { indexSet in
                        inventoryManager.removeInventoryItem(at: indexSet)
                        refreshID = UUID()  // Update refreshID to refresh the view
                    }
                }
                .id(refreshID)  // Force view refresh by using the refreshID
                .toolbar {
                    ToolbarItem {
                        EditButton()
                    }
                    ToolbarItem {
                        Button("Add test item") {
                            let ex = inventoryItem(name: "Ketchup", stock: "Low")
                            inventoryManager.addInventoryItem(ex)
                            refreshID = UUID()  // Update refreshID to refresh the view
                        }
                    }
                    ToolbarItem {
                        Button("Print Inventory") {
                            printInventory()
                        }
                    }
                }
            }
            .onAppear {
                // Perform any actions you want to happen when the view appears
                inventoryManager.loadInventory()
                refreshID = UUID()  // Update refreshID to refresh the view
            }
        
    }

    func removeItem(at offsets: IndexSet) {
        inventoryManager.removeInventoryItem(at: offsets)
        refreshID = UUID()  // Update refreshID to refresh the view
    }

    func printInventory() {
        for item in inventoryManager.inventory {
            print("\(item.name), \(item.stock)")
        }
    }
}
