//
//  inventoryItemEditView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/13/24.
//

import SwiftUI

struct inventoryItemEditView: View {
    
    @ObservedObject var inventoryManager : InventoryManager
    @Environment(\.dismiss) var dismiss
    
    var item : inventoryItem
    
    @State private var name : String
    @State private var stock : String
    @State private var markState : Bool
    
    init(inventoryManager: InventoryManager, inventoryItem: inventoryItem) {
        self.inventoryManager = inventoryManager
        self.item = inventoryItem
        _name = State(initialValue: item.name)
        _stock = State(initialValue: item.stock)
        _markState = State(initialValue: item.markToGather)
    }
    
    
    var body: some View {
        
        Form{
            TextField("Edit ingredient name", text: $name)
            
            Picker("Update the stock", selection: $stock ){
                ForEach(FoodItem.stockLevel, id: \.self ){ stock in
                    Text(stock)
                    
                }
            }
            
            Toggle("Mark to gather", isOn: $markState)
            
        }
        .navigationBarBackButtonHidden(true) 
        .toolbar{
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem{
                Button("Update"){
                    let updatedItem = inventoryItem(id: item.id, name: name, stock: stock, markToGather: markState)
                    inventoryManager.updateInventoryItem(item: updatedItem)
                    dismiss()
                }
            }
        }
        
    }
}

//#Preview {
//    inventoryItemEditView(inventoryItem: inventoryItem.example)
//}
