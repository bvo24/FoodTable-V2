//
//  InventoryView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/11/24.
//

import SwiftUI

enum SortType{
    case `default`, lowToHigh, highToLow, aToZ, zToA
}
enum FilterType{
    case `default`, low, medium, high, markedToGather
}

struct InventoryView: View {
    @StateObject var inventoryManager = InventoryManager()
    @State private var refreshID = UUID()
    @State private var sortType = SortType.default
    @State private var filterType = FilterType.default
    @State private var showingSortOptions = false
    @State private var showingFilterOptions = false
    @State private var showAddView = false
    
    var filteredResults : [inventoryItem]{
        switch filterType{
        case .default:
            inventoryManager.inventory
        case.low:
            inventoryManager.inventory.filter{$0.stock == "Low" }
        case.medium:
            inventoryManager.inventory.filter{$0.stock == "Medium" }
        case.high:
            inventoryManager.inventory.filter{$0.stock == "High" }
        case.markedToGather:
            inventoryManager.inventory.filter{$0.markToGather}
            
        }
        
        
    }
    
    var sortedResults: [inventoryItem] {
            switch sortType {
            case .default:
                filteredResults
            case .lowToHigh:
                filteredResults.sorted { getStatusOrder(stock: $0.stock) < getStatusOrder(stock: $1.stock) }
            case .highToLow:
                filteredResults.sorted { getStatusOrder(stock: $0.stock) > getStatusOrder(stock: $1.stock) }
            case .aToZ:
                filteredResults.sorted{$0.name < $1.name  }
            case .zToA:
                filteredResults.sorted{$0.name > $1.name  }
                
            }
    
        }
        
    //Can't sort by strings so assigning a number allowed us to sort from high to low etc.
        func getStatusOrder(stock: String) -> Int {
            switch stock {
            case "High":
                return 3
            case "Medium":
                return 2
            case "Low":
                return 1
            default:
                return 0
            }
        }
    

    var body: some View {
        
            NavigationStack{
                List {
                    ForEach(sortedResults) { item in
                        NavigationLink(destination: inventoryItemEditView(inventoryManager: inventoryManager, inventoryItem: item)) {
                            HStack {
                                Text(item.name)
                                if item.markToGather{
                                    Image("pixelstar")
                                        .accessibilityLabel("Get this next scavenge")
                                        .foregroundStyle(.yellow)
                                }
                                
                                Spacer()
                                Text(item.stock)
                                    .foregroundStyle(item.stock == "High" ? .green : item.stock == "Medium" ? .yellow : .red)
                            }
                        }
                        
                        .contentShape(Rectangle())
                    }
                    //When we delete we should refresh the page
                    .onDelete { indexSet in
                        inventoryManager.removeInventoryItem(at: indexSet)
                        refreshID = UUID()
                    }
                    .listRowBackground(Color.lightWood)
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color.darkWood)
                .id(refreshID)
                
                .toolbar {
                    
                    //Allow for deletion of items faster
                    ToolbarItem(placement: .cancellationAction) {
                        EditButton()
                    }
                    ToolbarItem{
                        Button("Filter"){
                            showingFilterOptions = true
                        }
                    }
//                    ToolbarItem {
//                        Button("Add test item") {
//                            let ex = inventoryItem(name: "Ketchup", stock: "Low")
//                            inventoryManager.addInventoryItem(ex)
//                            refreshID = UUID()  // Update refreshID to refresh the view
//                        }
//                    }
//                    ToolbarItem {
//                        Button("Print Inventory") {
//                            printInventory()
//                        }
//                    }
                    ToolbarItem{
                        Button("Change sort order", systemImage: "arrow.up.arrow.down"){
                            showingSortOptions = true
                            
                        }
                        
                    }
                    ToolbarItem{
                        Button("Add ingredient", systemImage: "plus"){
                            showAddView.toggle()
                        }
                    }
                    
                }
                .sheet(isPresented: $showAddView){
                    addInventoryItemView(inventoryManger: inventoryManager)
                        .presentationDetents([.medium, .large])
                }
//                .confirmationDialog("Sort order", isPresented: $showingSortOptions){
//                    Button("Default"){ sortType = .default
//                    }
//                    Button("Low to High"){ sortType = .lowToHigh
//                    }
//                    Button("High to Low"){ sortType = .highToLow
//                    }
//                    Button("A-Z"){ sortType = .aToZ
//                    }
//                    Button("Z-A"){ sortType = .zToA
//                    }
//                }
                .actionSheet(isPresented: $showingSortOptions) {
                                ActionSheet(
                                    title: Text("Sort order"),
                                    buttons: [
                                        .default(Text("Default")) { sortType = .default },
                                        .default(Text("Low to High")) { sortType = .lowToHigh },
                                        .default(Text("High to Low")) { sortType = .highToLow },
                                        .default(Text("A-Z")) { sortType = .aToZ },
                                        .default(Text("Z-A")) { sortType = .zToA },
                                        .cancel()
                                    ]
                                )
                            }
                .confirmationDialog("Filter", isPresented: $showingFilterOptions){
                    Button("Show all"){ filterType = .default
                    }
                    Button("Low"){ filterType = .low
                    }
                    Button("Medium"){ filterType = .medium
                    }
                    Button("High"){ filterType = .high
                    }
                    Button("Marked to gather"){ filterType = .markedToGather
                    }
                    
                }
                .background(Color.red)
                
            }
            .onAppear {
                //Keep our inventory up to date, like when we add something from our other tab we should update when we tap this ab
                inventoryManager.loadInventory()
                refreshID = UUID()
            }
        
    }

    func removeItem(at offsets: IndexSet) {
        inventoryManager.removeInventoryItem(at: offsets)
        refreshID = UUID()
    }

    
    //Test function can remove
    func printInventory() {
        for item in inventoryManager.inventory {
            print("\(item.name), \(item.stock)")
        }
    }
}


