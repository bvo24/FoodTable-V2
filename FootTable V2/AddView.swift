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
    var meal: Meal

    @State private var name = ""
    @State private var calories = ""
    @State private var servingSize = ""
    @State private var protein = ""
    @State private var servingType = FoodItem.measurementUnits[0]
    @State private var stockLevel = FoodItem.stockLevel[0]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Food Name", text: $name)
                TextField("Calories per serving", text: $calories)
                HStack {
                    TextField("Serving Size", text: $servingSize)
                    Picker("", selection: $servingType) {
                        ForEach(FoodItem.measurementUnits, id: \.self) { servingType in
                            Text(servingType)
                        }
                    }
                }
                TextField("Protein per serving", text: $protein)
                Picker("Stock Level", selection: $stockLevel) {
                    ForEach(FoodItem.stockLevel, id: \.self) { stockLevel in
                        Text(stockLevel)
                    }
                }
            }
            .toolbar {
                let foodItem = FoodItem(id: UUID(), name: name, calories: calories, servingSize: servingSize, servingType: servingType, protein: protein, stock: stockLevel)
                Button("Add Item") {
                    addFoodItem(foodItem)
                }
                .disabled(!foodItem.hasValidItem)
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
