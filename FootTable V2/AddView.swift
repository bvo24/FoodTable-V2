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
    @State private var stockLevel = FoodItem.stockLevel[2]
    
    
    var calories: Double {
            guard let caloriesPerServing = Double(caloriesPerServing),
                  let servingSize = Double(servingSize),
                  let amountEaten = Double(amountEaten) else {
                return 0
            }
            return (caloriesPerServing / servingSize) * amountEaten
        }
    
    var protein: Double {
        guard let proteinPerServing = Double(proteinPerServing),
              let servingSize = Double(servingSize),
              let amountEaten = Double(amountEaten) else {
            return 0
        }
        return (proteinPerServing / servingSize) * amountEaten
    }

    

    var body: some View {
        NavigationStack {
            Form {
                TextField("Food Name", text: $name)
                
                HStack {
                    TextField("Cals per serving", text: $caloriesPerServing)
                    TextField("Serving Size", text: $servingSize)
                    TextField("Protein per serving", text: $proteinPerServing)
                    Picker("Measurement Units", selection: $servingType) {
                        ForEach(FoodItem.measurementUnits, id: \.self) { servingType in
                            Text(servingType)
                        }
                    }
                    .labelsHidden()
                }
                
                HStack{
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
                
                Section{
                    
                    Text("Total calories \(calories, specifier: "%.1f")")
                    Text("Total protein \(protein, specifier: "%.1f")")
                    
                }
                
            }
            .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        let foodItem = FoodItem(id: UUID(), name: name, calories: calories, caloriesPerServing: caloriesPerServing , servingSize: servingSize, servingType: servingType, eatenServingType: eatenServingType ,amountEaten: amountEaten , proteinPerServing: proteinPerServing, protein: protein, stock: stockLevel)
                        Button("Add Item") {
                            addFoodItem(foodItem)
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
    AddView(dayManager: DayManager(), meal: .breakfast)
}
