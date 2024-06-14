//
//  AddView.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/29/24.
//


//var id : UUID
//var name : String
//var calories : Int
//
//var servingSize : Int
//In our crafting menu we should see this type when creating/adding to recipe
//var servingType : String
//
//var protein : Int
//var stock : String


import SwiftUI

struct AddView: View {
    @ObservedObject var dayManager: DayManager
    @Environment(\.dismiss) var dismiss
    
    var meal: Meal

    @State private var name = ""
    @State private var caloriesPerServing = ""
//    @State private var calories = ""
    @State private var servingSize = ""
    @State private var proteinPerServing = ""
//    @State private var protein = ""
    @State private var amountEaten = ""
    @State private var servingType = FoodItem.measurementUnits[0]
    @State private var eatenServingType = FoodItem.measurementUnits[0]
    @State private var stockLevel = FoodItem.stockLevel[0]
    
    @State private var searchBool = false
    @ObservedObject var inventoryManager : InventoryManager
    
    
    // Conversion factors for different units to grams
        let conversionFactors: [String: Double] = [
            "g": 1.0,      // Grams
            "kg": 1000.0,  // Kilograms to grams
            "oz": 28.35,   // Ounces to grams
            "lbs": 453.59, // Pounds to grams
            "ml": 1.0,     // Milliliters (assuming water density)
            "l": 1000.0,   // Liters to milliliters
            "cups": 236.59,// Cups to milliliters (standard conversion)
            // Add more conversions as needed
        ]

        // Calculate total calories in grams
    var servingSizeInGrams: Double {
            guard let servingSizeValue = Double(servingSize) else {
                return 0
            }
            return conversionFactors[servingType]! * servingSizeValue
        }
        
        var amountEatenInGrams: Double {
            guard let amountEatenValue = Double(amountEaten) else {
                return 0
            }
            return conversionFactors[eatenServingType]! * amountEatenValue
        }
        
        var calories: Double {
            guard let caloriesPerServingValue = Double(caloriesPerServing) else {
                return 0
            }
            return (caloriesPerServingValue / servingSizeInGrams) * amountEatenInGrams
        }
        
        var protein: Double {
            guard let proteinPerServingValue = Double(proteinPerServing) else {
                return 0
            }
            return (proteinPerServingValue / servingSizeInGrams) * amountEatenInGrams
        }

    @State private var searchText = ""
    
    let searchItems : [searchItem] = Bundle.main.decode("foods.json")
    
    var filteredSearchItems : [searchItem]{
        if searchText.isEmpty{
            searchItems
        }else{
            searchItems.filter{
                $0.name.localizedStandardContains(searchText)
            }
        }
        
        
    }


    

    var body: some View {
        NavigationView {
            NavigationStack {
                Button(searchBool ? "Add" : "Search") {
                    searchBool.toggle()
                }
                .padding()
                
                if searchBool {
                    NavigationStack{
                        List(filteredSearchItems, id: \.self) { food in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(food.name)
                                        .font(.headline)
                                    Text("Calories: \(food.calories)")
                                        .foregroundColor(.secondary)
                                    Text("Protein: \(food.protein)")
                                        .foregroundColor(.secondary)
                                    
                                }
                                Spacer()
                                Text("Per \(food.servingSize) \(food.servingType)")
                                
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                
                                name = food.name
                                caloriesPerServing = food.calories
                                proteinPerServing = food.protein
                                servingSize = food.servingSize
                                servingType = "g"
                                
                                
                                searchBool.toggle()
                                print("Tapped \(food.name)")
                            }
                        }
                        .searchable(text: $searchText, prompt: "Search your food item")
                        .listRowSeparator(.visible)
                    }
                } else {
                    NavigationStack{
                        Form {
                            Section("Name") {
                                TextField("Food Name", text: $name)
                            }
                            Section("Per serving\n(Calories/Protein/Amount)") {
                                HStack {
                                    TextField("Cals", text: $caloriesPerServing)
                                    TextField("Protein", text: $proteinPerServing)
                                    TextField("Amount", text: $servingSize)
                                    Picker("Measurement Units", selection: $servingType) {
                                        ForEach(FoodItem.measurementUnits, id: \.self) { servingType in
                                            Text(servingType)
                                        }
                                    }
                                    .labelsHidden()
                                }
                            }
                            Section("Consumption details") {
                                HStack {
                                    TextField("Amount eaten", text: $amountEaten)
                                    Picker("Measurement Units", selection: $eatenServingType) {
                                        ForEach(FoodItem.measurementUnits, id: \.self) { servingType in
                                            Text(servingType)
                                        }
                                    }
                                    .labelsHidden()
                                }
                                Picker("Stock Level", selection: $stockLevel) {
                                    ForEach(FoodItem.stockLevel, id: \.self) { stockLevel in
                                        Text(stockLevel)
                                    }
                                }
                            }
                            Section {
                                Text("Total calories \(calories, specifier: "%.1f")")
                                Text("Total protein \(protein, specifier: "%.1f")")
                            }
                        }
                    }
                }
            }
//            .navigationTitle("Search Or Add")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    let foodItem = FoodItem(id: UUID(), name: name, caloriesPerServing: caloriesPerServing , servingSize: servingSize, servingType: servingType, eatenServingType: eatenServingType ,amountEaten: amountEaten , proteinPerServing: proteinPerServing, stock: stockLevel)
                    Button("Add Item") {
                        addFoodItem(foodItem)
                        if stockLevel != "N/A"{
                            print("added item")
                            inventoryManager.addInventoryItem(inventoryItem(name: name, stock: stockLevel))
                        }
                        
                        dismiss()
                    }
                    .disabled(!foodItem.hasValidItem)
                }
            }
        }
    }


    private func addFoodItem(_ foodItem: FoodItem) {
        switch meal {
        case .breakfast:
            dayManager.selectedDay.breakfast.append(foodItem)
        case .lunch:
            dayManager.selectedDay.lunch.append(foodItem)
        case .dinner:
            dayManager.selectedDay.dinner.append(foodItem)
        }
        dayManager.updateSelectedDay()
    }
}

#Preview {
    AddView(dayManager: DayManager(), meal: .breakfast, inventoryManager: InventoryManager())
}
