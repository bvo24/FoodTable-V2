//
//  EditView.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/31/24.
//Essentially this creates a new food item and we just replace the old one wih it

import SwiftUI

struct EditView: View {
    //Keeping track of what day we're on and update it.
    @ObservedObject var dayManager: DayManager
    @Environment(\.dismiss) var dismiss
    
    //Pass in the original food item we want to update
    //This allows us to have previous values
    var foodItem: FoodItem
    
    //Force refresh after updating
    @Binding var refreshID: UUID
    
    
    //Food item basic info
    @State private var name: String
    @State private var caloriesPerServing: String
    @State private var servingSize: String
    @State private var proteinPerServing: String
    @State private var amountEaten: String
    @State private var servingType: String
    @State private var stockLevel: String
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
            
    
                //Use this if NavigationBarTitle is with Large Font
//                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]

                //Use this if NavigationBarTitle is with displayMode = .inline
//                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
            
        
        }
    
    
    //Turn everything into grams, easier conversion
    let conversionFactors: [String: Double] = [
        "g": 1.0,      // Grams
        "kg": 1000.0,  // Kilograms to grams
        "oz": 28.35,   // Ounces to grams
        "lbs": 453.59, // Pounds to grams
        "ml": 1.0,     // Milliliters (assuming water density)
        "l": 1000.0,   // Liters to milliliters
        "cups": 236.59,
        "piece(s)": 1.0// Cups to milliliters (standard conversion)
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


    var body: some View {
        NavigationStack {
                    Form {
                        Section(header: Text("Food Name")) {
                            TextField("Food Name", text: $name)
                            
                        }
                        .listRowBackground(Color.lightWood)
                        .foregroundStyle(.white)
                        
                        Section("Per serving\n(calories/protein/amount)"){
                            HStack {
                                HStack{
                                    TextField("Cals", text: $caloriesPerServing)
                                    
                                    TextField("Protein", text: $proteinPerServing)
                                    
                                    TextField("Amount", text: $servingSize)
                                        
                                }
                                
                                
                                Picker("Measurement Units", selection: $servingType) {
                                    ForEach(FoodItem.measurementUnits, id: \.self) { unit in
                                        Text(unit)
                                    }
                                }
                                .tint(.white)
                                .labelsHidden()
                            }
                        }
                        .listRowBackground(Color.lightWood)
                        .foregroundStyle(.white)
                        
                        Section("Consumption Details"){
                            HStack{
                                
                                TextField("Amount Eaten", text: $amountEaten)
                                
                                Picker("Measurement Units", selection: $eatenServingType) {
                                    ForEach(FoodItem.measurementUnits, id: \.self) { unit in
                                        Text(unit)
                                    }
                                }
                                .tint(.white)
                                
                            }
                        }
                        .listRowBackground(Color.lightWood)
                        .foregroundStyle(.white)
                        
                        
                        
                        
                        Section(header: Text("Stock Details")) {
                            Picker("Stock Level", selection: $stockLevel) {
                                ForEach(FoodItem.stockLevel, id: \.self) { stock in
                                    Text(stock)
                                        
                                }
                            }
                            .tint(.white)
                            
                            
                            
                           
                            
                        }
                        .listRowBackground(Color.lightWood)
                        .foregroundStyle(.white)
                        
                        
                        Section(header: Text("Calculated Values")) {
                            Text("Total Calories: \(calories, specifier: "%.1f")")
                            Text("Total Protein: \(protein, specifier: "%.1f")")
                        }
                        .listRowBackground(Color.lightWood)
                        .foregroundStyle(.white)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.darkWood)
                    .navigationBarTitle("Edit Food Item")
                    .background(
                        CustomNavigationBar(backgroundColor: UIColor.lightBrown, titleColor: UIColor.black)
                    )
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                        
                        ToolbarItem{
                            Button("Add"){
                                saveChanges()
                                dismiss()
                            }
                            
                            
                        }
                    }
                }
                .navigationBarBackButtonHidden(true) // Hide the back button
            }
            
    private func saveChanges() {
        // Create a new instance of FoodItem with updated values
        let updatedFoodItem = FoodItem(
            id: foodItem.id,
            name: name,
//            calories: calories,
            caloriesPerServing: caloriesPerServing,
            servingSize: servingSize,
            servingType: servingType,
            eatenServingType: eatenServingType,
            amountEaten: amountEaten,
            proteinPerServing: proteinPerServing,
//            protein: protein,
            stock: stockLevel
        )
        
       
        
        // Find the index of the foodItem in the appropriate meal category and swap it to the new fooditem
        if let index = dayManager.selectedDay.breakfast.firstIndex(where: { $0.id == foodItem.id }) {
//            print("Before updating food item:")
//            print("Protein Count: \(dayManager.selectedDay.proteinCount)")
//            print("Total Protein: \(dayManager.selectedDay.totalProtein)")
            
            dayManager.selectedDay.breakfast[index] = updatedFoodItem
            
//            print("After updating food item:")
//            print("Protein Count: \(dayManager.selectedDay.proteinCount)")
//            print("Total Protein: \(dayManager.selectedDay.totalProtein)")
        } else if let index = dayManager.selectedDay.lunch.firstIndex(where: { $0.id == foodItem.id }) {
            dayManager.selectedDay.lunch[index] = updatedFoodItem
        } else if let index = dayManager.selectedDay.dinner.firstIndex(where: { $0.id == foodItem.id }) {
            dayManager.selectedDay.dinner[index] = updatedFoodItem
        }
        
        
       
        
        //Update the selected day in the day manager
        dayManager.updateSelectedDay()
        
        //Make sure we show the updated page
        refreshID = UUID()

    }
    
}
