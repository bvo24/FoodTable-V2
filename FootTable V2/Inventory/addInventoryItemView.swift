//
//  addInventoryItemView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/15/24.
//

import SwiftUI

//add a mark to gather?...


struct addInventoryItemView: View {
    @State private var name = ""
    @State private var stock = FoodItem.stockLevel[1]
    @ObservedObject var inventoryManger : InventoryManager
    @Environment(\.dismiss) var dismiss
    @State private var markState = false
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Ingredient name", text: $name)
                
                
                Picker("Stock level", selection: $stock){
                    ForEach(1..<FoodItem.stockLevel.count, id: \.self){ index in
                        Text(FoodItem.stockLevel[index]).tag(FoodItem.stockLevel[index])
                    }
                }
                
                Toggle("Mark to gather", isOn: $markState)
                
                
            }
            .toolbar{
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem{
                    Button("Add"){
                        let item = inventoryItem(name: name, stock: stock, markToGather: markState)
                        inventoryManger.addInventoryItem(item)
                        dismiss()
                    }
                    
                    
                }
            }
        }
    }
}

#Preview {
    addInventoryItemView(inventoryManger: InventoryManager())
}
