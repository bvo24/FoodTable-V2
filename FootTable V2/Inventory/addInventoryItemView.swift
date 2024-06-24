//
//  addInventoryItemView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/15/24.
//

import SwiftUI

//add a mark to gather?...


struct addInventoryItemView: View {
    @ObservedObject var inventoryManger : InventoryManager
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var stock = FoodItem.stockLevel[1]
    @State private var markState = false
    
    var body: some View {
        NavigationView{
            Form{
                VStack{
                    TextField("Ingredient name", text: $name)
                    
                    Picker("Stock level", selection: $stock){
                        //Skip the first index we're in the inventory slot for adding so we know it has to have a stock
                        ForEach(1..<FoodItem.stockLevel.count, id: \.self){ index in
                            //Tagging allowed us to change what we selected because doing a for each that skipped a index didn't allow us to change what we selected
                            Text(FoodItem.stockLevel[index]).tag(FoodItem.stockLevel[index])
                        }
                    }
                    
                    Toggle("Mark to gather", isOn: $markState)
                }
                .listRowBackground(Color.lightWood)
            }
            .scrollContentBackground(.hidden)
            .background(Color.darkWood)
            .toolbar{
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction){
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
