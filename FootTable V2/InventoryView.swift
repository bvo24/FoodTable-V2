//
//  InventoryView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/11/24.
//

import SwiftUI

struct InventoryView: View {
    
    private let savePath = URL.documentsDirectory.appendingPathComponent("inventory")
    @State private var inventory : [inventoryItem] = []

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

    
    
    
    var body: some View {
        NavigationStack{
            
            VStack{
                List{
                    ForEach(inventory, id: \.id){ item in
                        HStack{
                            Text(item.name)
                            Spacer()
                            Text(item.stock)
                                .foregroundStyle( item.stock == "High" ? .green : item.stock == "Medium" ? .yellow : .red )
                        }
                        .contentShape(Rectangle())
                    }
                    .onDelete(perform: removeItem)
                    
                }
            }
            .toolbar{
                ToolbarItem{
                    EditButton()
                }
                
                ToolbarItem{
                    Button("Add test item"){
                        let ex = inventoryItem(name: "Ketchup", stock: "low")
                        inventory.append(ex)
                        saveInventory()
                    }
                }
                
            }
            
        }
        .onAppear {
                    loadInventory()
                }
        
    }
    
    func removeItem(at offsets : IndexSet){
        inventory.remove(atOffsets: offsets)
    }
    
}

#Preview {
    
    //create an example
    InventoryView()
}
