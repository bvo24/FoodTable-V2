//
//  FoodItem.swift
//  FoodTable
//
//  Created by Brian Vo on 5/27/24.
//

import Foundation

struct FoodItem : Identifiable, Codable, Hashable{
    
    static let measurementUnits = [
            "g", "kg", "oz", "lbs", "ml", "l", "cups", "tsp", "tbsp", "fl oz", "piece(s)"
        ]
    
    static let stockLevel = [ "Low", "Medium", "High"]
    
    //Not sure if UUID() is ideal?... What if I update this item would it get affected?..
    var id : UUID
    var name : String
    var calories : Double
    var caloriesPerServing : String
    
    var servingSize : String
    //In our crafting menu we should see this type when creating/adding to recipe
    var servingType : String
    var eatenServingType : String
    var amountEaten : String
    var proteinPerServing : String
    var protein : Double
    var stock : String
    
    static let example: [FoodItem] = [
        FoodItem(id: UUID(), name: "Apple", calories: 95, caloriesPerServing: "30", servingSize: "1", servingType: "grams", eatenServingType: "grams", amountEaten: "0", proteinPerServing: "10", protein: 4.0, stock: "low"),
        FoodItem(id: UUID(), name: "Banana", calories: 105, caloriesPerServing: "5", servingSize: "1", servingType: "grams", eatenServingType: "grams", amountEaten: "0", proteinPerServing: "10", protein: 1.0, stock: "medium"),
        FoodItem(id: UUID(), name: "Chicken Breast", calories: 165, caloriesPerServing: "2", servingSize: "100", servingType: "grams", eatenServingType: "grams", amountEaten: "0", proteinPerServing: "32", protein: 31.0, stock: "high")
       ]
    
    var hasValidItem : Bool{
        
        // Check if empty field
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false // Name is required and cannot be empty
            }
            
            // Chekc if number is inputted
            guard let caloriesValue = Double(caloriesPerServing.trimmingCharacters(in: .whitespacesAndNewlines)),
                  let servingSizeValue = Double(servingSize.trimmingCharacters(in: .whitespacesAndNewlines)),
                  let proteinValue = Double(proteinPerServing.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                return false // Invalid numeric input
            }
            
            // Make sure it's not negative
            if caloriesValue <= 0 || servingSizeValue <= 0 || proteinValue <= 0 {
                return false
            }
            
            return true
        
        
        
        
    }
    
    
    
    
}

