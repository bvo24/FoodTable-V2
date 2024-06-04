//
//  EditView.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/31/24.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var dayManager: DayManager
    @Environment(\.dismiss) var dismiss
    var foodItem: FoodItem // The food item to be edited
    @Binding var refreshID: UUID
    
    @State private var name: String
    @State private var caloriesPerServing: String
    @State private var servingSize: String
    @State private var proteinPerServing: String
    @State private var amountEaten: String
    @State private var servingType: String // Use a string property for servingType
    @State private var stockLevel: String // Use a string property for stockLevel
    @State private var eatenServingType : String
    
    init(dayManager: DayManager, foodItem: FoodItem, refreshID: Binding<UUID>) {
            self.dayManager = dayManager
            self.foodItem = foodItem
            _refreshID = refreshID
            
            // Initialize the state variables with existing values from foodItem
            _name = State(initialValue: foodItem.name)
            _caloriesPerServing = State(initialValue: "\(foodItem.caloriesPerServing)")
            _servingSize = State(initialValue: "\(foodItem.servingSize)")
            _proteinPerServing = State(initialValue: "\(foodItem.proteinPerServing)")
            _amountEaten = State(initialValue: "\(foodItem.amountEaten)")
            
            // Check if measurement units and stock levels are non-empty arrays
            _servingType = State(initialValue: foodItem.servingType)
            _stockLevel = State(initialValue: foodItem.stock)
            _eatenServingType = State(initialValue: foodItem.eatenServingType)
        }
    
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
                        Section(header: Text("Food Name")) {
                            TextField("Food Name", text: $name)
                            
                        }
                        
                        Section(header: Text("Calories per serving")){
                            HStack {
                                HStack{
                                    TextField("Calories per Serving", text: $caloriesPerServing)
                                    TextField("Serving Size", text: $servingSize)
                                }
                                
                                Picker("Measurement Units", selection: $servingType) {
                                    ForEach(FoodItem.measurementUnits, id: \.self) { unit in
                                        Text(unit)
                                    }
                                }
                            }
                        }
                        
                        
                        HStack{
                            
                            VStack{
                                Section(header: Text("Amount Eaten")){
                                    TextField("Amount Eaten", text: $amountEaten)
                                    
                                }
                                Section(header: Text("Protein per Serving")){
                                    TextField("Protein per Serving", text: $proteinPerServing)
                                    
                                }
                                Picker("Measurement Units", selection: $eatenServingType) {
                                    ForEach(FoodItem.measurementUnits, id: \.self) { unit in
                                        Text(unit)
                                    }
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                        Section(header: Text("Stock Details")) {
                            Picker("Stock Level", selection: $stockLevel) {
                                ForEach(FoodItem.stockLevel, id: \.self) { stock in
                                    Text(stock)
                                }
                            }
                        }
                        
                        Section(header: Text("Calculated Values")) {
                            Text("Total Calories: \(calories, specifier: "%.1f")")
                            Text("Total Protein: \(protein, specifier: "%.1f")")
                        }
                    }
                    .navigationBarTitle("Edit Food Item")
                    .navigationBarItems(
                        leading:
                            Button("Cancel") {
                                dismiss()
                            },
                        trailing:
                            Button("Save") {
                                saveChanges()
                                dismiss()
                            }
                    )
                }
            }
            
    private func saveChanges() {
        // Create a new instance of FoodItem with updated values
        let updatedFoodItem = FoodItem(
            id: foodItem.id,
            name: name,
            calories: calories,
            caloriesPerServing: caloriesPerServing,
            servingSize: servingSize,
            servingType: servingType,
            eatenServingType: eatenServingType,
            amountEaten: amountEaten,
            proteinPerServing: proteinPerServing,
            protein: protein,
            stock: stockLevel
        )
        
        // Find the index of the foodItem in the appropriate meal category
        if let index = dayManager.selectedDay.breakfast.firstIndex(where: { $0.id == foodItem.id }) {
            dayManager.selectedDay.breakfast[index] = updatedFoodItem
        } else if let index = dayManager.selectedDay.lunch.firstIndex(where: { $0.id == foodItem.id }) {
            dayManager.selectedDay.lunch[index] = updatedFoodItem
        } else if let index = dayManager.selectedDay.dinner.firstIndex(where: { $0.id == foodItem.id }) {
            dayManager.selectedDay.dinner[index] = updatedFoodItem
        }
        
        
        // Update the selected day in the day manager
        dayManager.updateSelectedDay()
        
        refreshID = UUID()

    }
    
}
